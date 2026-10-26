import 'package:flutter/material.dart';

import '../../models/application_record.dart';
import '../../models/opportunity.dart';
import '../../services/opportunity_service.dart';
import '../../services/student_service.dart';
import '../../widgets/app_components.dart';

class ApplyAssistScreen extends StatefulWidget {
  const ApplyAssistScreen({super.key, this.opportunity});

  final Opportunity? opportunity;

  @override
  State<ApplyAssistScreen> createState() => _ApplyAssistScreenState();
}

class _ApplyAssistScreenState extends State<ApplyAssistScreen> {
  static const _documents = [
    'Certified ID copy',
    'Matric statement of results',
    'Proof of address',
    'Motivation letter',
  ];
  late final Opportunity _opportunity =
      widget.opportunity ?? OpportunityService().byId('diploma-it')!;
  final Set<String> _readyDocuments = {};
  bool _checkedOfficialWebsite = false;
  bool _checkedRequirements = false;
  bool _saving = false;
  bool _loadingProgress = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    try {
      final records = await StudentService().getApplications();
      final matching = records.where(
        (record) => record.opportunityId == _opportunity.id,
      );
      if (!mounted) return;
      setState(() {
        if (matching.isNotEmpty) {
          _readyDocuments.addAll(matching.first.readyDocuments);
        }
        _loadingProgress = false;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _loadError = error.toString();
          _loadingProgress = false;
        });
      }
    }
  }

  Future<void> _saveProgress() async {
    setState(() => _saving = true);
    try {
      final existing = (await StudentService().getApplications()).where(
        (record) => record.opportunityId == _opportunity.id,
      );
      final oldRecord = existing.isEmpty ? null : existing.first;
      final nextStatus = _readyDocuments.length == _documents.length
          ? 'Ready to apply'
          : 'Preparing documents';
      await StudentService().saveApplication(
        ApplicationRecord(
          opportunityId: _opportunity.id,
          status: oldRecord?.status == 'Applied' ? 'Applied' : nextStatus,
          notes: oldRecord?.notes ?? '',
          readyDocuments: _readyDocuments.toList(),
        ),
      );
      if (!mounted) return;
      showAppMessage(context, 'Your preparation progress was saved.');
    } catch (error) {
      if (mounted) showAppMessage(context, 'Could not save progress: $error');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Apply with a little more confidence.',
    subtitle: 'Prepare your application. You stay in control.',
    children: [
      InfoPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'YOUR APPLICATION',
              style: TextStyle(
                color: nextStepPurple,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _opportunity.title,
              style: const TextStyle(
                color: nextStepInk,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '${_opportunity.provider} · ${_opportunity.town}',
              style: const TextStyle(color: nextStepMuted),
            ),
            const SizedBox(height: 8),
            Text(
              'Illustrative closing date · ${_opportunity.closingDateLabel}',
              style: const TextStyle(color: nextStepPurple),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Your preparation',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              Text('${_readyDocuments.length} of ${_documents.length} ready'),
            ],
          ),
          if (_loadingProgress)
            const LinearProgressIndicator(color: nextStepTeal),
          if (_loadError != null)
            Text(
              'Saved preparation could not be loaded: $_loadError',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
        ],
      ),
      const SizedBox(height: 10),
      LinearProgressIndicator(
        value: _readyDocuments.length / _documents.length,
        color: nextStepTeal,
        backgroundColor: nextStepBorder,
      ),
      const SizedBox(height: 8),
      const Text(
        'Mark an item ready only after you have checked it. Nothing is uploaded or sent.',
        style: TextStyle(color: nextStepMuted, height: 1.5),
      ),
      const SizedBox(height: 18),
      Text(
        'Example requirements · ${_opportunity.requirements}',
        style: const TextStyle(color: nextStepInk, height: 1.5),
      ),
      const SizedBox(height: 16),
      const Text(
        'Get your documents ready',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      ..._documents.map(
        (document) => CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(document),
          value: _readyDocuments.contains(document),
          onChanged: _loadingProgress
              ? null
              : (checked) => setState(() {
                  if (checked == true) {
                    _readyDocuments.add(document);
                  } else {
                    _readyDocuments.remove(document);
                  }
                }),
        ),
      ),
      const SizedBox(height: 12),
      const Text(
        'Your official-source handoff',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text(
          'I checked the provider’s official website and current deadline',
        ),
        value: _checkedOfficialWebsite,
        onChanged: (value) =>
            setState(() => _checkedOfficialWebsite = value ?? false),
      ),
      CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('I reviewed my details and document requirements'),
        value: _checkedRequirements,
        onChanged: (value) =>
            setState(() => _checkedRequirements = value ?? false),
      ),
      PrimaryAction(
        label: 'Continue to official source',
        onPressed: _checkedOfficialWebsite && _checkedRequirements
            ? () => showAppMessage(
                context,
                'This sample has no verified official application link. Search for the provider directly; do not rely on a guessed URL.',
              )
            : null,
        icon: Icons.open_in_new_rounded,
      ),
      const SizedBox(height: 10),
      const Text(
        'This example has no live application portal connected. You submit directly with the institution; NextStep never submits applications or stores your ID number.',
        style: TextStyle(color: nextStepMuted, height: 1.5),
      ),
      const SizedBox(height: 14),
      OutlinedButton(
        onPressed: _saving ? null : _saveProgress,
        child: Text(_saving ? 'Saving…' : 'Save preparation progress'),
      ),
    ],
  );
}
