import 'package:flutter/material.dart';

import 'opportunity_browser_screen.dart';

class LearnershipsSkillsScreen extends StatelessWidget {
  const LearnershipsSkillsScreen({super.key});

  @override
  Widget build(BuildContext context) => const OpportunityBrowserScreen(
    title: 'Learn by doing.',
    subtitle: 'Learnerships & skills · Build confidence through hands-on experience.',
    categories: {'skills'},
  );
}
