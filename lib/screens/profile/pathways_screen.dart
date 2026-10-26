import 'package:flutter/material.dart';

import '../../models/student_profile.dart';
import 'profile_review_screen.dart';

class ProfilePathwaysScreen extends StatefulWidget {
  const ProfilePathwaysScreen({
    super.key,
    this.profile = const StudentProfile(),
    this.selectedInterests = const {},
    this.selectedPathways = const {},
    this.location,
    this.showRemote = false,
    this.fundingNeed = 'Tuition, books & transport',
  });

  final StudentProfile profile;
  final Set<String> selectedInterests;
  final Set<String> selectedPathways;
  final String? location;
  final bool showRemote;
  final String fundingNeed;

  @override
  State<ProfilePathwaysScreen> createState() => _ProfilePathwaysScreenState();
}

class _ProfilePathwaysScreenState extends State<ProfilePathwaysScreen> {
  static const Color purple = Color(0xFF59329B);
  static const Color ink = Color(0xFF1E1E2A);
  static const Color muted = Color(0xFF6D6D78);
  static const Color line = Color(0xFFE6E1EC);

  static const List<String> _pathways = [
    'Study',
    'Find a job',
    'Bursaries and funding',
    'Learnerships and apprenticeships',
    'Internships and skills programmes',
    'Study and work',
  ];

  late final Set<String> _selectedPathways = {
    ...(widget.selectedPathways.isNotEmpty
        ? widget.selectedPathways
        : widget.profile.pathways.toSet()),
  };
  late String _location = widget.location ?? widget.profile.province;
  late String _primaryGoal = widget.profile.primaryGoal;
  late bool _showRemote = widget.showRemote;
  late String _fundingNeed = widget.fundingNeed;

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
                        _buildNavigationRow(),
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
                          'There’s more than\none way forward.',
                          style: TextStyle(
                            fontSize: 29,
                            height: 1.08,
                            fontWeight: FontWeight.w800,
                            color: ink,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'What is your primary goal right now?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: ink,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDropdown(
                          value: _primaryGoal == 'work'
                              ? 'Work, a short course or a gap year'
                              : 'Study further',
                          items: const [
                            'Study further',
                            'Work, a short course or a gap year',
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(
                                () => _primaryGoal = value == 'Study further'
                                    ? 'study'
                                    : 'work',
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Tell us which routes you’re open to. Select as many as you like.',
                          style: TextStyle(
                            fontSize: 14,
                            color: muted,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ..._pathways.map(_buildPathwayTile),
                        const SizedBox(height: 12),
                        const Text(
                          'Where would you like to go?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: ink,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Preferred opportunity location',
                          style: TextStyle(fontSize: 13, color: ink),
                        ),
                        const SizedBox(height: 8),
                        _buildDropdown(
                          value: _location,
                          items: const [
                            'KwaZulu-Natal',
                            'Eastern Cape',
                            'Free State',
                            'Gauteng',
                            'Limpopo',
                            'Mpumalanga',
                            'Northern Cape',
                            'North West',
                            'Western Cape',
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _location = value);
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildToggleTile(
                          label: 'Also show remote opportunities',
                          selected: _showRemote,
                          onTap: () =>
                              setState(() => _showRemote = !_showRemote),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'A little support can help',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: ink,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Funding needs',
                          style: TextStyle(fontSize: 13, color: ink),
                        ),
                        const SizedBox(height: 8),
                        _buildDropdown(
                          value: _fundingNeed,
                          items: const [
                            'Tuition, books & transport',
                            'Tuition and books',
                            'Transport',
                            'Accommodation',
                            'No funding needed',
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _fundingNeed = value);
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'We’ll highlight funding to explore. Financial and academic eligibility is assessed by each provider.',
                          style: TextStyle(
                            fontSize: 12,
                            color: muted,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _reviewProfile,
                            icon: const Text('Review my profile'),
                            label: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: purple,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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

  Widget _buildNavigationRow() {
    return Row(
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
          'Step 4 of 4',
          style: TextStyle(
            fontSize: 12,
            color: muted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildPathwayTile(String pathway) {
    final selected = _selectedPathways.contains(pathway);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          setState(() {
            if (!_selectedPathways.add(pathway)) {
              _selectedPathways.remove(pathway);
            }
          });
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF4F0FA) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selected ? purple : line),
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank_rounded,
                size: 19,
                color: selected ? purple : line,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  pathway,
                  style: const TextStyle(fontSize: 14, color: ink),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: line),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: muted),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildToggleTile({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF4F0FA) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? purple : line),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
              size: 19,
              color: selected ? purple : line,
            ),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontSize: 14, color: ink)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
      color: Colors.white,
      child: const Row(
        children: [
          Expanded(
            child: Text(
              '9:41',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: ink,
              ),
            ),
          ),
          Icon(Icons.signal_cellular_4_bar_rounded, size: 16, color: ink),
          SizedBox(width: 6),
          Icon(Icons.wifi_rounded, size: 16, color: ink),
          SizedBox(width: 6),
          Icon(Icons.battery_5_bar_rounded, size: 16, color: ink),
        ],
      ),
    );
  }

  void _reviewProfile() {
    if (_selectedPathways.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose at least one route to continue.')),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfileReviewScreen(
          profile: widget.profile.copyWith(
            interests: widget.selectedInterests.toList(),
            pathways: _selectedPathways.toList(),
            province: _location,
            willingToRelocate: _showRemote,
            needsFunding: _fundingNeed != 'No funding needed',
            fundingNeed: _fundingNeed,
            primaryGoal: _primaryGoal,
          ),
          selectedInterests: widget.selectedInterests,
          selectedPathways: _selectedPathways,
          location: _location,
          showRemote: _showRemote,
          fundingNeed: _fundingNeed,
        ),
      ),
    );
  }
}
