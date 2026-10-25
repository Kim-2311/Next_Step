import 'package:flutter/material.dart';

class MatricJobFinderScreen extends StatelessWidget {
  const MatricJobFinderScreen({super.key});

  static const Color purple = Color(0xFF59329B);
  static const Color ink = Color(0xFF272533);
  static const Color muted = Color(0xFF6F6A78);
  static const Color softBg = Color(0xFFF5F2F7);
  static const Color panel = Color(0xFFF5F3F6);
  static const Color border = Color(0xFFDED5EB);
  static const Color tagBg = Color(0xFFEDE5F5);
  static const Color tealPanel = Color(0xFFDBF1EF);

  @override
  Widget build(BuildContext context) {
    final cards = [
      _JobCardData(
        title: 'Junior Service Assistant',
        organisation: 'Example Retail Co.',
        location: 'Durban, KwaZulu-Natal',
        summary: 'Entry level • Full-time',
        requirement: 'Matric • 0–1 years’ experience',
        closes: 'Closes 20 Nov 2026',
      ),
      _JobCardData(
        title: 'Junior Helpdesk Assistant',
        organisation: 'Example Digital Services',
        location: 'Durban, KwaZulu-Natal',
        summary: 'Entry level • 6-month contract • On-site',
        requirement: 'Matric • Basic computer skills • No experience',
        closes: 'Closes 27 Nov 2026',
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
                          'Matric Job Finder',
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
                          'A first role. A chance to build experience.',
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
                                  'Job title or company',
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
                            _ChoicePill(label: 'KwaZulu-Natal', selected: true),
                            _ChoicePill(label: 'Entry level'),
                            _ChoicePill(label: 'Job type'),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9E2F2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'START WHERE YOU ARE',
                                style: TextStyle(
                                  color: purple,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Look for “no experience required” and check which skills you can bring from school, volunteering or everyday life.',
                                style: TextStyle(
                                  color: ink,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          '2 JOB EXAMPLES • CLOSING DATE',
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
                              child: _JobCard(card: card),
                            )),
                        const SizedBox(height: 8),
                        const Text(
                          'A safer job search',
                          style: TextStyle(
                            color: ink,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Never pay a recruitment or placement fee. Check the company and submit personal information only through a genuine official channel.',
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
        color: selected ? MatricJobFinderScreen.purple : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? MatricJobFinderScreen.purple : MatricJobFinderScreen.border,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : MatricJobFinderScreen.purple,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _JobCardData {
  const _JobCardData({
    required this.title,
    required this.organisation,
    required this.location,
    required this.summary,
    required this.requirement,
    required this.closes,
  });

  final String title;
  final String organisation;
  final String location;
  final String summary;
  final String requirement;
  final String closes;
}

class _JobCard extends StatelessWidget {
  const _JobCard({required this.card});

  final _JobCardData card;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: BoxDecoration(
        color: MatricJobFinderScreen.panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MatricJobFinderScreen.border, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'JOBS • EXAMPLE',
                  style: TextStyle(
                    color: MatricJobFinderScreen.purple,
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
                  color: MatricJobFinderScreen.purple,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            card.title,
            style: const TextStyle(
              color: MatricJobFinderScreen.ink,
              fontSize: 28,
              height: 1.06,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.7,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            card.organisation,
            style: const TextStyle(
              color: MatricJobFinderScreen.muted,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: MatricJobFinderScreen.muted,
                size: 15,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  card.location,
                  style: const TextStyle(
                    color: MatricJobFinderScreen.muted,
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
              color: MatricJobFinderScreen.ink,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            card.requirement,
            style: const TextStyle(
              color: MatricJobFinderScreen.ink,
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
                    color: MatricJobFinderScreen.purple,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_outward_rounded,
                color: MatricJobFinderScreen.purple,
                size: 19,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'View details & official source',
            style: TextStyle(
              color: MatricJobFinderScreen.purple,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
