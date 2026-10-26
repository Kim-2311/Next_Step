import 'package:flutter/material.dart';

import '../../models/student_profile.dart';
import 'pathways_screen.dart';

class ProfileInterestsScreen extends StatefulWidget {
  const ProfileInterestsScreen({
    super.key,
    this.profile = const StudentProfile(),
    this.selectedInterests,
  });

  final StudentProfile profile;
  final Set<String>? selectedInterests;

  @override
  State<ProfileInterestsScreen> createState() => _ProfileInterestsScreenState();
}

class _ProfileInterestsScreenState extends State<ProfileInterestsScreen> {
  static const Color purple = Color(0xFF59329B);
  static const Color ink = Color(0xFF1E1E2A);
  static const Color muted = Color(0xFF6D6D78);
  static const Color line = Color(0xFFE6E1EC);
  final List<String> _interests = const [
    'Technology',
    'Business and Finance',
    'Health and Medicine',
    'Engineering',
    'Education',
    'Creative Arts and Design',
    'Science and Environment',
  ];

  late final Set<String> _selected = {
    ...(widget.selectedInterests ?? widget.profile.interests.toSet()),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2F7),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 420,
            color: Colors.white,
            child: Column(
              children: [
                _buildStatusRow(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            SizedBox(
                              width: 34,
                              height: 34,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                splashRadius: 18,
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 18,
                                  color: ink,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              'Step 3 of 4',
                              style: TextStyle(
                                fontSize: 12,
                                color: muted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'YOUR PROFILE',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.2,
                            color: purple,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: line, thickness: 1.5),
                        const SizedBox(height: 18),
                        const Text(
                          'What sparks\nyour curiosity?',
                          style: TextStyle(
                            fontSize: 30,
                            height: 1.08,
                            fontWeight: FontWeight.w800,
                            color: ink,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Choose all the fields you’d like to explore. It’s okay to have more than one interest.',
                          style: TextStyle(
                            fontSize: 14,
                            color: muted,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'YOUR INTERESTS',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: purple,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              '${_selected.length} SELECTED',
                              style: const TextStyle(
                                fontSize: 11,
                                color: purple,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ..._interests.map((interest) {
                          final selected = _selected.contains(interest);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => _toggleInterest(interest),
                              child: Container(
                                height: 48,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color(0xFFF4F0FA)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: selected ? purple : line,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      selected
                                          ? Icons.check_box_rounded
                                          : Icons
                                                .check_box_outline_blank_rounded,
                                      size: 19,
                                      color: selected ? purple : line,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      interest,
                                      style: const TextStyle(
                                        color: ink,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9F6F3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.auto_awesome_outlined,
                                color: Color(0xFF168C8B),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Interests can change. Your choices help us suggest options, not limit them.',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF168C8B),
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 26),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ProfilePathwaysScreen(
                                    selectedInterests: _selected,
                                    profile: widget.profile.copyWith(
                                      interests: _selected.toList(),
                                    ),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: purple,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Continue to pathways  →',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
      color: Colors.white,
      child: Row(
        children: [
          const Expanded(
            child: Text(
              '9:41',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: ink,
              ),
            ),
          ),
          const Icon(Icons.signal_cellular_4_bar_rounded, size: 16, color: ink),
          const SizedBox(width: 6),
          const Icon(Icons.wifi_rounded, size: 16, color: ink),
          const SizedBox(width: 6),
          const Icon(Icons.battery_5_bar_rounded, size: 16, color: ink),
        ],
      ),
    );
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (!_selected.add(interest)) {
        _selected.remove(interest);
      }
    });
  }
}
