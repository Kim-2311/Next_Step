import 'package:flutter/material.dart';

import '../../models/application_record.dart';
import '../../models/opportunity.dart';
import '../../services/opportunity_service.dart';
import '../../services/student_service.dart';
import '../../widgets/app_components.dart';
import '../applications/application_tracker_screen.dart';
import '../apply_assist/apply_assist_screen.dart';

class OpportunityDetailsScreen extends StatefulWidget {
  const OpportunityDetailsScreen({super.key, this.opportunity});

  final Opportunity? opportunity;

  @override
  State<OpportunityDetailsScreen> createState() =>
      _OpportunityDetailsScreenState();
}

class _OpportunityDetailsScreenState extends State<OpportunityDetailsScreen> {
  Opportunity get _item =>
      widget.opportunity ?? OpportunityService.sampleOpportunities.first;
  bool _loading = true;
  bool _saving = false;
  bool _saved = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    try {
      final ids = await StudentService().getSavedOpportunityIds();
      if (mounted) {
        setState(() {
          _saved = ids.contains(_item.id);
          _loading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _loading = false;
          _loadError = error.toString();
        });
      }
    }
  }

  Future<void> _toggleSaved() async {
    setState(() => _saving = true);
    try {
      await StudentService().setOpportunitySaved(_item.id, !_saved);
      if (mounted) {
        setState(() => _saved = !_saved);
        showAppMessage(
          context,
          _saved ? 'Saved for later.' : 'Removed from saved opportunities.',
        );
      }
    } catch (error) {
      if (mounted) showAppMessage(context, 'Could not update saved items: $error');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _addToTracker() async {
    try {
      await StudentService().saveApplication(
        ApplicationRecord(opportunityId: _item.id, status: 'Interested'),
      );
      if (!mounted) return;
      showAppMessage(context, 'Added to your application tracker.');
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const ApplicationTrackerScreen(),
        ),
      );
    } catch (error) {
      if (mounted) showAppMessage(context, 'Could not add to tracker: $error');
    }
  }

  @override
  Widget build(BuildContext context) => AppPage(
    title: _item.title,
    subtitle: '${_item.provider} · Illustrative opportunity',
    children: [
      const InfoPanel(
        child: Text(
          'Illustrative example only. This is not a live opening and no real provider verification is claimed.',
          style: TextStyle(color: nextStepMuted, height: 1.5),
        ),
      ),
      const SizedBox(height: 14),
      InfoPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CLOSING DATE · EXAMPLE',
              style: TextStyle(
                color: nextStepPurple,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _item.closingDateLabel,
              style: const TextStyle(
                color: nextStepInk,
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(_item.location),
            Text(_item.duration),
          ],
        ),
      ),
      const SizedBox(height: 18),
      Text(
        _item.summary,
        style: const TextStyle(color: nextStepInk, height: 1.55),
      ),
      const SizedBox(height: 18),
      const Text(
        'Example entry requirements',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 8),
      Text(
        _item.requirements,
        style: const TextStyle(color: nextStepMuted, height: 1.5),
      ),
      const SizedBox(height: 14),
      if (_item.fundingLabel != null)
        InfoPanel(child: Text('Funding note: ${_item.fundingLabel}')),
      if (_item.estimatedCost != null) ...[
        const SizedBox(height: 10),
        InfoPanel(child: Text('Cost note: ${_item.estimatedCost}')),
      ],
      const SizedBox(height: 14),
      const InfoPanel(
        color: Color(0xFFE4F5F2),
        child: Text(
          'Criteria, deadlines, fees and final admission or funding decisions must be confirmed with the provider.',
          style: TextStyle(color: Color(0xFF11857C), height: 1.5),
        ),
      ),
      const SizedBox(height: 16),
      if (_loadError != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            'Saved state could not be loaded: $_loadError',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      PrimaryAction(
        label: _saving ? 'Saving…' : 'Save opportunity',
        onPressed: _saving || _loading ? null : _toggleSaved,
        icon: _saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
      ),
      const SizedBox(height: 8),
      OutlinedButton(
        onPressed: _addToTracker,
        child: const Text('Add to application tracker'),
      ),
      const SizedBox(height: 8),
      OutlinedButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ApplyAssistScreen(opportunity: _item),
          ),
        ),
        child: const Text('Prepare with Apply Assist'),
      ),
      const SizedBox(height: 10),
      const Text(
        'No verified official URL is attached to this sample, so we will not guess a destination.',
        style: TextStyle(color: nextStepMuted, height: 1.5),
      ),
    ],
  );
}
