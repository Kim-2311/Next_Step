import 'package:flutter/material.dart';

import '../../models/application_record.dart';
import '../../models/opportunity.dart';
import '../navigation/app_navigation.dart';
import '../../services/opportunity_service.dart';
import '../../services/student_service.dart';
import '../../widgets/app_components.dart';
import '../apply_assist/apply_assist_screen.dart';
import '../plan_b/plan_b_screen.dart';

class ApplicationTrackerScreen extends StatefulWidget {
  const ApplicationTrackerScreen({super.key});

  @override
  State<ApplicationTrackerScreen> createState() =>
      _ApplicationTrackerScreenState();
}

class _ApplicationTrackerScreenState extends State<ApplicationTrackerScreen> {
  final _students = StudentService();
  final _opportunities = OpportunityService();
  List<ApplicationRecord> _records = const [];
  bool _loading = true;
  String? _error;
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final records = await _students.getApplications();
      if (!mounted) return;
      setState(() {
        _records = records;
        _error = null;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  Future<void> _update(ApplicationRecord record, String status) async {
    final updated = ApplicationRecord(
      opportunityId: record.opportunityId,
      status: status,
      notes: record.notes,
      readyDocuments: record.readyDocuments,
    );
    try {
      await _students.saveApplication(updated);
      if (!mounted) return;
      setState(() {
        _records = [
          for (final current in _records)
            if (current.opportunityId == updated.opportunityId)
              updated
            else
              current,
        ];
      });
      if (updated.shouldOfferPlanB) {
        final openPlanB = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Want to explore other options?'),
            content: const Text(
              'A different route may still fit your goals. Explore options without pressure.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Not now'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Explore Plan B'),
              ),
            ],
          ),
        );
        if (openPlanB == true && mounted) {
          await AppNavigation.open<void>(context, const PlanBScreen());
        }
      }
    } catch (error) {
      if (mounted) showAppMessage(context, 'Could not update status: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleRecords = _records.where((record) {
      if (_filter == 'All') return true;
      return record.status == _filter;
    }).toList();

    return AppPage(
      title: 'One place for every next step.',
      subtitle: 'Application Tracker · Keep your own progress up to date.',
      children: [
        InfoPanel(
          child: Text(
            '${_records.length} ${_records.length == 1 ? 'application' : 'applications'} · '
            '${_records.where((record) => ['Preparing documents', 'Ready to apply', 'Applied', 'Awaiting response'].contains(record.status)).length} in progress',
            style: const TextStyle(
              color: nextStepInk,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'FILTER BY STATUS',
          style: TextStyle(
            color: nextStepPurple,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _filter,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: ['All', ...applicationStatuses].map((status) {
            return DropdownMenuItem(value: status, child: Text(status));
          }).toList(),
          onChanged: (value) => setState(() => _filter = value ?? 'All'),
        ),
        const SizedBox(height: 18),
        if (_loading)
          const Center(child: CircularProgressIndicator())
        else if (_error != null)
          InfoPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your tracker could not be loaded.'),
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: nextStepMuted)),
                TextButton(onPressed: _load, child: const Text('Try again')),
              ],
            ),
          )
        else if (visibleRecords.isEmpty)
          InfoPanel(
            child: Column(
              children: [
                const Icon(
                  Icons.assignment_outlined,
                  color: nextStepPurple,
                  size: 42,
                ),
                const SizedBox(height: 8),
                Text(
                  _records.isEmpty
                      ? 'No applications yet'
                      : 'No applications with this status',
                  style: const TextStyle(
                    color: nextStepInk,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Save an opportunity or prepare an application to start tracking your own progress.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: nextStepMuted, height: 1.45),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => AppNavigation.openExplore<void>(context),
                  child: const Text('Explore opportunities'),
                ),
              ],
            ),
          )
        else
          ...visibleRecords.map((record) {
            final opportunity = _opportunities.byId(record.opportunityId);
            if (opportunity == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _ApplicationCard(
                opportunity: opportunity,
                record: record,
                onStatusChanged: (status) => _update(record, status),
                onOpen: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ApplicationDetailScreen(
                      opportunity: opportunity,
                      record: record,
                    ),
                  ),
                ),
                onAssist: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ApplyAssistScreen(opportunity: opportunity),
                  ),
                ),
              ),
            );
          }),
        const SizedBox(height: 14),
        const InfoPanel(
          color: Color(0xFFE4F5F2),
          child: Text(
            'Statuses are your own records, not confirmations from providers. NextStep does not submit applications for you.',
            style: TextStyle(color: Color(0xFF11857C), height: 1.5),
          ),
        ),
      ],
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  const _ApplicationCard({
    required this.opportunity,
    required this.record,
    required this.onStatusChanged,
    required this.onOpen,
    required this.onAssist,
  });

  final Opportunity opportunity;
  final ApplicationRecord record;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onOpen;
  final VoidCallback onAssist;

  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(color: nextStepBorder),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  record.status,
                  style: const TextStyle(
                    color: nextStepPurple,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Application details',
                onPressed: onOpen,
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          Text(
            opportunity.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: nextStepInk,
            ),
          ),
          Text(
            opportunity.provider,
            style: const TextStyle(color: nextStepMuted),
          ),
          const SizedBox(height: 8),
          Text(
            'Illustrative example · closes ${opportunity.closingDateLabel}',
            style: const TextStyle(color: nextStepMuted),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: record.status,
            decoration: const InputDecoration(
              labelText: 'Update your status',
              border: OutlineInputBorder(),
            ),
            items: applicationStatuses
                .map(
                  (status) =>
                      DropdownMenuItem(value: status, child: Text(status)),
                )
                .toList(),
            onChanged: (value) {
              if (value != null && value != record.status) {
                onStatusChanged(value);
              }
            },
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onAssist,
            icon: const Icon(Icons.checklist_rounded),
            label: const Text('Prepare with Apply Assist'),
          ),
        ],
      ),
    ),
  );
}

class ApplicationDetailScreen extends StatefulWidget {
  const ApplicationDetailScreen({
    required this.opportunity,
    required this.record,
    super.key,
  });

  final Opportunity opportunity;
  final ApplicationRecord record;

  @override
  State<ApplicationDetailScreen> createState() =>
      _ApplicationDetailScreenState();
}

class _ApplicationDetailScreenState extends State<ApplicationDetailScreen> {
  static const _documents = [
    'Certified ID copy',
    'Matric statement of results',
    'Proof of address',
    'Motivation letter',
  ];
  late final Set<String> _ready = {...widget.record.readyDocuments};
  late final TextEditingController _notes = TextEditingController(
    text: widget.record.notes,
  );
  String _status = '';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _status = widget.record.status;
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await StudentService().saveApplication(
        ApplicationRecord(
          opportunityId: widget.opportunity.id,
          status: _status,
          notes: _notes.text.trim(),
          readyDocuments: _ready.toList(),
        ),
      );
      if (mounted) showAppMessage(context, 'Your progress was saved.');
      if (mounted && (_status == 'Rejected' || _status == 'Waitlisted')) {
        final openPlanB = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Want to explore other options?'),
            content: const Text(
              'A different route may still fit your goals. Explore options without pressure.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Not now'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Explore Plan B'),
              ),
            ],
          ),
        );
        if (openPlanB == true && mounted) {
          await Navigator.of(
            context,
          ).push(MaterialPageRoute<void>(builder: (_) => const PlanBScreen()));
        }
      }
    } catch (error) {
      if (mounted) showAppMessage(context, 'Could not save progress: $error');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => AppPage(
    title: widget.opportunity.title,
    subtitle: 'Application Progress · ${widget.opportunity.provider}',
    children: [
      InfoPanel(
        child: Text(
          'Example deadline · ${widget.opportunity.closingDateLabel}\n'
          'Always confirm dates with the official provider.',
          style: const TextStyle(color: nextStepInk, height: 1.5),
        ),
      ),
      const SizedBox(height: 18),
      Text(
        'Documents ready: ${_ready.length} of ${_documents.length}',
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      ..._documents.map(
        (document) => CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(document),
          value: _ready.contains(document),
          onChanged: (checked) => setState(() {
            if (checked == true) {
              _ready.add(document);
            } else {
              _ready.remove(document);
            }
          }),
        ),
      ),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
        initialValue: _status,
        decoration: const InputDecoration(
          labelText: 'Current status',
          border: OutlineInputBorder(),
        ),
        items: applicationStatuses
            .map(
              (status) => DropdownMenuItem(value: status, child: Text(status)),
            )
            .toList(),
        onChanged: (value) => setState(() => _status = value ?? _status),
      ),
      const SizedBox(height: 14),
      TextField(
        controller: _notes,
        maxLines: 4,
        decoration: const InputDecoration(
          labelText: 'Personal notes',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 14),
      PrimaryAction(
        label: _saving ? 'Saving…' : 'Save progress',
        onPressed: _saving ? null : _save,
        icon: Icons.check_rounded,
      ),
      const SizedBox(height: 12),
      OutlinedButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ApplyAssistScreen(opportunity: widget.opportunity),
          ),
        ),
        child: const Text('Prepare with Apply Assist'),
      ),
      const SizedBox(height: 12),
      const Text(
        'Checklist only. No documents are uploaded or sent to the institution.',
        style: TextStyle(color: nextStepMuted, height: 1.5),
      ),
    ],
  );
}
