import 'package:flutter/material.dart';

class StudyFinderScreen extends StatelessWidget {
  const StudyFinderScreen({super.key});

  static const Color purple = Color(0xFF59329B);
  static const Color ink = Color(0xFF272533);
  static const Color muted = Color(0xFF6F6A78);
  static const Color softBg = Color(0xFFF5F2F7);
  static const Color panel = Color(0xFFF5F3F6);
  static const Color border = Color(0xFFDED5EB);
  static const Color tagBg = Color(0xFFEDE5F5);
  static const Color tealPanel = Color(0xFFDBF1EF);
  static const Color tealText = Color(0xFF11857C);
  static const Color warm = Color(0xFFF8E4C8);
  static const Color warmText = Color(0xFF9E5A10);

  @override
  Widget build(BuildContext context) {
    final cards = [
      _StudyCardData(
        title: 'Diploma in IT',
        institution: 'Example Technical College',
        location: 'Durban, KwaZulu-Natal',
        summary: '3 years • Diploma • TVET college',
        requirements: 'NSC • Example APS 26 • Maths 50%+',
        closes: 'Closes 30 Nov 2026',
      ),
      _StudyCardData(
        title: 'Higher Certificate in Software Development',
        institution: 'Example Coast University',
        location: 'Durban, KwaZulu-Natal',
        summary: '1 year • Higher certificate • University',
        requirements: 'NSC • Example APS 22 • Maths 50%+',
        closes: 'Closes 04 Dec 2026',
      ),
    ];

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
                          'Study Finder',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w900,
                            color: ink,
                            height: 1.08,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Your results can open more than one door.',
                          style: TextStyle(
                            fontSize: 15,
                            color: muted,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: border, width: 1.2),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search_rounded, color: purple, size: 22),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Institution or programme',
                                  style: TextStyle(
                                    color: muted,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _ChoicePill(
                              label: 'All institutions',
                              selected: true,
                            ),
                            _ChoicePill(label: 'Universities'),
                            _ChoicePill(label: 'TVET'),
                            _ChoicePill(label: 'Diplomas'),
                            _ChoicePill(label: 'Degrees'),
                            _ChoicePill(label: 'Higher certificates'),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                          decoration: BoxDecoration(
                            color: tealPanel,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'YOUR STARTING POINT',
                                style: TextStyle(
                                  color: purple,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'APS estimate 32 • Mathematics 68%',
                                style: TextStyle(
                                  color: ink,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Explore the example entry criteria below. Institutions calculate APS differently.',
                                style: TextStyle(
                                  color: ink,
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          '2 STUDY EXAMPLES · KZN',
                          style: TextStyle(
                            color: purple,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...cards.map((card) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _StudyCard(card: card),
                            )),
                        const SizedBox(height: 8),
                        const Text(
                          'Before you apply',
                          style: TextStyle(
                            color: ink,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Check the qualification\'s accreditation, fees, subject requirements and application dates directly with the institution. Meeting a minimum requirement does not guarantee admission.',
                          style: TextStyle(
                            color: muted,
                            fontSize: 13,
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline_rounded, color: purple, size: 18),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Illustrative opportunities, not live openings. Providers and programmes are examples. Always confirm details with the official organisation.',
                                style: TextStyle(
                                  color: muted,
                                  fontSize: 12,
                                  height: 1.55,
                                ),
                              ),
                            ),
                          ],
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
        color: selected ? StudyFinderScreen.purple : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? StudyFinderScreen.purple : StudyFinderScreen.border,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : StudyFinderScreen.purple,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StudyCardData {
  const _StudyCardData({
    required this.title,
    required this.institution,
    required this.location,
    required this.summary,
    required this.requirements,
    required this.closes,
  });

  final String title;
  final String institution;
  final String location;
  final String summary;
  final String requirements;
  final String closes;
}

class _StudyCard extends StatelessWidget {
  const _StudyCard({required this.card});

  final _StudyCardData card;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: BoxDecoration(
        color: StudyFinderScreen.panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: StudyFinderScreen.border, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'STUDY • EXAMPLE',
                  style: TextStyle(
                    color: StudyFinderScreen.purple,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
                icon: const Icon(
                  Icons.bookmark_border_rounded,
                  color: StudyFinderScreen.purple,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            card.title,
            style: const TextStyle(
              color: StudyFinderScreen.ink,
              fontSize: 28,
              height: 1.06,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.7,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            card.institution,
            style: const TextStyle(
              color: StudyFinderScreen.muted,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: StudyFinderScreen.muted,
                size: 15,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  card.location,
                  style: const TextStyle(
                    color: StudyFinderScreen.muted,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            card.summary,
            style: const TextStyle(
              color: StudyFinderScreen.ink,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'NSC • ${card.requirements}',
            style: const TextStyle(
              color: StudyFinderScreen.ink,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E4F0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  card.closes,
                  style: const TextStyle(
                    color: StudyFinderScreen.purple,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_outward_rounded,
                color: StudyFinderScreen.purple,
                size: 19,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'View details & official source',
            style: TextStyle(
              color: StudyFinderScreen.purple,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
