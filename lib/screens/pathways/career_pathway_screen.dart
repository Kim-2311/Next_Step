import 'package:flutter/material.dart';

import '../../models/opportunity.dart';
import '../../services/opportunity_service.dart';
import '../../widgets/app_components.dart';
import '../explore/opportunity_details_screen.dart';

class CareerPathwayScreen extends StatefulWidget {
  const CareerPathwayScreen({super.key});

  @override
  State<CareerPathwayScreen> createState() => _CareerPathwayScreenState();
}

class _CareerPathwayScreenState extends State<CareerPathwayScreen> {
  String _field = 'Technology';
  final _fields = const [
    'Technology',
    'Business and Finance',
    'Health and Medicine',
    'Engineering',
    'Education',
    'Creative Arts and Design',
    'Science and Environment',
  ];

  @override
  Widget build(BuildContext context) {
    final related = OpportunityService.sampleOpportunities
        .where(
          (item) =>
              item.interests.contains(_field) ||
              item.category == 'job' ||
              item.category == 'skills',
        )
        .take(3);
    return AppPage(
      title: 'See where a first step can lead.',
      subtitle: 'Career Pathway Explorer · $_field',
      children: [
        DropdownButtonFormField<String>(
          initialValue: _field,
          decoration: const InputDecoration(
            labelText: 'Explore a field',
            border: OutlineInputBorder(),
          ),
          items: _fields
              .map((field) => DropdownMenuItem(value: field, child: Text(field)))
              .toList(),
          onChanged: (value) => setState(() => _field = value ?? _field),
        ),
        const SizedBox(height: 14),
        const InfoPanel(
          child: Text(
            'ONE POSSIBLE ROUTE\n\nThis pathway is illustrative, not a guaranteed career outcome. You can enter, pause or change direction at different points.',
            style: TextStyle(color: nextStepMuted, height: 1.5),
          ),
        ),
        const SizedBox(height: 20),
        const _PathStep(
          title: 'Matric',
          label: 'YOUR STARTING POINT',
          description:
              'Build on your NSC results and explore entry requirements. Requirements differ by institution.',
          skills: 'Communication · Numeracy · Digital basics',
          icon: Icons.check_circle_rounded,
        ),
        const _PathStep(
          title: 'Diploma or certificate',
          label: 'BUILD A FOUNDATION',
          description:
              'Explore an accredited qualification or short course. Check fees, accreditation and entry criteria.',
          skills: 'Problem-solving · Practical projects · Teamwork',
          icon: Icons.school_rounded,
        ),
        const _PathStep(
          title: 'Learnership or internship',
          label: 'PUT LEARNING INTO PRACTICE',
          description:
              'Gain supervised experience and build a portfolio. Ask about costs, stipend and selection rules.',
          skills: 'Collaboration · Communication · Practice',
          icon: Icons.work_outline_rounded,
        ),
        const _PathStep(
          title: 'Entry-level role',
          label: 'GROW THROUGH EXPERIENCE',
          description:
              'Apply through an employer’s verified channel and continue developing skills as you work.',
          skills: 'Dependability · Evidence · Continuous learning',
          icon: Icons.trending_up_rounded,
        ),
        const SizedBox(height: 14),
        const Text(
          'Related opportunities',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        ...related.map(
          (item) => _RelatedOpportunity(
            item: item,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => OpportunityDetailsScreen(opportunity: item),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PathStep extends StatelessWidget {
  const _PathStep({
    required this.title,
    required this.label,
    required this.description,
    required this.skills,
    required this.icon,
  });

  final String title;
  final String label;
  final String description;
  final String skills;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: nextStepPurple),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: nextStepPurple,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: const TextStyle(color: nextStepMuted, height: 1.5),
              ),
              const SizedBox(height: 6),
              Text(
                skills,
                style: const TextStyle(
                  color: nextStepPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _RelatedOpportunity extends StatelessWidget {
  const _RelatedOpportunity({required this.item, required this.onTap});

  final Opportunity item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      title: Text(item.title),
      subtitle: Text('${item.provider} · ${item.closingDateLabel}'),
      trailing: const Icon(Icons.open_in_new, color: nextStepPurple),
      onTap: onTap,
    ),
  );
}