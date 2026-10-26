import '../models/opportunity.dart';
import '../models/student_profile.dart';

class OpportunityMatch {
  const OpportunityMatch({
    required this.opportunity,
    required this.reasons,
    required this.requirementsToCheck,
  });

  final Opportunity opportunity;
  final List<String> reasons;
  final List<String> requirementsToCheck;
}

class DecisionEngine {
  List<OpportunityMatch> recommend({
    required StudentProfile profile,
    required Iterable<Opportunity> opportunities,
  }) {
    final results = <OpportunityMatch>[];
    for (final opportunity in opportunities) {
      if (profile.pathways.isNotEmpty &&
          !_pathwayMatches(profile.pathways, opportunity.category)) {
        continue;
      }
      final reasons = <String>[];
      final checks = <String>[];
      if (opportunity.interests.any(profile.interests.contains)) {
        reasons.add('Matches one or more of your selected interests');
      }
      if (opportunity.province == profile.province ||
          opportunity.province == 'South Africa' ||
          opportunity.isRemote) {
        reasons.add('Available in your preferred area or remotely');
      } else if (profile.willingToRelocate) {
        reasons.add('You are open to relocating');
      }
      if (opportunity.minimumAps != null) {
        if (profile.estimatedAps >= opportunity.minimumAps!) {
          reasons.add('Your estimated APS meets the example threshold');
        } else {
          checks.add('Your estimated APS is below the example threshold');
        }
      }
      if (opportunity.minimumMaths != null) {
        int? maths;
        for (final entry in profile.matricSubjects.entries) {
          if (entry.key.toLowerCase() == 'mathematics') {
            maths = entry.value;
            break;
          }
        }
        if (maths == null) {
          checks.add('Confirm the mathematics requirement with the provider');
        } else if (maths < opportunity.minimumMaths!) {
          checks.add('Your mathematics mark is below the example threshold');
        } else {
          reasons.add('Your mathematics mark meets the example threshold');
        }
      }
      if (reasons.isEmpty) reasons.add('Consider this as another route to explore');
      if (checks.isEmpty) {
        checks.add('Verify current criteria, dates and availability with provider');
      }
      results.add(
        OpportunityMatch(
          opportunity: opportunity,
          reasons: reasons,
          requirementsToCheck: checks,
        ),
      );
    }
    results.sort((a, b) {
      final requirementOrder = a.requirementsToCheck.length.compareTo(
        b.requirementsToCheck.length,
      );
      if (requirementOrder != 0) return requirementOrder;
      return a.opportunity.closingDate.compareTo(b.opportunity.closingDate);
    });
    return results;
  }

  bool _pathwayMatches(List<String> pathways, String category) {
    switch (category) {
      case 'study':
        return pathways.contains('Study') || pathways.contains('Study and work');
      case 'funding':
        return pathways.contains('Bursaries and funding');
      case 'skills':
        return pathways.any(
          (pathway) =>
              pathway.contains('Learnership') ||
              pathway.contains('Internship') ||
              pathway.contains('skills') ||
              pathway == 'Find a job' ||
              pathway == 'Study and work',
        );
      case 'job':
        return pathways.contains('Find a job') ||
            pathways.contains('Study and work');
      default:
        return false;
    }
  }
}