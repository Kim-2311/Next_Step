import 'package:flutter/material.dart';

import 'opportunity_browser_screen.dart';

class StudyFinderScreen extends StatelessWidget {
  const StudyFinderScreen({super.key});

  @override
  Widget build(BuildContext context) => const OpportunityBrowserScreen(
    title: 'Study Finder',
    subtitle: 'Your results can open more than one door.',
    categories: {'study'},
  );
}
