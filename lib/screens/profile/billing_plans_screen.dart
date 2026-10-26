import 'package:flutter/material.dart';

import '../../widgets/app_components.dart';

class BillingPlansScreen extends StatelessWidget {
  const BillingPlansScreen({super.key});

  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Billing & plans',
    subtitle: 'Explore for free. Add action tools when you are ready.',
    children: [
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: nextStepBorder),
        ),
        child: const Padding(
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Free',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 8),
              Text(
                'NextStep Starter',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 10),
              Text('Profile creation and an estimated APS guide'),
              Text('Study, funding, skills and work examples'),
              Text('Plan B alternatives and checklists'),
              SizedBox(height: 10),
              Text('No payment needed.'),
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),
      Card(
        color: nextStepLavender,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: nextStepPurple),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'READY TO TAKE ACTION?',
                style: TextStyle(
                  color: nextStepPurple,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'NextStep Action',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
              ),
              const Text(
                'Proposed R170 one-time fee · not a monthly subscription.',
                style: TextStyle(color: nextStepMuted, height: 1.5),
              ),
              const SizedBox(height: 12),
              const Text('Everything in Starter, plus:'),
              const SizedBox(height: 8),
              const Text('✓ CV assistant and editable CV drafts'),
              const Text('✓ Application tracker'),
              const Text('✓ GlobalConnect research routes'),
              const SizedBox(height: 14),
              OutlinedButton(
                onPressed: () => showAppMessage(
                  context,
                  'Payments are not connected in this build. No charge has been made.',
                ),
                child: const Text('Upgrade to NextStep Action'),
              ),
              const SizedBox(height: 8),
              const Text(
                'The proposed price and benefits are not a purchase offer. Payment and premium access are not enabled.',
                style: TextStyle(color: nextStepMuted, fontSize: 12, height: 1.5),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 14),
      const InfoPanel(
        child: Text(
          'Career guidance is a right, not a privilege. Finding out what you can do with your results remains free.',
          style: TextStyle(color: nextStepInk, height: 1.5),
        ),
      ),
    ],
  );
}
