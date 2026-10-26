import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/app_components.dart';

class GlobalConnectScreen extends StatefulWidget {
  const GlobalConnectScreen({super.key});

  @override
  State<GlobalConnectScreen> createState() => _GlobalConnectScreenState();
}

class _GlobalConnectScreenState extends State<GlobalConnectScreen> {
  final _search = TextEditingController();
  String _filter = 'Remote first';
  final Set<String> _checked = {};
  bool _checklistLoaded = false;

  static const _routes = [
    _GlobalRoute(
      type: 'REMOTE LEARNING',
      title: 'Online technology courses',
      description:
          'Explore programming, IT support and digital skills routes from international learning providers.',
      checklist: 'Review online course checklist',
      searchText: 'technology programming IT digital remote',
      isRemote: true,
    ),
    _GlobalRoute(
      type: 'REMOTE EXPERIENCE',
      title: 'Virtual skills projects',
      description:
          'Look for guided projects or virtual learning experiences to practise and build a portfolio.',
      checklist: 'Prepare a skills portfolio',
      searchText: 'virtual remote project skills experience',
      isRemote: true,
    ),
    _GlobalRoute(
      type: 'FUTURE EXPLORATION',
      title: 'International study routes',
      description:
          'Research accredited study programmes and scholarship routes when you are ready.',
      checklist: 'Compare funding types',
      searchText: 'international study scholarship funding',
      isRemote: false,
    ),
  ];
  static const _safetyChecks = [
    'Confirm South African applicants are eligible',
    'Check fees, data costs and time zones',
    'Verify provider identity and accreditation claims',
  ];

  String get _userKey =>
      '${FirebaseAuth.instance.currentUser?.uid ?? 'device'}:';

  @override
  void initState() {
    super.initState();
    _loadChecklist();
  }

  Future<void> _loadChecklist() async {
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _checked
        ..clear()
        ..addAll(
          preferences
                  .getStringList('${_userKey}globalConnectChecklist') ??
              const [],
        );
      _checklistLoaded = true;
    });
  }

  Future<void> _toggleCheck(String item, bool value) async {
    final updated = {..._checked};
    if (value) {
      updated.add(item);
    } else {
      updated.remove(item);
    }
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      '${_userKey}globalConnectChecklist',
      updated.toList(),
    );
    if (mounted) {
      setState(() {
        _checked
          ..clear()
          ..addAll(updated);
      });
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matches = _routes.where((route) {
      final term = _search.text.trim().toLowerCase();
      final searchMatches =
          term.isEmpty ||
          '${route.title} ${route.description} ${route.searchText}'
              .toLowerCase()
              .contains(term);
      final filterMatches = _filter != 'Technology' ||
          route.searchText.toLowerCase().contains('technology');
      return searchMatches && filterMatches;
    }).toList()
      ..sort((a, b) {
        if (_filter == 'Remote first' && a.isRemote != b.isRemote) {
          return a.isRemote ? -1 : 1;
        }
        return a.title.compareTo(b.title);
      });

    return AppPage(
      title: 'A wider world. A grounded next step.',
      subtitle: 'GlobalConnect · Explore international learning and skills routes.',
      children: [
        const InfoPanel(
          color: Color(0xFFE4F5F2),
          child: Text(
            'These are route guides, not live offers, scholarships or guaranteed placements. Start with routes you can explore from home.',
            style: TextStyle(color: Color(0xFF11857C), height: 1.5),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _search,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search_rounded),
            labelText: 'Search learning topics',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: ['Remote first', 'Technology', 'All routes'].map((filter) {
            return ChoiceChip(
              label: Text(filter),
              selected: _filter == filter,
              onSelected: (_) => setState(() => _filter = filter),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        if (matches.isEmpty)
          const InfoPanel(child: Text('No routes match your search.'))
        else
          ...matches.map(
            (route) => Card(
              margin: const EdgeInsets.only(bottom: 12),
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
                    Chip(
                      label: Text(route.type),
                      backgroundColor: nextStepLavender,
                      side: BorderSide.none,
                    ),
                    Text(
                      route.title,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      route.description,
                      style: const TextStyle(
                        color: nextStepMuted,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(route.checklist),
                          content: const Text(
                            'Check provider identity, South African eligibility, accreditation, total fees, teaching language and data costs before signing up. No external provider link has been verified for this sample.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                      child: Text('${route.checklist} →'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(height: 10),
        const Text(
          'Check before you commit',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        if (!_checklistLoaded)
          const Center(child: CircularProgressIndicator())
        else
          ..._safetyChecks.map(
          (item) => CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(item),
            value: _checked.contains(item),
            onChanged: (value) => _toggleCheck(item, value ?? false),
          ),
        ),
        const InfoPanel(
          child: Text(
            'Keep your search safe. Use the provider’s official website. Never pay a recruiter to guarantee a visa, scholarship or overseas job. Keep passport scans, banking details and OTPs private.',
            style: TextStyle(color: nextStepMuted, height: 1.5),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => showAppMessage(
            context,
            '${_checked.length} of ${_safetyChecks.length} safety checks saved.',
          ),
          child: const Text('Save my research checklist'),
        ),
      ],
    );
  }
}

class _GlobalRoute {
  const _GlobalRoute({
    required this.type,
    required this.title,
    required this.description,
    required this.checklist,
    required this.searchText,
    required this.isRemote,
  });

  final String type;
  final String title;
  final String description;
  final String checklist;
  final String searchText;
  final bool isRemote;
}