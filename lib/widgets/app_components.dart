import 'package:flutter/material.dart';

const nextStepPurple = Color(0xFF59329B);
const nextStepTeal = Color(0xFF18A7A5);
const nextStepInk = Color(0xFF272533);
const nextStepMuted = Color(0xFF777384);
const nextStepLavender = Color(0xFFF2EFF7);
const nextStepBorder = Color(0xFFE4DDED);

class AppPage extends StatelessWidget {
  const AppPage({
    required this.title,
    required this.subtitle,
    required this.children,
    super.key,
    this.showBackButton = true,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      foregroundColor: nextStepInk,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              tooltip: 'Back',
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(Icons.arrow_back_rounded),
            )
          : null,
      title: const Text('NextStep', style: TextStyle(color: nextStepPurple)),
    ),
    body: SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: nextStepInk,
                    fontSize: 30,
                    height: 1.12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: nextStepMuted,
                    fontSize: 16,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 22),
                ...children,
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class InfoPanel extends StatelessWidget {
  const InfoPanel({
    required this.child,
    super.key,
    this.color = nextStepLavender,
  });

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(18),
    ),
    child: child,
  );
}

class PrimaryAction extends StatelessWidget {
  const PrimaryAction({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.arrow_forward_rounded),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: nextStepPurple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

void showAppMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
