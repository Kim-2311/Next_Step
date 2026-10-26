import '../models/opportunity.dart';
import '../models/student_profile.dart';

class OpportunityService {
  static final List<Opportunity> sampleOpportunities = [
    Opportunity(
      id: 'diploma-it',
      title: 'Diploma in IT',
      provider: 'Example Technical College',
      category: 'study',
      province: 'KwaZulu-Natal',
      town: 'Durban',
      summary:
          'Build foundations in programming, databases, networks and IT support.',
      requirements: 'NSC · Example APS 26 · Mathematics 50%+',
      closingDate: DateTime.utc(2026, 11, 30),
      duration: '3 years · Diploma · Full-time',
      minimumAps: 26,
      minimumMaths: 50,
      interests: const ['Technology', 'Engineering'],
      estimatedCost: 'Confirm fees with the institution',
      fundingLabel: 'Ask the institution about available support',
    ),
    Opportunity(
      id: 'higher-certificate-software',
      title: 'Higher Certificate in Software Development',
      provider: 'Example Coast University',
      category: 'study',
      province: 'KwaZulu-Natal',
      town: 'Durban',
      summary: 'A one-year introduction to software development.',
      requirements: 'NSC · Example APS 22 · Mathematics 50%+',
      closingDate: DateTime.utc(2026, 12, 4),
      duration: '1 year · Higher certificate',
      minimumAps: 22,
      minimumMaths: 50,
      interests: const ['Technology', 'Engineering'],
    ),
    Opportunity(
      id: 'future-makers-bursary',
      title: 'Future Makers Bursary',
      provider: 'Example Futures Trust',
      category: 'funding',
      province: 'South Africa',
      town: 'South Africa',
      summary: 'Tuition and books; financial need is assessed by the provider.',
      requirements: 'IT and engineering · Example average 65%+',
      closingDate: DateTime.utc(2026, 11, 2),
      duration: 'Funding support',
      interests: const ['Technology', 'Engineering'],
      estimatedCost: 'Tuition and books',
      fundingLabel: 'Financial need assessed',
    ),
    Opportunity(
      id: 'digital-futures-scholarship',
      title: 'Digital Futures Scholarship',
      provider: 'Example Learning Foundation',
      category: 'funding',
      province: 'South Africa',
      town: 'South Africa',
      summary: 'Course-fee support subject to academic and financial review.',
      requirements: 'Technology fields · Example average 65%+',
      closingDate: DateTime.utc(2026, 12, 11),
      duration: 'Course fee support',
      isRemote: true,
      interests: const ['Technology'],
      fundingLabel: 'Academic and financial review',
    ),
    Opportunity(
      id: 'it-support-learnership',
      title: 'IT Support Learnership',
      provider: 'Example Skills Hub',
      category: 'skills',
      province: 'KwaZulu-Natal',
      town: 'Durban',
      summary: 'Workplace training and practical IT support experience.',
      requirements: 'Matric · No experience required',
      closingDate: DateTime.utc(2026, 11, 6),
      duration: '12 months · Workplace training',
      interests: const ['Technology', 'Engineering'],
    ),
    Opportunity(
      id: 'digital-skills-internship',
      title: 'Digital Skills Internship',
      provider: 'Example Youth Lab',
      category: 'skills',
      province: 'South Africa',
      town: 'South Africa',
      summary: 'Guided digital skills practice and portfolio building.',
      requirements: 'Matric · Age 18–29 · Basic computer literacy',
      closingDate: DateTime.utc(2026, 12, 18),
      duration: '6 months · Internship and skills programme',
      isRemote: true,
      interests: const ['Technology'],
    ),
    Opportunity(
      id: 'junior-service-assistant',
      title: 'Junior Service Assistant',
      provider: 'Example Retail Co.',
      category: 'job',
      province: 'KwaZulu-Natal',
      town: 'Durban',
      summary: 'An illustrative entry-level customer service role.',
      requirements: 'Matric · 0–1 years’ experience',
      closingDate: DateTime.utc(2026, 11, 20),
      duration: 'Entry level · Full-time',
    ),
    Opportunity(
      id: 'junior-helpdesk-assistant',
      title: 'Junior Helpdesk Assistant',
      provider: 'Example Digital Services',
      category: 'job',
      province: 'KwaZulu-Natal',
      town: 'Durban',
      summary: 'An illustrative entry-level IT support role.',
      requirements: 'Matric · Basic computer skills · No experience',
      closingDate: DateTime.utc(2026, 11, 27),
      duration: 'Entry level · 6-month contract',
      minimumMaths: 40,
      interests: const ['Technology'],
    ),
  ];

  Future<List<Opportunity>> find({
    StudentProfile? profile,
    String? category,
    String query = '',
    bool includeOtherProvinces = true,
  }) async {
    final normalizedQuery = query.trim().toLowerCase();
    return sampleOpportunities.where((opportunity) {
      if (category != null && opportunity.category != category) return false;
      if (normalizedQuery.isNotEmpty &&
          !'${opportunity.title} ${opportunity.provider} '
                  '${opportunity.summary} ${opportunity.requirements}'
              .toLowerCase()
              .contains(normalizedQuery)) {
        return false;
      }
      if (profile != null &&
          !includeOtherProvinces &&
          opportunity.province != 'South Africa' &&
          opportunity.province != profile.province) {
        return false;
      }
      return true;
    }).toList();
  }

  Opportunity? byId(String id) {
    for (final opportunity in sampleOpportunities) {
      if (opportunity.id == id) return opportunity;
    }
    return null;
  }
}
