import 'package:flutter/material.dart';

class OpportunityDetailsScreen extends StatelessWidget {
  const OpportunityDetailsScreen({super.key});

  static const Color purple = Color(0xFF59329B);
  static const Color ink = Color(0xFF272533);
  static const Color muted = Color(0xFF6F6A78);
  static const Color softBg = Color(0xFFF5F2F7);
  static const Color panel = Color(0xFFF5F3F6);
  static const Color border = Color(0xFFDED5EB);
  static const Color tagBg = Color(0xFFEDE5F5);
  static const Color mintPanel = Color(0xFFDBF1EF);
  static const Color success = Color(0xFF81C7AF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBg,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 420,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(22, 6, 22, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatusRow(),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                color: ink,
                                size: 26,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {},
                              icon: const Icon(
                                Icons.notifications_none_rounded,
                                color: purple,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Diploma in IT',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: ink,
                            height: 1.08,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Example Technical College • Illustrative programme',
                          style: TextStyle(
                            fontSize: 15,
                            color: muted,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _ChoicePill(label: 'Study', selected: true),
                            _ChoicePill(label: 'Diploma • 3 years'),
                            _ChoicePill(label: 'Saved'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9E2F0),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month_outlined, color: purple, size: 25),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'CLOSING DATE',
                                      style: TextStyle(
                                        color: purple,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '30 November 2026',
                                      style: TextStyle(
                                        color: ink,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Durban, KwaZulu-Natal • Full-time • On campus',
                                      style: TextStyle(
                                        color: muted,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'A practical start in tech',
                          style: TextStyle(
                            color: ink,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Build foundations in programming, databases, networks and IT support. This example diploma combines guided projects with practical lab work.',
                          style: TextStyle(
                            color: muted,
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Possible benefits: structured technical learning, portfolio projects and career support. Fees and financial support must be confirmed with the institution.',
                          style: TextStyle(
                            color: muted,
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          'Example entry requirements',
                          style: TextStyle(
                            color: ink,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• National Senior Certificate', style: TextStyle(color: muted, fontSize: 14, height: 1.8)),
                              Text('• Example APS of at least 26, excluding LO', style: TextStyle(color: muted, fontSize: 14, height: 1.8)),
                              Text('• Mathematics 50% or higher', style: TextStyle(color: muted, fontSize: 14, height: 1.8)),
                              Text('• English 50% or higher', style: TextStyle(color: muted, fontSize: 14, height: 1.8)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'These are sample criteria, not an admission offer. The institution\'s own scoring method, capacity and selection rules apply.',
                          style: TextStyle(
                            color: muted,
                            fontSize: 13,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                          decoration: BoxDecoration(
                            color: mintPanel,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'WHY IT MAY SUIT YOU',
                                style: TextStyle(
                                  color: purple,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Your interests include Technology. Your APS estimate is 32, Mathematics is 68% and English HL is 65%. Durban also matches your preferred location.',
                                style: TextStyle(
                                  color: ink,
                                  fontSize: 15,
                                  height: 1.55,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'This suggests a route to explore, not confirmed eligibility or guaranteed admission.',
                                style: TextStyle(
                                  color: ink,
                                  fontSize: 15,
                                  height: 1.55,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Documents to prepare',
                          style: TextStyle(
                            color: ink,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const _ChecklistRow(label: 'Certified ID copy', status: 'Ready', checked: true),
                        const _ChecklistRow(label: 'Matric statement of results', status: 'To do'),
                        const _ChecklistRow(label: 'Proof of address', status: 'Ready', checked: true),
                        const _ChecklistRow(label: 'Motivation letter', status: 'To do'),
                        const SizedBox(height: 18),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                          decoration: BoxDecoration(
                            color: panel,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: border, width: 1.2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.info_outline_rounded, color: purple, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    'ILLUSTRATIVE • NOT VERIFIED',
                                    style: TextStyle(
                                      color: purple,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Source organisation: Example Technical College (hypothetical). No live opening, official listing or verification is claimed.',
                                style: TextStyle(
                                  color: muted,
                                  fontSize: 13,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: border, width: 1.2),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Center(
                                      child: Text(
                                        'View official source',
                                        style: TextStyle(
                                          color: purple,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: border, width: 1.2),
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Save Opportunity',
                                  style: TextStyle(
                                    color: purple,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Icon(Icons.bookmark_border_rounded, color: purple, size: 22),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Already in your 3 saved opportunities.',
                          style: TextStyle(
                            color: muted,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: purple,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Text(
                                  'Apply Now • official source',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Apply with the institution, not NextStep. Final eligibility and admission decisions rest with the institution.',
                          style: TextStyle(
                            color: muted,
                            fontSize: 13,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
                _buildBottomNavigation(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow() {
    return const Padding(
      padding: EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '9:41',
              style: TextStyle(
                color: ink,
                fontSize: 12,
                fontWeight: FontWeight.w700,
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

  Widget _buildBottomNavigation() {
    return SafeArea(
      top: false,
      child: SizedBox(
        height: 78,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: border)),
          ),
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
          child: Row(
            children: [
              _buildNavItem(icon: Icons.home_outlined, label: 'Home', selected: false),
              _buildNavItem(icon: Icons.explore_rounded, label: 'Explore', selected: true),
              _buildNavItem(icon: Icons.bookmark_border_rounded, label: 'Saved', selected: false),
              _buildNavItem(icon: Icons.assignment_outlined, label: 'Applications', selected: false),
              _buildNavItem(icon: Icons.person_outline_rounded, label: 'Profile', selected: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool selected,
  }) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 30,
            decoration: BoxDecoration(
              color: selected ? tagBg : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: selected ? purple : muted,
              size: 22,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: selected ? purple : muted,
              fontSize: 10,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: selected ? OpportunityDetailsScreen.purple : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? OpportunityDetailsScreen.purple : OpportunityDetailsScreen.border,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : OpportunityDetailsScreen.purple,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({
    required this.label,
    required this.status,
    this.checked = false,
  });

  final String label;
  final String status;
  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            checked ? Icons.check_circle : Icons.radio_button_unchecked,
            color: checked ? OpportunityDetailsScreen.success : OpportunityDetailsScreen.muted,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: OpportunityDetailsScreen.ink,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            status,
            style: const TextStyle(
              color: OpportunityDetailsScreen.muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
