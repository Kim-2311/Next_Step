import 'package:flutter/material.dart';

import '../navigation/app_navigation.dart';
import '../../widgets/app_components.dart';
import '../explore/bursary_funding_finder_screen.dart';

class FundingComparisonScreen extends StatefulWidget {
  const FundingComparisonScreen({super.key});

  @override
  State<FundingComparisonScreen> createState() =>
      _FundingComparisonScreenState();
}

class _FundingComparisonScreenState extends State<FundingComparisonScreen> {
  static const _checkItems = [
    'List tuition, books, travel and living costs',
    'Check what is excluded and who pays the shortfall',
    'Read renewal, repayment and work-back conditions',
  ];
  final Set<String> _checked = {};

  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Understand the cost. Choose with care.',
    subtitle: 'Funding comparison · Types of support, not live offers.',
    children: [
      const InfoPanel(
        color: Color(0xFFE4F5F2),
        child: Text(
          'YOUR FUNDING NEEDS\n\nFunding can help with tuition, books, transport or accommodation. Eligibility and coverage are assessed by each provider.',
          style: TextStyle(color: Color(0xFF11857C), height: 1.5),
        ),
      ),
      const SizedBox(height: 14),
      const Text(
        'Conditions can include service or work-back obligations. Check each agreement; “bursary” does not always mean no obligations.',
        style: TextStyle(color: nextStepMuted, height: 1.5),
      ),
      const SizedBox(height: 14),
      const _FundingType(
        title: 'Public student funding',
        badge: 'Check official criteria',
        coverage:
            'May support approved tuition and allowances at eligible public institutions. Rules and caps apply.',
        eligibility:
            'Citizenship or residency, household means and academic progression may matter.',
        obligations:
            'Bursary and loan rules differ. Confirm your award type and repayment requirements.',
        caution:
            'Use the official NSFAS website for current rules. Do not assume every qualification or cost is covered.',
      ),
      const _FundingType(
        title: 'Bursaries',
        badge: 'Often need or field based',
        coverage:
            'May cover tuition, books, accommodation or transport. Some awards cover only part of the cost.',
        eligibility:
            'May assess income, marks, field of study, citizenship and a confirmed study offer.',
        obligations:
            'Usually no repayment if conditions are met. A work-back obligation or repayment clause may apply.',
        caution:
            'Read renewal rules, contract terms and service obligations before accepting.',
      ),
      const _FundingType(
        title: 'Scholarships',
        badge: 'Often achievement based',
        coverage:
            'May pay course fees or a fixed award. Living costs are not always included.',
        eligibility:
            'May assess academic merit, talent, leadership and sometimes financial need.',
        obligations:
            'Confirm renewal conditions and whether another award can be held at the same time.',
        caution:
            'Confirm all conditions with the provider before relying on an award.',
      ),
      const _FundingType(
        title: 'Student loans',
        badge: 'Repayment required',
        coverage:
            'May fund tuition and selected study costs, subject to lender approval and limits.',
        eligibility:
            'Affordability checks and sometimes a guarantor or surety may be required.',
        obligations:
            'Borrowed money plus interest and fees must be repaid under the agreement.',
        caution:
            'Compare the full cost, interest, repayment start date and what happens if circumstances change.',
      ),
      const SizedBox(height: 16),
      const Text(
        'Before you accept funding',
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
      ),
      ..._checkItems.map(
        (item) => CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(item),
          value: _checked.contains(item),
          onChanged: (value) => setState(() {
            if (value == true) {
              _checked.add(item);
            } else {
              _checked.remove(item);
            }
          }),
        ),
      ),
      OutlinedButton(
        onPressed: () => AppNavigation.open<void>(
          context,
          const BursaryFundingFinderScreen(),
        ),
        child: const Text('Back to bursaries & funding'),
      ),
      const SizedBox(height: 12),
      const Text(
        'General guidance, not financial advice or an award offer. Confirm all current coverage and eligibility with each official provider.',
        style: TextStyle(color: nextStepMuted, fontSize: 12, height: 1.5),
      ),
    ],
  );
}

class _FundingType extends StatelessWidget {
  const _FundingType({
    required this.title,
    required this.badge,
    required this.coverage,
    required this.eligibility,
    required this.obligations,
    required this.caution,
  });

  final String title;
  final String badge;
  final String coverage;
  final String eligibility;
  final String obligations;
  final String caution;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: nextStepBorder),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          Chip(
            label: Text(badge),
            backgroundColor: nextStepLavender,
            labelStyle: const TextStyle(color: nextStepPurple),
            side: BorderSide.none,
          ),
          _FundingDetail(label: 'WHAT IT MAY COVER', text: coverage),
          _FundingDetail(label: 'WHO MAY QUALIFY', text: eligibility),
          _FundingDetail(label: 'REPAYMENT & OBLIGATIONS', text: obligations),
          const SizedBox(height: 8),
          InfoPanel(
            child: Text(
              caution,
              style: const TextStyle(color: nextStepMuted, height: 1.45),
            ),
          ),
        ],
      ),
    ),
  );
}

class _FundingDetail extends StatelessWidget {
  const _FundingDetail({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: nextStepPurple,
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 3),
        Text(text, style: const TextStyle(color: nextStepMuted, height: 1.4)),
      ],
    ),
  );
}