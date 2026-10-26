import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CvDraft {
  const CvDraft({
    required this.title,
    required this.targetOpportunity,
    required this.profile,
    required this.skills,
    required this.projects,
    this.education = '',
  });

  final String title;
  final String targetOpportunity;
  final String profile;
  final String skills;
  final String projects;
  final String education;

  String get plainText => [
    title,
    targetOpportunity,
    '',
    'PROFILE',
    profile,
    '',
    'EDUCATION',
    education,
    '',
    'STRENGTHS',
    skills,
    '',
    'PROJECTS & EXPERIENCE',
    projects,
  ].where((line) => line.trim().isNotEmpty).join('\n');

  Map<String, dynamic> toMap() => {
    'title': title,
    'targetOpportunity': targetOpportunity,
    'profile': profile,
    'skills': skills,
    'projects': projects,
    'education': education,
    'updatedAt': FieldValue.serverTimestamp(),
  };
}

class CvService {
  CvService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Future<CvDraft?> loadDraft() async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Sign in to load your CV draft.');
    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('privateDrafts')
        .doc('cv')
        .get();
    final data = snapshot.data();
    if (!snapshot.exists || data == null) return null;
    return CvDraft(
      title: data['title'] as String? ?? '',
      targetOpportunity: data['targetOpportunity'] as String? ?? '',
      profile: data['profile'] as String? ?? '',
      skills: data['skills'] as String? ?? '',
      projects: data['projects'] as String? ?? '',
      education: data['education'] as String? ?? '',
    );
  }

  Future<void> saveDraft(CvDraft draft) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('Sign in to save your CV draft.');
    }
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('privateDrafts')
        .doc('cv')
        .set(draft.toMap(), SetOptions(merge: true));
  }
}