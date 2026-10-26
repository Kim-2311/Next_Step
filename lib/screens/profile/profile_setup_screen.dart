import 'package:flutter/material.dart';

import '../../models/student_profile.dart';
import '../../services/student_service.dart';
import 'results_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  static const Color purple = Color(0xFF59329B);
  static const Color purpleSoft = Color(0xFFF2ECFF);
  static const Color ink = Color(0xFF1E1E2A);
  static const Color muted = Color(0xFF6D6D78);

  final _fullNameController = TextEditingController();
  final _cityController = TextEditingController();

  String _province = 'KwaZulu-Natal';
  String _matricYear = '2025';
  String _educationStatus = 'Matric completed';
  bool _willingToRelocate = false;

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  Future<void> _loadExistingProfile() async {
    try {
      final profile = await StudentService().loadProfile();
      if (!mounted || profile == null) return;
      setState(() {
        _fullNameController.text = profile.fullName;
        _cityController.text = profile.town;
        if ([
          'KwaZulu-Natal',
          'Gauteng',
          'Western Cape',
          'Eastern Cape',
          'Free State',
          'Limpopo',
          'Mpumalanga',
          'Northern Cape',
          'North West',
        ].contains(profile.province)) {
          _province = profile.province;
        }
        _matricYear = profile.matricYear;
        _educationStatus = profile.educationStatus;
        _willingToRelocate = profile.willingToRelocate;
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not load your saved profile: $error')),
        );
      }
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1F6),
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
                              'Step 1 of 4',
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
                          '03 — PROFILE SETUP — 05',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.2,
                            color: purple,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Your profile',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: ink,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Divider(
                          color: Color(0xFFE7E1ED),
                          thickness: 1.5,
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'First, a little\nabout you.',
                          style: TextStyle(
                            fontSize: 30,
                            height: 1.08,
                            fontWeight: FontWeight.w800,
                            color: ink,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "We'll use these details to bring options closer to home.",
                          style: TextStyle(
                            fontSize: 14,
                            color: muted,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 22),
                        _buildFieldLabel('Full name'),
                        _buildTextField(
                          controller: _fullNameController,
                          suffixIcon: const Icon(
                            Icons.person_outline_rounded,
                            size: 18,
                            color: purple,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildFieldLabel('City or town'),
                        _buildTextField(
                          controller: _cityController,
                          suffixIcon: const Icon(Icons.location_on_outlined, size: 18, color: purple),
                        ),
                        const SizedBox(height: 12),
                        _buildFieldLabel('Province'),
                        _buildDropdown(
                          value: _province,
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
                          onChanged: (value) => setState(() => _province = value ?? _province),
                        ),
                        const SizedBox(height: 12),
                        _buildFieldLabel('Matric completion year'),
                        _buildDropdown(
                          value: _matricYear,
                          items: const ['2025', '2024', '2023', '2022'],
                          onChanged: (value) => setState(() => _matricYear = value ?? _matricYear),
                        ),
                        const SizedBox(height: 12),
                        _buildFieldLabel('Current education status'),
                        _buildDropdown(
                          value: _educationStatus,
                          items: const ['Matric completed', 'Still in matric', 'Completed tertiary', 'Working full time'],
                          onChanged: (value) => setState(() => _educationStatus = value ?? _educationStatus),
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Open to relocating'),
                          subtitle: const Text(
                            'Include options outside your home province.',
                          ),
                          value: _willingToRelocate,
                          onChanged: (value) =>
                              setState(() => _willingToRelocate = value),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: purpleSoft,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'You can explore opportunities anywhere in South Africa. Your home location simply helps us sort what\'s relevant.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    height: 1.48,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_fullNameController.text.trim().isEmpty ||
                                  _cityController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Enter your name and city or town to continue.',
                                    ),
                                  ),
                                );
                                return;
                              }
                              final profile = StudentProfile(
                                fullName: _fullNameController.text.trim(),
                                town: _cityController.text.trim(),
                                province: _province,
                                matricYear: _matricYear,
                                educationStatus: _educationStatus,
                                willingToRelocate: _willingToRelocate,
                              );
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ProfileResultsScreen(
                                    profile: profile,
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
                              'Continue to results',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Center(
                          child: Text(
                            'You can update your information at any time in Profile.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: muted,
                              fontSize: 12,
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

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required Icon suffixIcon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 16, color: ink),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDBD5E2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: purple, width: 1.4),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: suffixIcon,
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDBD5E2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Padding(
            padding: EdgeInsets.only(right: 14),
            child: Icon(Icons.keyboard_arrow_down_rounded, color: purple),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 16, color: ink),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
