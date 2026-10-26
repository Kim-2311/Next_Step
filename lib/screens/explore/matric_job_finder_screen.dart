import 'package:flutter/material.dart';

import 'opportunity_browser_screen.dart';

class MatricJobFinderScreen extends StatelessWidget {
  const MatricJobFinderScreen({super.key});

  @override
  Widget build(BuildContext context) => const OpportunityBrowserScreen(
    title: 'Matric Job Finder',
    subtitle: 'A first role. A chance to build experience.',
    categories: {'job'},
  );
}
