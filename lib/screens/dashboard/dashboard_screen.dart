import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../explore/explore_screen.dart';
import '../profile/profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const Color purple = Color(0xFF59329B);
  static const Color ink = Color(0xFF2B2935);
  static const Color muted = Color(0xFF777384);
  static const Color teal = Color(0xFF4ED6C4);
  static const Color paleTeal = Color(0xFFE4F5F2);
  static const Color lavender = Color(0xFFF2EFF7);
  static const Color border = Color(0xFFE4DDED);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => Center(
            child: SizedBox(
              width: constraints.maxWidth > 440 ? 440 : constraints.maxWidth,
              height: constraints.maxHeight,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopRow(context),
                    const SizedBox(height: 26),
                    const Text(
                      'Hi, Thando!',
                      style: TextStyle(
                        color: ink,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'My Next Step · A little direction for your next chapter.',
                      style: TextStyle(color: muted, fontSize: 14, height: 1.5),
                    ),
                    const SizedBox(height: 22),
                    _buildProfileCard(context),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            value: '8',
                            label: 'Relevant examples',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            value: '2',
                            label: 'Closing soon',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: muted,
                          size: 18,
                        ),
                        SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            'Illustrative opportunities · not live openings.',
                            style: TextStyle(
                              color: muted,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Your next action',
                      style: TextStyle(
                        color: ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildNextActionCard(context),
                    const SizedBox(height: 24),
                    _buildSectionHeader(
                      'Closing soon',
                      actionLabel: 'View alerts',
                      onAction: () => _showMessage(
                        context,
                        'Closing date reminders will appear here.',
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildOpportunityCard(
                      context,
                      category: 'FUNDING · EXAMPLE',
                      title: 'Future Makers Bursary',
                      organisation: 'Example Futures Trust',
                      location: 'South Africa',
                      closingDate: 'Closes 02 Nov 2026',
                      warmDate: true,
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader(
                      'Picked for your interests',
                      actionLabel: 'Explore all 8',
                      onAction: () => _showMessage(
                        context,
                        'Opportunity exploration is coming soon.',
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildOpportunityCard(
                      context,
                      category: 'STUDY · EXAMPLE',
                      title: 'Diploma in IT',
                      organisation: 'Example Technical College',
                      location: 'Durban, KwaZulu-Natal',
                      closingDate: 'Closes 30 Nov 2026',
                    ),
                    const SizedBox(height: 14),
                    _buildOpportunityCard(
                      context,
                      category: 'SKILLS · EXAMPLE',
                      title: 'IT Support Learnership',
                      organisation: 'Example Skills Hub',
                      location: 'Durban, KwaZulu-Natal',
                      closingDate: 'Closes 06 Nov 2026',
                      warmDate: true,
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader(
                      'Recently saved',
                      actionLabel: 'View all 3',
                      onAction: () => _showMessage(
                        context,
                        'Your saved opportunities will appear here.',
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildRecentlySavedCard(context),
                    const SizedBox(height: 24),
                    const Text(
                      'Suggestions use your results, interests and location. '
                      'Matching is guidance, not a guarantee of eligibility.',
                      style: TextStyle(color: muted, fontSize: 12, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            '04 — DASHBOARD · 10',
            style: TextStyle(
              color: muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        IconButton(
          tooltip: 'Notifications',
          visualDensity: VisualDensity.compact,
          onPressed: () =>
              _showMessage(context, 'You’re all caught up on notifications.'),
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: purple,
            size: 22,
          ),
        ),
        PopupMenuButton<String>(
          tooltip: 'Account options',
          icon: const Icon(Icons.more_vert_rounded, color: muted, size: 21),
          onSelected: (value) async {
            if (value == 'sign_out') {
              await AuthService().logout();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'sign_out', child: Text('Sign out')),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
      decoration: BoxDecoration(
        color: purple,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'YOUR PROFILE',
                  style: TextStyle(
                    color: Color(0xFFE0D5F5),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(
                Icons.check_circle_outline_rounded,
                color: teal,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'You’ve done the work.\nNow explore what’s\nnext.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              height: 1.23,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 1,
              minHeight: 5,
              backgroundColor: Color(0xFF785BB0),
              valueColor: AlwaysStoppedAnimation<Color>(teal),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '100% complete · APS estimate 32',
            style: TextStyle(color: Color(0xFFE4DCF2), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({required String value, required String label}) {
    return Container(
      height: 92,
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
      decoration: BoxDecoration(
        color: lavender,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: purple,
              fontSize: 29,
              height: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(label, style: const TextStyle(color: muted, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildNextActionCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: paleTeal,
        borderRadius: BorderRadius.circular(19),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DIPLOMA IN IT · IN PROGRESS',
            style: TextStyle(
              color: Color(0xFF008C84),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Get your documents ready',
            style: TextStyle(
              color: ink,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '2 of 4 documents ready. Start with your matric statement of results.',
            style: TextStyle(
              color: Color(0xFF008C84),
              fontSize: 13,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _showMessage(
                context,
                'Application preparation is coming soon.',
              ),
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward_rounded, size: 19),
              label: const Text('Continue application prep'),
              style: FilledButton.styleFrom(
                backgroundColor: purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title, {
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: ink,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            foregroundColor: purple,
            padding: const EdgeInsets.only(left: 8),
            minimumSize: const Size(0, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            actionLabel,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildOpportunityCard(
    BuildContext context, {
    required String category,
    required String title,
    required String organisation,
    required String location,
    required String closingDate,
    bool warmDate = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(17, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x17000000),
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  category,
                  style: const TextStyle(
                    color: purple,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Save $title',
                onPressed: () => _showMessage(
                  context,
                  'Saving opportunities is coming soon.',
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.bookmark_border_rounded,
                  color: purple,
                  size: 21,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: ink,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            organisation,
            style: const TextStyle(color: muted, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: muted, size: 16),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(color: muted, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: warmDate ? const Color(0xFFFFF0DE) : lavender,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  closingDate,
                  style: TextStyle(
                    color: warmDate ? const Color(0xFF9E4B08) : purple,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Opportunity example details',
                onPressed: () => _showMessage(
                  context,
                  'This is an illustrative opportunity, not a live opening.',
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.north_east_rounded,
                  color: purple,
                  size: 19,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentlySavedCard(BuildContext context) {
    return Material(
      color: lavender,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _showMessage(
          context,
          'This is an illustrative opportunity, not a live opening.',
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.bookmark_border_rounded, color: purple, size: 21),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IT Support Learnership',
                      style: TextStyle(
                        color: ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Example Skills Hub · 06 Nov 2026',
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: purple, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
        height: 72,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: border)),
            ),
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.home_outlined,
                  label: 'Home',
                  selected: true,
                  onTap: () {},
                ),
                _buildNavItem(
                  context,
                  icon: Icons.explore_outlined,
                  label: 'Explore',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ExploreScreen(),
                    ),
                  ),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.bookmark_border_rounded,
                  label: 'Saved',
                  onTap: () => _showMessage(
                    context,
                    'Your saved opportunities will appear here.',
                  ),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.assignment_outlined,
                  label: 'Applications',
                  onTap: () => _showMessage(
                    context,
                    'Application tracking is coming soon.',
                  ),
                ),
                _buildNavItem(
                  context,
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ProfileSetupScreen(),
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

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool selected = false,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 46,
                height: 28,
                decoration: BoxDecoration(
                  color: selected ? lavender : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: selected ? purple : muted, size: 21),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? purple : muted,
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
