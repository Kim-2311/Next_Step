import 'package:flutter/material.dart';

import 'interests_screen.dart';

class ProfileResultsScreen extends StatefulWidget {
  const ProfileResultsScreen({super.key});

  @override
  State<ProfileResultsScreen> createState() => _ProfileResultsScreenState();
}

class _ProfileResultsScreenState extends State<ProfileResultsScreen> {
  static const Color purple = Color(0xFF59329B);
  static const Color ink = Color(0xFF1E1E2A);
  static const Color muted = Color(0xFF6D6D78);
  static const Color panel = Color(0xFFE9F6F3);
  static const Color line = Color(0xFFE6E1EC);

  final List<_SubjectResult> _subjects = const [
    _SubjectResult(name: 'English HL', mark: 65),
    _SubjectResult(name: 'IsiZulu HL', mark: 72),
    _SubjectResult(name: 'Mathematics', mark: 68),
    _SubjectResult(name: 'Physical Sciences', mark: 61),
    _SubjectResult(name: 'Life Sciences', mark: 70),
    _SubjectResult(name: 'Geography', mark: 66),
    _SubjectResult(name: 'Life Orientation', mark: 78),
  ];

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
                              'Step 2 of 4',
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
                        const Divider(
                          color: line,
                          thickness: 1.5,
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Your results are\na starting point.',
                          style: TextStyle(
                            fontSize: 30,
                            height: 1.08,
                            fontWeight: FontWeight.w800,
                            color: ink,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Add your final NSC subject percentages. They\ndon\'t define your potential.',
                          style: TextStyle(
                            fontSize: 14,
                            color: muted,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 22),
                        _buildResultsTable(),
                        const SizedBox(height: 14),
                        _buildAddSubjectButton(),
                        const SizedBox(height: 22),
                        _buildSummaryPanel(),
                        const SizedBox(height: 28),
                        _buildSaveButton(),
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

  Widget _buildResultsTable() {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: Text(
                'SUBJECT',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: muted,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            SizedBox(width: 90,
              child: Text(
                'MARK % / POINTS',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: muted,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ..._subjects.map((subject) => _SubjectRow(subject: subject)),
      ],
    );
  }

  Widget _buildAddSubjectButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: line),
      ),
      child: TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add_circle_outline_rounded, color: purple),
        label: const Text(
          'Add another subject',
          style: TextStyle(
            color: purple,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'ILLUSTRATIVE APS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: muted,
                  letterSpacing: 1.0,
                ),
              ),
              const Spacer(),
              Text(
                '6 subjects',
                style: TextStyle(
                  fontSize: 12,
                  color: purple,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: const [
              Text(
                '32 / 42',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: ink,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '5 + 6 + 5 + 6 + 5 + 5 = 32. Life Orientation is\nexcluded from this estimate.',
            style: TextStyle(
              fontSize: 13,
              color: ink,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'HOW THIS ESTIMATE WORKS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: muted,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '80–100% = 7–10\n70–79% = 6\n60–69% = 5\n50–59% = 4\n40–49% = 3\n30–39% = 2\n0–29% = 1\n\nWe sum your six non-LO subjects here. This is a\nguide estimate, not an institution\'s official APS.\nInstitutions may count different subjects, weight\nmarks, exclude other subjects or set additional\nrequirements.',
            style: TextStyle(
              fontSize: 13,
              color: ink,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ProfileInterestsScreen(),
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
          'Save Results',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SubjectRow extends StatelessWidget {
  const _SubjectRow({required this.subject});

  static const Color purple = Color(0xFF59329B);
  static const Color ink = Color(0xFF1E1E2A);
  static const Color line = Color(0xFFE6E1EC);

  final _SubjectResult subject;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: line),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: subject.name,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: purple),
                items: const [
                  DropdownMenuItem(value: 'English HL', child: Text('English HL')),
                  DropdownMenuItem(value: 'IsiZulu HL', child: Text('IsiZulu HL')),
                  DropdownMenuItem(value: 'Mathematics', child: Text('Mathematics')),
                  DropdownMenuItem(value: 'Physical Sciences', child: Text('Physical Sciences')),
                  DropdownMenuItem(value: 'Life Sciences', child: Text('Life Sciences')),
                  DropdownMenuItem(value: 'Geography', child: Text('Geography')),
                  DropdownMenuItem(value: 'Life Orientation', child: Text('Life Orientation')),
                ],
                onChanged: (_) {},
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEF6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  '${subject.mark}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.close_rounded, size: 15, color: purple),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectResult {
  const _SubjectResult({required this.name, required this.mark});

  final String name;
  final int mark;
}
