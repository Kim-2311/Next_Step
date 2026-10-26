import 'package:flutter/material.dart';

import 'opportunity_browser_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) => const OpportunityBrowserScreen(
    title: 'Find your next possibility.',
    subtitle: 'Explore study, funding, skills and work routes.',
    showShortcuts: true,
  );
}
