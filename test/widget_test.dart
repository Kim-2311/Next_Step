import 'package:flutter_test/flutter_test.dart';
import 'package:next_step/models/application_record.dart';
import 'package:next_step/models/student_profile.dart';

void main() {
  group('StudentProfile', () {
    test('estimates APS from six subjects and excludes Life Orientation', () {
      const profile = StudentProfile(
        matricSubjects: {
          'English': 85,
          'Mathematics': 74,
          'Life Orientation': 100,
          'Physical Sciences': 66,
          'Life Sciences': 57,
          'History': 45,
          'Geography': 33,
          'Additional subject': 100,
        },
      );

      expect(profile.estimatedAps, 27);
    });

    test('round-trips profile values through its persistence map', () {
      const profile = StudentProfile(
        fullName: 'Sam Example',
        province: 'Gauteng',
        primaryGoal: 'work',
        willingToRelocate: true,
        interests: ['Technology'],
        pathways: ['Find a job'],
        matricSubjects: {'Mathematics': 72},
      );

      final restored = StudentProfile.fromMap(profile.toMap());

      expect(restored.fullName, profile.fullName);
      expect(restored.province, profile.province);
      expect(restored.primaryGoal, profile.primaryGoal);
      expect(restored.willingToRelocate, isTrue);
      expect(restored.interests, profile.interests);
      expect(restored.pathways, profile.pathways);
      expect(restored.matricSubjects, profile.matricSubjects);
    });
  });

  test('offers Plan B after rejection or waitlisting', () {
    expect(
      const ApplicationRecord(
        opportunityId: 'example',
        status: 'Rejected',
      ).shouldOfferPlanB,
      isTrue,
    );
    expect(
      const ApplicationRecord(
        opportunityId: 'example',
        status: 'Waitlisted',
      ).shouldOfferPlanB,
      isTrue,
    );
    expect(
      const ApplicationRecord(
        opportunityId: 'example',
        status: 'Applied',
      ).shouldOfferPlanB,
      isFalse,
    );
  });
}
