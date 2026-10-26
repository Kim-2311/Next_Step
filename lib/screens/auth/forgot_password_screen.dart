import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_components.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _sending = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      if (!mounted) return;
      setState(() => _sent = true);
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      showAppMessage(
        context,
        error.code == 'network-request-failed'
            ? 'Check your internet connection and try again.'
            : 'We could not send the reset email. Please try again.',
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) => AppPage(
    title: 'A small reset. A fresh next step.',
    subtitle: 'Enter the email address you used for NextStep.',
    children: [
      InfoPanel(
        color: const Color(0xFFF2EFF7),
        child: Text(
          _sent
              ? 'If an account is registered with that address, a secure reset link has been sent. Check your inbox and spam folder.'
              : 'We’ll send a secure reset link if there’s an account with that address.',
          style: const TextStyle(color: nextStepInk, height: 1.5),
        ),
      ),
      const SizedBox(height: 20),
      Form(
        key: _formKey,
        child: TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          decoration: const InputDecoration(
            labelText: 'Email address',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            final email = value?.trim() ?? '';
            return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
                ? null
                : 'Enter a valid email address.';
          },
        ),
      ),
      const SizedBox(height: 18),
      PrimaryAction(
        label: _sending ? 'Sending…' : 'Send reset link',
        onPressed: _sending ? null : _sendReset,
      ),
      const SizedBox(height: 12),
      OutlinedButton(
        onPressed: () => Navigator.maybePop(context),
        child: const Text('Back to Log In'),
      ),
      const SizedBox(height: 12),
      const InfoPanel(
        color: Color(0xFFE4F5F2),
        child: Text(
          'Your account stays private. This message won’t reveal whether an email is registered.',
          style: TextStyle(color: Color(0xFF11857C), height: 1.5),
        ),
      ),
    ],
  );
}