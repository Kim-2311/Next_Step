import 'package:flutter/material.dart';

import 'interests_screen.dart';
import 'pathways_screen.dart';
import 'results_screen.dart';

class ProfileReviewScreen extends StatelessWidget {
  const ProfileReviewScreen({
    super.key,
    required this.selectedInterests,
    required this.selectedPathways,
    required this.location,
    required this.showRemote,
    required this.fundingNeed,
  });

  static const Color purple = Color(0xFF59329B);
  static const Color ink = Color(0xFF1E1E2A);
  static const Color muted = Color(0xFF777480);
  static const Color line = Color(0xFFE6E1EC);

  final Set<String> selectedInterests;
  final Set<String> selectedPathways;
  final String location;
  final bool showRemote;
  final String fundingNeed;

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
                        const SizedBox(height: 14),
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
                        const SizedBox(height: 14),
                        const Text(
                          'This is your\nstarting line.',
                          style: TextStyle(
                            fontSize: 30,
                            height: 1.08,
                            fontWeight: FontWeight.w800,
                            color: ink,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Looking good, Thando. Check your details before finding your options.',
                          style: TextStyle(
                            fontSize: 14,
                            color: muted,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildStudentCard(),
                        const SizedBox(height: 20),
                        _buildSectionHeader(
                          'Matric results',
                          onEdit: () =>
                              _open(context, const ProfileResultsScreen()),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'ESTIMATED APS',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 0.8,
                            color: purple,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildApsChip(),
                        const SizedBox(height: 10),
                        const Text(
                          'English HL 65% · IsiZulu HL 72%\n'
                          'Mathematics 68% · Physical Sciences 61%\n'
                          'Life Sciences 70% · Geography 66%\n'
                          'Life Orientation 78% (excluded from APS)',
                          style: TextStyle(
                            fontSize: 12,
                            color: muted,
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Six-subject NSC estimate. APS scoring and subject requirements vary by institution.',
                          style: TextStyle(
                            fontSize: 12,
                            color: muted,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 22),
                        _buildSectionHeader(
                          'Your interests',
                          onEdit: () => _open(
                            context,
                            ProfileInterestsScreen(
                              selectedInterests: selectedInterests,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: selectedInterests
                              .map(
                                (interest) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF4F0FA),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Text(
                                    interest,
                                    style: const TextStyle(
                                      color: purple,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 22),
                        _buildSectionHeader(
                          'Your pathways',
                          onEdit: () => _open(
                            context,
                            ProfilePathwaysScreen(
                              selectedInterests: selectedInterests,
                              selectedPathways: selectedPathways,
                              location: location,
                              showRemote: showRemote,
                              fundingNeed: fundingNeed,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          selectedPathways.join(' · '),
                          style: const TextStyle(
                            fontSize: 13,
                            color: muted,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$location${showRemote ? ' + remote' : ''}\nFunding: $fundingNeed',
                          style: const TextStyle(
                            fontSize: 12,
                            color: muted,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildReadyNotice(),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _completeProfile(context),
                            icon: const Text('Complete Profile'),
                            label: const Icon(Icons.check_rounded, size: 18),
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
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _completeProfile(context),
                            icon: const Text('Find My Opportunities'),
                            label: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: purple,
                              side: const BorderSide(color: line),
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
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

  Widget _buildStudentCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EFF8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: purple,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'TD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thando Dlamini',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: ink,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Durban, KwaZulu-Natal · Matric 2025',
                  style: TextStyle(fontSize: 12, color: muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onEdit}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: ink,
            ),
          ),
        ),
        TextButton(
          onPressed: onEdit,
          style: TextButton.styleFrom(
            foregroundColor: purple,
            padding: EdgeInsets.zero,
            minimumSize: const Size(36, 32),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Edit',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildApsChip() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFE9F6F3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          '32 / 42',
          style: TextStyle(
            color: Color(0xFF168C8B),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildReadyNotice() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F6F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: Color(0xFF168C8B),
            size: 18,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'All four setup steps are ready. You can change your choices whenever you need.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF168C8B),
                height: 1.45,
              ),
            ),
          ),
        ],
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

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  void _completeProfile(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).popUntil((route) => route.isFirst);
    messenger.showSnackBar(
      const SnackBar(
        content: Text(
          'Your profile is complete. Opportunity matching is next.',
        ),
      ),
    );
  }
}
