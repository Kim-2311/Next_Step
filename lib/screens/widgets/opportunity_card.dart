import 'package:flutter/material.dart';

import '../../models/opportunity.dart';
import '../../services/student_service.dart';
import '../../widgets/app_components.dart';
import '../explore/opportunity_details_screen.dart';

class OpportunityCard extends StatefulWidget {
  const OpportunityCard({
    required this.opportunity,
    super.key,
    this.onSavedChanged,
  });

  final Opportunity opportunity;
  final ValueChanged<bool>? onSavedChanged;

  @override
  State<OpportunityCard> createState() => _OpportunityCardState();
}

class _OpportunityCardState extends State<OpportunityCard> {
  late Future<bool> _saved = _loadSaved();
  bool _updating = false;

  Future<bool> _loadSaved() async =>
      (await StudentService().getSavedOpportunityIds())
          .contains(widget.opportunity.id);

  Future<void> _toggleSaved(bool current) async {
    setState(() => _updating = true);
    try {
      await StudentService().setOpportunitySaved(
        widget.opportunity.id,
        !current,
      );
      if (!mounted) return;
      setState(() => _saved = Future<bool>.value(!current));
      widget.onSavedChanged?.call(!current);
      showAppMessage(
        context,
        current ? 'Removed from your saved opportunities.' : 'Saved for later.',
      );
    } catch (error) {
      if (mounted) showAppMessage(context, 'Could not update saved items: $error');
    } finally {
      if (mounted) setState(() => _updating = false);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
    future: _saved,
    builder: (context, snapshot) {
      final saved = snapshot.data ?? false;
      return Card(
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
                      '${widget.opportunity.category.toUpperCase()} · '
                      '${widget.opportunity.isSample ? 'EXAMPLE' : 'VERIFIED'}',
                      style: const TextStyle(
                        color: nextStepPurple,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (snapshot.hasError)
                    IconButton(
                      tooltip: 'Retry loading saved state',
                      onPressed: () =>
                          setState(() => _saved = _loadSaved()),
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  IconButton(
                    tooltip: saved ? 'Remove saved opportunity' : 'Save opportunity',
                    onPressed: _updating || !snapshot.hasData
                        ? null
                        : () => _toggleSaved(saved),
                    icon: Icon(
                      saved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: nextStepPurple,
                    ),
                  ),
                ],
              ),
              Text(
                widget.opportunity.title,
                style: const TextStyle(
                  color: nextStepInk,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.opportunity.provider,
                style: const TextStyle(color: nextStepMuted),
              ),
              const SizedBox(height: 10),
              Text(
                widget.opportunity.location,
                style: const TextStyle(color: nextStepMuted),
              ),
              const SizedBox(height: 8),
              Text(
                widget.opportunity.duration,
                style: const TextStyle(color: nextStepMuted),
              ),
              const SizedBox(height: 8),
              Text(
                widget.opportunity.requirements,
                style: const TextStyle(
                  color: nextStepInk,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Closes ${widget.opportunity.closingDateLabel}',
                style: const TextStyle(color: nextStepPurple),
              ),
              if (snapshot.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'Saved state could not be loaded: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: 'View opportunity details',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => OpportunityDetailsScreen(
                        opportunity: widget.opportunity,
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.north_east_rounded,
                    color: nextStepPurple,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => OpportunityDetailsScreen(
                      opportunity: widget.opportunity,
                    ),
                  ),
                ),
                child: const Text('View details & official source ↗'),
              ),
            ],
          ),
        ),
      );
    },
  );
}