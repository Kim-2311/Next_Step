import 'package:flutter/material.dart';

import '../auth_screen.dart';
import '../../widgets/app_components.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({required this.onFinished, super.key});

  final VoidCallback onFinished;

  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Your future isn’t one-size-fits-all.',
    subtitle: 'Let’s find a next step that feels like you.',
    showBackButton: false,
    children: [
      Container(
        height: 220,
        decoration: BoxDecoration(
          color: nextStepLavender,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: Icon(Icons.alt_route_rounded, color: nextStepPurple, size: 96),
        ),
      ),
      const SizedBox(height: 18),
      const Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _WelcomeTag('Study'),
          _WelcomeTag('Jobs'),
          _WelcomeTag('Funding'),
          _WelcomeTag('Skills'),
        ],
      ),
      const SizedBox(height: 18),
      const Text(
        'Turn your results, interests and location into options worth exploring. '
        'Guidance, not guarantees: final decisions rest with each organisation.',
        style: TextStyle(color: nextStepMuted, fontSize: 15, height: 1.55),
      ),
      const SizedBox(height: 20),
      PrimaryAction(
        label: 'Get started · Create account',
        onPressed: onFinished,
      ),
      const SizedBox(height: 10),
      OutlinedButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AuthScreen()),
        ),
        child: const Text('Log in'),
      ),
    ],
  );
}

class _WelcomeTag extends StatelessWidget {
  const _WelcomeTag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Chip(
    label: Text(label),
    backgroundColor: nextStepLavender,
    labelStyle: const TextStyle(color: nextStepPurple),
    side: BorderSide.none,
  );
}