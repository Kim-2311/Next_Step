import 'package:flutter/material.dart';

import '../../models/opportunity.dart';
import '../../services/opportunity_service.dart';
import '../../services/student_service.dart';
import '../../widgets/app_components.dart';
import '../widgets/opportunity_card.dart';
import '../explore/explore_screen.dart';

class SavedOpportunitiesScreen extends StatefulWidget {
  const SavedOpportunitiesScreen({super.key});

  @override
  State<SavedOpportunitiesScreen> createState() =>
      _SavedOpportunitiesScreenState();
}

class _SavedOpportunitiesScreenState extends State<SavedOpportunitiesScreen> {
  bool _loading = true;
  String? _error;
  String _filter = 'All';
  List<Opportunity> _saved = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final ids = await StudentService().getSavedOpportunityIds();
      final saved = OpportunityService.sampleOpportunities
          .where((item) => ids.contains(item.id))
          .toList()
        ..sort((a, b) => a.closingDate.compareTo(b.closingDate));
      if (!mounted) return;
      setState(() {
        _saved = saved;
        _loading = false;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _saved.where((item) {
      if (_filter == 'All') return true;
      if (_filter == 'Study') return item.category == 'study';
      if (_filter == 'Work') return item.category == 'job' || item.category == 'skills';
      return item.category == 'funding';
    }).toList();
    return AppPage(
      title: 'Good options. Kept close.',
      subtitle: 'Saved Opportunities · Your shortlist, all in one place.',
      children: [
        Wrap(
          spacing: 8,
          children: ['All', 'Study', 'Work', 'Funding'].map((category) {
            final count = category == 'All'
                ? _saved.length
                : _saved.where((item) {
                    if (category == 'Study') return item.category == 'study';
                    if (category == 'Work') {
                      return item.category == 'job' || item.category == 'skills';
                    }
                    return item.category == 'funding';
                  }).length;
            return ChoiceChip(
              label: Text('$category · $count'),
              selected: _filter == category,
              onSelected: (_) => setState(() => _filter = category),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        if (_loading)
          const Center(child: CircularProgressIndicator())
        else if (_error != null)
          InfoPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your saved opportunities could not be loaded.'),
                const SizedBox(height: 6),
                Text(_error!, style: const TextStyle(color: nextStepMuted)),
                TextButton(onPressed: _load, child: const Text('Try again')),
              ],
            ),
          )
        else if (filtered.isEmpty)
          InfoPanel(
            child: Column(
              children: [
                const Icon(
                  Icons.bookmark_border_rounded,
                  size: 48,
                  color: nextStepPurple,
                ),
                const SizedBox(height: 10),
                Text(
                  _saved.isEmpty
                      ? 'Nothing saved. Plenty to explore.'
                      : 'No saved ${_filter.toLowerCase()} options.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: nextStepInk,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap the bookmark on an opportunity to keep it here and compare later.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: nextStepMuted, height: 1.5),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ExploreScreen(),
                    ),
                  ),
                  child: const Text('Explore opportunities'),
                ),
              ],
            ),
          )
        else ...[
          Text(
            'YOUR ${filtered.length} SAVED EXAMPLES',
            style: const TextStyle(
              color: nextStepPurple,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          ...filtered.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OpportunityCard(
                key: ValueKey(item.id),
                opportunity: item,
                onSavedChanged: (saved) {
                  if (!saved) {
                    setState(() {
                      _saved.removeWhere((entry) => entry.id == item.id);
                    });
                  }
                },
              ),
            ),
          ),
        ],
        const SizedBox(height: 10),
        const Text(
          'Saving does not submit an application. “Work” includes workplace learning. Apply through the official provider.',
          style: TextStyle(color: nextStepMuted, height: 1.5),
        ),
      ],
    );
  }
}
