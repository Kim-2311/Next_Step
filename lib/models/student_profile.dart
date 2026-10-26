class StudentProfile {
  const StudentProfile({
    this.fullName = '',
    this.town = '',
    this.province = 'KwaZulu-Natal',
    this.matricYear = '2025',
    this.educationStatus = 'Matric completed',
    this.willingToRelocate = false,
    this.primaryGoal = 'study',
    this.interests = const [],
    this.pathways = const [],
    this.matricSubjects = const {},
    this.needsFunding = true,
    this.fundingNeed = 'Tuition, books & transport',
  });

  final String fullName;
  final String town;
  final String province;
  final String matricYear;
  final String educationStatus;
  final bool willingToRelocate;
  final String primaryGoal;
  final List<String> interests;
  final List<String> pathways;
  final Map<String, int> matricSubjects;
  final bool needsFunding;
  final String fundingNeed;

  int get estimatedAps => matricSubjects.entries
      .where((entry) => entry.key.toLowerCase() != 'life orientation')
      .take(6)
      .fold(0, (sum, entry) => sum + apsPoints(entry.value));

  Map<String, dynamic> toMap() => {
    'fullName': fullName,
    'town': town,
    'province': province,
    'matricYear': matricYear,
    'educationStatus': educationStatus,
    'willingToRelocate': willingToRelocate,
    'primaryGoal': primaryGoal,
    'interests': interests,
    'pathways': pathways,
    'matricSubjects': matricSubjects,
    'needsFunding': needsFunding,
    'fundingNeed': fundingNeed,
    'updatedAt': DateTime.now().toUtc().toIso8601String(),
  };

  factory StudentProfile.fromMap(Map<String, dynamic> map) {
    final rawSubjects = map['matricSubjects'];
    final subjects = <String, int>{};
    if (rawSubjects is Map) {
      for (final entry in rawSubjects.entries) {
        final mark = entry.value;
        if (mark is num) subjects[entry.key.toString()] = mark.toInt();
      }
    }
    return StudentProfile(
      fullName: map['fullName'] as String? ?? '',
      town: map['town'] as String? ?? '',
      province: map['province'] as String? ?? 'KwaZulu-Natal',
      matricYear: map['matricYear'] as String? ?? '2025',
      educationStatus: map['educationStatus'] as String? ?? 'Matric completed',
      willingToRelocate: map['willingToRelocate'] as bool? ?? false,
      primaryGoal: map['primaryGoal'] as String? ?? 'study',
      interests: _stringList(map['interests']),
      pathways: _stringList(map['pathways']),
      matricSubjects: subjects,
      needsFunding: map['needsFunding'] as bool? ?? true,
      fundingNeed:
          map['fundingNeed'] as String? ?? 'Tuition, books & transport',
    );
  }

  StudentProfile copyWith({
    String? fullName,
    String? town,
    String? province,
    String? matricYear,
    String? educationStatus,
    bool? willingToRelocate,
    String? primaryGoal,
    List<String>? interests,
    List<String>? pathways,
    Map<String, int>? matricSubjects,
    bool? needsFunding,
    String? fundingNeed,
  }) => StudentProfile(
    fullName: fullName ?? this.fullName,
    town: town ?? this.town,
    province: province ?? this.province,
    matricYear: matricYear ?? this.matricYear,
    educationStatus: educationStatus ?? this.educationStatus,
    willingToRelocate: willingToRelocate ?? this.willingToRelocate,
    primaryGoal: primaryGoal ?? this.primaryGoal,
    interests: interests ?? this.interests,
    pathways: pathways ?? this.pathways,
    matricSubjects: matricSubjects ?? this.matricSubjects,
    needsFunding: needsFunding ?? this.needsFunding,
    fundingNeed: fundingNeed ?? this.fundingNeed,
  );
}

int apsPoints(int mark) {
  if (mark >= 80) return 7;
  if (mark >= 70) return 6;
  if (mark >= 60) return 5;
  if (mark >= 50) return 4;
  if (mark >= 40) return 3;
  if (mark >= 30) return 2;
  return 1;
}

List<String> _stringList(dynamic value) => value is Iterable
    ? value.whereType<String>().toList()
    : const [];
