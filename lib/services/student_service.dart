import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/application_record.dart';
import '../models/student_profile.dart';

class StudentService {
  StudentService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> get _userDocument {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('Sign in to save your NextStep information.');
    }
    return _firestore.collection('users').doc(user.uid);
  }

  Future<StudentProfile?> loadProfile() async {
    final snapshot = await _userDocument.get();
    final data = snapshot.data();
    return snapshot.exists && data != null ? StudentProfile.fromMap(data) : null;
  }

  Future<void> saveProfile(StudentProfile profile) async {
    await _userDocument.set(profile.toMap(), SetOptions(merge: true));
  }

  Future<Set<String>> getSavedOpportunityIds() async {
    final snapshot = await _userDocument.collection('savedOpportunities').get();
    return snapshot.docs.map((document) => document.id).toSet();
  }

  Future<void> setOpportunitySaved(String opportunityId, bool saved) async {
    final reference = _userDocument
        .collection('savedOpportunities')
        .doc(opportunityId);
    if (saved) {
      await reference.set({
        'opportunityId': opportunityId,
        'savedAt': FieldValue.serverTimestamp(),
      });
    } else {
      await reference.delete();
    }
  }

  Future<List<ApplicationRecord>> getApplications() async {
    final snapshot = await _userDocument.collection('applications').get();
    return snapshot.docs
        .map((document) => ApplicationRecord.fromMap(document.data()))
        .toList();
  }

  Future<void> saveApplication(ApplicationRecord application) async {
    if (!applicationStatuses.contains(application.status)) {
      throw ArgumentError.value(application.status, 'status');
    }
    await _userDocument
        .collection('applications')
        .doc(application.opportunityId)
        .set(application.toMap(), SetOptions(merge: true));
  }

  Future<void> deleteAccountData() async {
    final userReference = _userDocument;
    final collections = await Future.wait([
      userReference.collection('savedOpportunities').get(),
      userReference.collection('applications').get(),
      userReference.collection('privateDrafts').get(),
    ]);
    final batch = _firestore.batch();
    for (final collection in collections) {
      for (final document in collection.docs) {
        batch.delete(document.reference);
      }
    }
    batch.delete(userReference);
    await batch.commit();
  }
}
