const applicationStatuses = [
  'Interested',
  'Preparing documents',
  'Ready to apply',
  'Applied',
  'Awaiting response',
  'Accepted',
  'Rejected',
  'Waitlisted',
  'Withdrawn',
];

class ApplicationRecord {
  const ApplicationRecord({
    required this.opportunityId,
    required this.status,
    this.notes = '',
    this.readyDocuments = const [],
    this.updatedAt,
  });

  final String opportunityId;
  final String status;
  final String notes;
  final List<String> readyDocuments;
  final DateTime? updatedAt;

  bool get shouldOfferPlanB =>
      status == 'Rejected' || status == 'Waitlisted';

  Map<String, dynamic> toMap() => {
    'opportunityId': opportunityId,
    'status': status,
    'notes': notes,
    'readyDocuments': readyDocuments,
    'updatedAt': (updatedAt ?? DateTime.now()).toUtc().toIso8601String(),
  };

  factory ApplicationRecord.fromMap(Map<String, dynamic> map) =>
      ApplicationRecord(
        opportunityId: map['opportunityId'] as String? ?? '',
        status: applicationStatuses.contains(map['status'])
            ? map['status'] as String
            : 'Interested',
        notes: map['notes'] as String? ?? '',
        readyDocuments: map['readyDocuments'] is Iterable
            ? (map['readyDocuments'] as Iterable).whereType<String>().toList()
            : const [],
        updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? ''),
      );
}
