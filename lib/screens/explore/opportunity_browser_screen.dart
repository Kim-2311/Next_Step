import 'package:flutter/material.dart';

import '../../models/opportunity.dart';
import '../../models/student_profile.dart';
import '../navigation/app_navigation.dart';
import '../../services/decision_engine.dart';
import '../../services/opportunity_service.dart';
import '../../services/student_service.dart';
import '../../widgets/app_components.dart';
import '../study/funding_comparison_screen.dart';
import '../study/student_success_screen.dart';
import '../work/globalconnect_screen.dart';
import '../pathways/career_pathway_screen.dart';
import '../cv/cv_assistant_screen.dart';
import '../plan_b/plan_b_screen.dart';
import '../widgets/opportunity_card.dart';
import 'bursary_funding_finder_screen.dart';
import 'learnerships_skills_screen.dart';
import 'matric_job_finder_screen.dart';
import 'study_finder_screen.dart';

class OpportunityBrowserScreen extends StatefulWidget {
  const OpportunityBrowserScreen({
    super.key,
    required this.title,
    required this.subtitle,
    this.categories,
    this.showShortcuts = false,
  });

  final String title;
  final String subtitle;
  final Set<String>? categories;
  final bool showShortcuts;

  @override
  State<OpportunityBrowserScreen> createState() =>
      _OpportunityBrowserScreenState();
}

class _OpportunityBrowserScreenState extends State<OpportunityBrowserScreen> {
  final _queryController = TextEditingController();
  StudentProfile? _profile;
  String _category = 'All';
  String _province = 'All South Africa';
  String _sort = 'Closing date';
  bool _includeRemote = true;
  bool _includeOtherProvinces = false;
  bool _loading = true;
  String? _error;
  List<Opportunity> _opportunities = [];
  List<OpportunityMatch> _matches = [];

  static const _categories = {
    'study': 'Study',
    'funding': 'Funding',
    'skills': 'Skills',
    'job': 'Jobs',
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final profile = await StudentService().loadProfile();
      final results = await OpportunityService().find(
        profile: profile,
        query: _queryController.text,
      );
      if (!mounted) return;
      setState(() {
        _profile = profile;
        if (profile != null && _province == 'All South Africa') {
          _province = profile.province;
          _includeOtherProvinces = profile.willingToRelocate;
        }
        _opportunities = results;
        _loading = false;
        _error = null;
      });
      _applyFilters();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  void _applyFilters() {
    final query = _queryController.text.trim().toLowerCase();
    final filtered = OpportunityService.sampleOpportunities.where((item) {
      if (widget.categories != null &&
          !widget.categories!.contains(item.category)) {
        return false;
      }
      if (_category != 'All' && item.category != _category) return false;
      if (query.isNotEmpty &&
          !'${item.title} ${item.provider} ${item.summary} ${item.requirements}'
              .toLowerCase()
              .contains(query)) {
        return false;
      }
      if (_province != 'All South Africa' &&
          item.province != _province &&
          item.province != 'South Africa' &&
          !_includeOtherProvinces) {
        return false;
      }
      if (!_includeRemote &&
          (item.isRemote || item.province == 'South Africa')) {
        return false;
      }
      return true;
    }).toList();
    filtered.sort((a, b) {
      if (_sort == 'Relevance' && _profile != null) {
        final aMatch = a.interests.any(_profile!.interests.contains) ? 0 : 1;
        final bMatch = b.interests.any(_profile!.interests.contains) ? 0 : 1;
        if (aMatch != bMatch) return aMatch.compareTo(bMatch);
      }
      return a.closingDate.compareTo(b.closingDate);
    });
    final matches = _profile == null
        ? <OpportunityMatch>[]
        : DecisionEngine().recommend(
            profile: _profile!,
            opportunities: filtered,
          );
    setState(() {
      _opportunities = filtered;
      _matches = matches;
    });
  }

  @override
  Widget build(BuildContext context) => AppPage(
    title: widget.title,
    subtitle: widget.subtitle,
    children: [
      if (widget.showShortcuts) ...[
        const Text(
          'Explore by route',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _shortcut(context, 'Study Finder', const StudyFinderScreen()),
            _shortcut(context, 'Bursaries', const BursaryFundingFinderScreen()),
            _shortcut(context, 'Matric jobs', const MatricJobFinderScreen()),
            _shortcut(
              context,
              'Learnerships',
              const LearnershipsSkillsScreen(),
            ),
            _shortcut(context, 'Plan a pathway', const CareerPathwayScreen()),
            _shortcut(context, 'Student Success', const StudentSuccessScreen()),
            _shortcut(
              context,
              'Funding guide',
              const FundingComparisonScreen(),
            ),
            _shortcut(context, 'GlobalConnect', const GlobalConnectScreen()),
            _shortcut(context, 'CV Assistant', const CvAssistantScreen()),
            _shortcut(context, 'Plan B', const PlanBScreen()),
          ],
        ),
        const SizedBox(height: 18),
      ],
      TextField(
        controller: _queryController,
        onChanged: (_) => _applyFilters(),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search_rounded),
          labelText: widget.categories?.contains('job') == true
              ? 'Job title or company'
              : widget.categories?.contains('study') == true
              ? 'Institution or programme'
              : 'Search opportunities',
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            tooltip: 'Clear search',
            onPressed: () {
              _queryController.clear();
              _applyFilters();
            },
            icon: const Icon(Icons.clear_rounded),
          ),
        ),
      ),
      const SizedBox(height: 12),
      if (widget.categories == null)
        Wrap(
          spacing: 8,
          children: [
            _categoryChip('All', null),
            ..._categories.entries.map(
              (entry) => _categoryChip(entry.value, entry.key),
            ),
          ],
        ),
      if (widget.categories == null) const SizedBox(height: 10),
      DropdownButtonFormField<String>(
        initialValue: _province,
        decoration: const InputDecoration(
          labelText: 'Location',
          border: OutlineInputBorder(),
        ),
        items:
            [
              'All South Africa',
              'KwaZulu-Natal',
              'Eastern Cape',
              'Free State',
              'Gauteng',
              'Limpopo',
              'Mpumalanga',
              'Northern Cape',
              'North West',
              'Western Cape',
            ].map((province) {
              return DropdownMenuItem(value: province, child: Text(province));
            }).toList(),
        onChanged: (value) {
          setState(() => _province = value ?? _province);
          _applyFilters();
        },
      ),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Include remote and nationwide routes'),
        value: _includeRemote,
        onChanged: (value) {
          setState(() => _includeRemote = value);
          _applyFilters();
        },
      ),
      if (_profile != null)
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show options outside my province'),
          value: _includeOtherProvinces,
          onChanged: (value) {
            setState(() => _includeOtherProvinces = value);
            _applyFilters();
          },
        ),
      Row(
        children: [
          Expanded(
            child: Text(
              '${_opportunities.length} illustrative examples',
              style: const TextStyle(
                color: nextStepPurple,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          DropdownButton<String>(
            value: _sort,
            items: const [
              DropdownMenuItem(
                value: 'Closing date',
                child: Text('Closing date'),
              ),
              DropdownMenuItem(value: 'Relevance', child: Text('Relevance')),
            ],
            onChanged: (value) {
              setState(() => _sort = value ?? _sort);
              _applyFilters();
            },
          ),
        ],
      ),
      if (_loading) const Center(child: CircularProgressIndicator()),
      if (_error != null)
        InfoPanel(
          child: Column(
            children: [
              Text('Could not load your profile preferences: $_error'),
              TextButton(onPressed: _load, child: const Text('Try again')),
            ],
          ),
        ),
      if (!_loading && _opportunities.isEmpty)
        const InfoPanel(
          child: Text(
            'No examples match these filters. Try a broader search or clear filters.',
          ),
        ),
      ..._opportunities.map((item) {
        OpportunityMatch? match;
        for (final candidate in _matches) {
          if (candidate.opportunity.id == item.id) {
            match = candidate;
            break;
          }
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              OpportunityCard(opportunity: item),
              if (match != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: InfoPanel(
                    color: const Color(0xFFE4F5F2),
                    child: Text(
                      'Why it may fit: ${match.reasons.join(' · ')}\n'
                      'Check: ${match.requirementsToCheck.join(' · ')}',
                      style: const TextStyle(
                        color: Color(0xFF11857C),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
      const SizedBox(height: 10),
      const InfoPanel(
        color: Color(0xFFE4F5F2),
        child: Text(
          'Illustrative examples, not live openings. Always verify requirements, current dates and availability with the official organisation.',
          style: TextStyle(color: Color(0xFF11857C), height: 1.5),
        ),
      ),
    ],
  );

  Widget _categoryChip(String label, String? value) => ChoiceChip(
    label: Text(label),
    selected: _category == (value ?? 'All'),
    onSelected: (_) {
      setState(() => _category = value ?? 'All');
      _applyFilters();
    },
  );

  Widget _shortcut(BuildContext context, String label, Widget screen) =>
      ActionChip(
        label: Text(label),
        onPressed: () => AppNavigation.open<void>(context, screen),
      );
}
