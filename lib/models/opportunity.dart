class Opportunity {
  const Opportunity({
    required this.id,
    required this.title,
    required this.provider,
    required this.category,
    required this.province,
    required this.town,
    required this.summary,
    required this.requirements,
    required this.closingDate,
    required this.duration,
    this.minimumAps,
    this.minimumMaths,
    this.interests = const [],
    this.isRemote = false,
    this.estimatedCost,
    this.fundingLabel,
    this.sourceUrl,
    this.lastVerified,
    this.isSample = true,
  });

  final String id;
  final String title;
  final String provider;
  final String category;
  final String province;
  final String town;
  final String summary;
  final String requirements;
  final DateTime closingDate;
  final String duration;
  final int? minimumAps;
  final int? minimumMaths;
  final List<String> interests;
  final bool isRemote;
  final String? estimatedCost;
  final String? fundingLabel;
  final String? sourceUrl;
  final DateTime? lastVerified;
  final bool isSample;

  String get track => category == 'study' || category == 'funding'
      ? 'study'
      : 'work';

  String get location =>
      isRemote ? 'Remote · South Africa' : '$town, $province';

  String get closingDateLabel =>
      '${closingDate.day.toString().padLeft(2, '0')} '
      '${_months[closingDate.month - 1]} ${closingDate.year}';

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'provider': provider,
    'category': category,
    'province': province,
    'town': town,
    'summary': summary,
    'requirements': requirements,
    'closingDate': closingDate.toIso8601String(),
    'duration': duration,
    'minimumAps': minimumAps,
    'minimumMaths': minimumMaths,
    'interests': interests,
    'isRemote': isRemote,
    'estimatedCost': estimatedCost,
    'fundingLabel': fundingLabel,
    'sourceUrl': sourceUrl,
    'lastVerified': lastVerified?.toIso8601String(),
    'isSample': isSample,
  };

  factory Opportunity.fromMap(Map<String, dynamic> map) => Opportunity(
    id: map['id'] as String,
    title: map['title'] as String? ?? '',
    provider: map['provider'] as String? ?? '',
    category: map['category'] as String? ?? 'study',
    province: map['province'] as String? ?? 'South Africa',
    town: map['town'] as String? ?? '',
    summary: map['summary'] as String? ?? '',
    requirements: map['requirements'] as String? ?? '',
    closingDate:
        DateTime.tryParse(map['closingDate'] as String? ?? '') ??
        DateTime.utc(2026, 12),
    duration: map['duration'] as String? ?? '',
    minimumAps: (map['minimumAps'] as num?)?.toInt(),
    minimumMaths: (map['minimumMaths'] as num?)?.toInt(),
    interests: map['interests'] is Iterable
        ? (map['interests'] as Iterable).whereType<String>().toList()
        : const [],
    isRemote: map['isRemote'] as bool? ?? false,
    estimatedCost: map['estimatedCost'] as String?,
    fundingLabel: map['fundingLabel'] as String?,
    sourceUrl: map['sourceUrl'] as String?,
    lastVerified: DateTime.tryParse(map['lastVerified'] as String? ?? ''),
    isSample: map['isSample'] as bool? ?? true,
  );
}

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];
