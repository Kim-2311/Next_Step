import 'package:flutter/material.dart';

import 'opportunity_browser_screen.dart';

class BursaryFundingFinderScreen extends StatelessWidget {
  const BursaryFundingFinderScreen({super.key});

  @override
  Widget build(BuildContext context) => const OpportunityBrowserScreen(
    title: 'Bursaries & funding',
    subtitle: 'Find support for the route you want to take.',
    categories: {'funding'},
  );
}
