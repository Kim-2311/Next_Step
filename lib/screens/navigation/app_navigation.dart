import 'package:flutter/material.dart';

import '../applications/application_tracker_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../explore/explore_screen.dart';
import '../profile/profile_settings_screen.dart';
import '../saved/saved_opportunities_screen.dart';

class AppNavigation {
  const AppNavigation._();

  static Future<T?> open<T>(BuildContext context, Widget screen) =>
      Navigator.of(context).push<T>(
        MaterialPageRoute<T>(builder: (_) => screen),
      );

  static Future<T?> openExplore<T>(BuildContext context) =>
      open<T>(context, const ExploreScreen());

  static Future<T?> openSaved<T>(BuildContext context) =>
      open<T>(context, const SavedOpportunitiesScreen());

  static Future<T?> openApplications<T>(BuildContext context) =>
      open<T>(context, const ApplicationTrackerScreen());

  static Future<T?> openProfile<T>(BuildContext context) =>
      open<T>(context, const ProfileSettingsScreen());

  static Future<T?> openHome<T>(BuildContext context) =>
      open<T>(context, const DashboardScreen());
}