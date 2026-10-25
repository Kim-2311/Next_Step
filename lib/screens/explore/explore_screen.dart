import 'package:flutter/material.dart';

import 'bursary_funding_finder_screen.dart';
import 'learnerships_skills_screen.dart';
import 'matric_job_finder_screen.dart';
import 'study_finder_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  static const Color purple = Color(0xFF59329B);
  static const Color ink = Color(0xFF272533);
  static const Color muted = Color(0xFF6F6A78);
  static const Color softBg = Color(0xFFF5F2F7);
  static const Color panel = Color(0xFFF5F3F6);
  static const Color border = Color(0xFFDED5EB);
  static const Color tagBg = Color(0xFFF0EBF8);
  static const Color tipBg = Color(0xFFE9E7ED);
  static const Color warm = Color(0xFFF8E4C8);
  static const Color warmText = Color(0xFF9E5A10);

  @override
  Widget build(BuildContext context) {
    final opportunities = [
      _OpportunityItem(
        category: 'STUDY · EXAMPLE',
        title: 'Diploma in IT',
        subtitle: 'Example Technical College',
        location: 'Durban, KwaZulu-Natal',
        meta: '3 years • Diploma • Full-time',
        requirement: 'NSC • Example APS 26 • Maths 50%+',
        closes: 'Closes 30 Nov 2026',
      ),
      _OpportunityItem(
        category: 'FUNDING · EXAMPLE',
        title: 'Future Makers Bursary',
        subtitle: 'Example Futures Trust',
        location: 'South Africa',
        meta: 'Tuition & books • Financial need assessed',
        requirement: 'IT & engineering • Average 65%+',
        closes: 'Closes 02 Nov 2026',
        warm: true,
      ),
      _OpportunityItem(
        category: 'SKILLS · EXAMPLE',
        title: 'IT Support Learnership',
        subtitle: 'Example Skills Hub',
        location: 'Durban, KwaZulu-Natal',
        meta: '12 months • Workplace training',
        requirement: 'Matric • No experience required',
        closes: 'Closes 06 Nov 2026',
      ),
      _OpportunityItem(
        category: 'JOBS · EXAMPLE',
        title: 'Junior Service Assistant',
        subtitle: 'Example Retail Co.',
        location: 'Durban, KwaZulu-Natal',
        meta: 'Entry level • Full-time',
        requirement: 'Matric • 0–1 years’ experience',
        closes: 'Closes 20 Nov 2026',
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
                    padding: const EdgeInsets.fromLTRB(24, 6, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatusRow(),
                        const SizedBox(height: 10),
                        const Text(
                          '05 — OPPORTUNITIES · 11',
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 0.7,
                            fontWeight: FontWeight.w700,
                            color: muted,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Icon(
                          Icons.notifications_none_rounded,
                          color: purple,
                          size: 22,
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Find your\nnext possibility.',
                          style: TextStyle(
                            fontSize: 38,
                            height: 0.94,
                            fontWeight: FontWeight.w900,
                            color: ink,
                            letterSpacing: -1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Explore routes that start with where you are.',
                          style: TextStyle(
                            fontSize: 15,
                            color: muted,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          height: 54,
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
                                  'Search opportunities',
                                  style: TextStyle(
                                    color: muted,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        _buildCategoryRow(context),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: const [
                            _FilterChip(label: 'KZN + remote'),
                            _FilterChip(label: 'Deadline'),
                            _FilterChip(label: 'Filters'),
                            _FilterChip(label: 'Requirements'),
                            _FilterChip(label: 'Industry'),
                            _FilterChip(label: 'Clear'),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            const Text(
                              '8 relevant examples',
                              style: TextStyle(
                                color: ink,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 20),
                              ),
                              child: const Text(
                                'Relevance •',
                                style: TextStyle(
                                  color: purple,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.info_outline_rounded, size: 15, color: muted),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Illustrative opportunities • not live openings.',
                                style: TextStyle(
                                  color: muted,
                                  fontSize: 12,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...opportunities.map((opportunity) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _OpportunityCard(opportunity: opportunity),
                            )),
                        const SizedBox(height: 12),
                        Text(
                          'Showing 4 of 8 example matches. Bookmark any option to build your shortlist.',
                          style: TextStyle(
                            color: muted,
                            fontSize: 12,
                            height: 1.5,
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

  Widget _buildCategoryRow(BuildContext context) {
    final categories = [
      _CategoryItem(
        icon: Icons.school_rounded,
        label: 'Study',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const StudyFinderScreen()),
        ),
      ),
      _CategoryItem(
        icon: Icons.work_rounded,
        label: 'Jobs',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MatricJobFinderScreen()),
        ),
      ),
      _CategoryItem(
        icon: Icons.account_balance_wallet_rounded,
        label: 'Bursaries',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const BursaryFundingFinderScreen()),
        ),
      ),
      _CategoryItem(
        icon: Icons.build_rounded,
        label: 'Skills',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LearnershipsSkillsScreen()),
        ),
      ),
    ];

    return Row(
      children: categories
          .map(
            (category) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: category.onTap ?? () {},
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: tagBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: purple.withValues(alpha: 0.6), width: 1.1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(category.icon, color: purple, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          category.label,
                          style: const TextStyle(
                            color: purple,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildBottomNavigation() {
    return SafeArea(
      top: false,
      child: SizedBox(
        height: 76,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: border)),
          ),
          padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
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
            height: 26,
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

class _OpportunityItem {
  const _OpportunityItem({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.location,
    required this.meta,
    required this.requirement,
    required this.closes,
    this.warm = false,
  });

  final String category;
  final String title;
  final String subtitle;
  final String location;
  final String meta;
  final String requirement;
  final String closes;
  final bool warm;
}

class _CategoryItem {
  const _CategoryItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F1F7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ExploreScreen.border, width: 1),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: ExploreScreen.purple,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  const _OpportunityCard({required this.opportunity});

  final _OpportunityItem opportunity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: BoxDecoration(
        color: ExploreScreen.panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ExploreScreen.border, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  opportunity.category,
                  style: const TextStyle(
                    color: ExploreScreen.purple,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
                icon: const Icon(
                  Icons.bookmark_border_rounded,
                  color: ExploreScreen.purple,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            opportunity.title,
            style: const TextStyle(
              color: ExploreScreen.ink,
              fontSize: 28,
              height: 1.02,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            opportunity.subtitle,
            style: const TextStyle(
              color: ExploreScreen.muted,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: ExploreScreen.muted, size: 15),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  opportunity.location,
                  style: const TextStyle(color: ExploreScreen.muted, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            opportunity.meta,
            style: const TextStyle(color: ExploreScreen.ink, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 6),
          Text(
            opportunity.requirement,
            style: const TextStyle(color: ExploreScreen.ink, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: opportunity.warm ? ExploreScreen.warm : const Color(0xFFE9E8EE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  opportunity.closes,
                  style: TextStyle(
                    color: opportunity.warm ? ExploreScreen.warmText : ExploreScreen.purple,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_outward_rounded, color: ExploreScreen.purple, size: 21),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'View details & official source',
            style: const TextStyle(
              color: ExploreScreen.purple,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
