import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/student_profile.dart';
import '../../services/auth_service.dart';
import '../../services/student_service.dart';
import '../../widgets/app_components.dart';
import '../navigation/app_navigation.dart';
import 'billing_plans_screen.dart';
import 'profile_setup_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  StudentProfile? _profile;
  String? _error;
  bool _loading = true;
  final Map<String, bool> _preferences = {
    'closingSoon': true,
    'savedReminders': true,
    'newMatches': true,
    'emailUpdates': false,
  };

  String get _userKey =>
      FirebaseAuth.instance.currentUser?.uid ?? 'signed-out-user';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        StudentService().loadProfile(),
        SharedPreferences.getInstance(),
      ]);
      final profile = results[0] as StudentProfile?;
      final preferences = results[1] as SharedPreferences;
      if (!mounted) return;
      setState(() {
        _profile = profile;
        for (final key in _preferences.keys.toList()) {
          _preferences[key] =
              preferences.getBool('$_userKey:$key') ?? _preferences[key]!;
        }
        _loading = false;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  Future<void> _setPreference(String key, bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('$_userKey:$key', value);
    if (mounted) setState(() => _preferences[key] = value);
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete your account?'),
        content: const Text(
          'This permanently removes your NextStep profile, saved opportunities, application records and CV draft. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete account'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!mounted) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw StateError('No signed-in account was found.');
      }
      final passwordController = TextEditingController();
      final password = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm your password'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Current password'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, passwordController.text),
              child: const Text('Continue'),
            ),
          ],
        ),
      );
      passwordController.dispose();
      if (!mounted) return;
      if (password == null || password.isEmpty) return;
      final email = user.email;
      if (email == null) {
        throw StateError('This account does not have an email address.');
      }
      await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: email, password: password),
      );
      await StudentService().deleteAccountData();
      await user.delete();
      if (!mounted) return;
      showAppMessage(context, 'Your account and saved data were deleted.');
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      showAppMessage(
        context,
        error.code == 'requires-recent-login'
            ? 'For your security, sign out and sign in again before deleting your account.'
            : 'Could not delete your account: ${error.message ?? error.code}',
      );
    } catch (error) {
      if (mounted) {
        showAppMessage(context, 'Could not delete your account: $error');
      }
    }
  }

  Future<void> _showPrivacy() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy & data permissions'),
        content: const SingleChildScrollView(
          child: Text(
            'NextStep uses your town, province, interests and matric marks to suggest routes. We do not collect ID numbers, phone numbers, street addresses or document uploads. We do not send your profile or submit applications to providers. You can delete your account data here.\n\n'
            'If you are under 18, get parent or guardian permission before entering personal information.',
            style: TextStyle(height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Your profile. Your preferences.',
    subtitle: 'Make NextStep work for you.',
    children: [
      if (_loading)
        const Center(child: CircularProgressIndicator())
      else if (_error != null)
        InfoPanel(
          child: Column(
            children: [
              Text('Could not load your profile: $_error'),
              TextButton(onPressed: _load, child: const Text('Try again')),
            ],
          ),
        )
      else ...[
        InfoPanel(
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: nextStepPurple,
                child: Text(
                  _initials(_profile?.fullName ?? ''),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _profile?.fullName.isNotEmpty == true
                          ? _profile!.fullName
                          : 'Your profile',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser?.email ?? '',
                      style: const TextStyle(color: nextStepMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _sectionTitle('Your details'),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Billing & plans'),
          subtitle: const Text('Compare free and optional action tools'),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () =>
              AppNavigation.open<void>(context, const BillingPlansScreen()),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Home location and education'),
          subtitle: Text(
            _profile == null
                ? 'Add your profile information'
                : '${_profile!.town}, ${_profile!.province} · ${_profile!.educationStatus}',
          ),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () =>
              AppNavigation.open<void>(context, const ProfileSetupScreen()),
        ),
        _sectionTitle('Your next-step profile'),
        _infoRow(
          'Matric results',
          _profile?.matricSubjects.isEmpty == false
              ? '${_profile!.matricSubjects.length} subjects · Estimated APS ${_profile!.estimatedAps}'
              : 'No results added',
        ),
        _infoRow(
          'Career interests',
          _profile?.interests.join(' · ').isNotEmpty == true
              ? _profile!.interests.join(' · ')
              : 'No interests selected',
        ),
        _infoRow(
          'Pathway preferences',
          _profile?.pathways.join(' · ').isNotEmpty == true
              ? _profile!.pathways.join(' · ')
              : 'No pathways selected',
        ),
        _infoRow(
          'Location & funding needs',
          _profile == null
              ? 'Not set'
              : '${_profile!.province}${_profile!.willingToRelocate ? ' + relocation' : ''} · ${_profile!.fundingNeed}',
        ),
        _sectionTitle('Notifications'),
        _preference('Closing-soon alerts', 'closingSoon'),
        _preference('Saved reminders', 'savedReminders'),
        _preference('New matches', 'newMatches'),
        _preference('Email updates', 'emailUpdates'),
        const Text(
          'Notification preferences are stored on this device. Deadline reminders use South African Standard Time; delivery is not guaranteed.',
          style: TextStyle(color: nextStepMuted, fontSize: 12, height: 1.5),
        ),
        _sectionTitle('Privacy & account'),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Privacy & data permissions'),
          subtitle: const Text('Manage how your information is used'),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: _showPrivacy,
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Password & account security'),
          subtitle: const Text('Reset your password through Firebase'),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => showAppMessage(
            context,
            'Use “Forgot password?” from Log In to request a secure reset email.',
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Terms of Use & Privacy Policy'),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: _showPrivacy,
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Delete account'),
          subtitle: const Text('Review before permanently removing your data'),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: _deleteAccount,
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () async {
            await AuthService().logout();
          },
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Log out'),
        ),
      ],
      const SizedBox(height: 12),
      const Text(
        'NextStep · Your results. Your options. Your next step.',
        textAlign: TextAlign.center,
        style: TextStyle(color: nextStepMuted, fontSize: 12),
      ),
    ],
  );

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(top: 18, bottom: 6),
    child: Text(
      title,
      style: const TextStyle(
        color: nextStepInk,
        fontSize: 19,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  Widget _infoRow(String title, String subtitle) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(subtitle),
  );

  Widget _preference(String label, String key) => SwitchListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(label),
    value: _preferences[key] ?? false,
    onChanged: (value) => _setPreference(key, value),
  );

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty);
    final initials = parts.take(2).map((part) => part[0].toUpperCase()).join();
    return initials.isEmpty ? 'NS' : initials;
  }
}
