import 'package:flutter/material.dart';

import '../navigation/app_navigation.dart';
import '../../services/plan_b_service.dart';
import '../../widgets/app_components.dart';
import '../explore/study_finder_screen.dart';
import '../explore/matric_job_finder_screen.dart';

class PlanBScreen extends StatefulWidget {
  const PlanBScreen({super.key});

  @override
  State<PlanBScreen> createState() => _PlanBScreenState();
}

class _PlanBScreenState extends State<PlanBScreen> {
  PlanBSituation _situation = PlanBSituation.unsure;
  final _service = PlanBService();

  static const _situations = <PlanBSituation, String>{
    PlanBSituation.marks: 'I did not get the marks I needed',
    PlanBSituation.rejected: 'I was rejected',
    PlanBSituation.waitlisted: 'I am waitlisted',
    PlanBSituation.deadlinesClosed: 'Applications have closed',
    PlanBSituation.cannotAfford: 'I cannot afford tuition',
    PlanBSituation.bursaryDeclined: 'I did not qualify for funding',
    PlanBSituation.unsure: 'I am unsure what to study',
    PlanBSituation.wantsWork: 'I want to start working',
  };

  @override
  Widget build(BuildContext context) {
    final routes = _service.routesFor(_situation);
    return AppPage(
      title: 'Another route. Still your future.',
      subtitle: 'Plan B · Consider alternatives that fit your starting point.',
      children: [
        const InfoPanel(
          color: Color(0xFFE4F5F2),
          child: Text(
            'Plan B supports your choices. It does not guarantee admission, funding, a job or a placement.',
            style: TextStyle(color: Color(0xFF11857C), height: 1.5),
          ),
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<PlanBSituation>(
          initialValue: _situation,
          decoration: const InputDecoration(
            labelText: 'What are you navigating right now?',
            border: OutlineInputBorder(),
          ),
          items: _situations.entries
              .map(
                (entry) => DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value),
                ),
              )
              .toList(),
          onChanged: (value) => setState(
            () => _situation = value ?? PlanBSituation.unsure,
          ),
        ),
        const SizedBox(height: 18),
        ...routes.map(
          (route) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InfoPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    route.track.toUpperCase(),
                    style: const TextStyle(
                      color: nextStepPurple,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    route.title,
                    style: const TextStyle(
                      color: nextStepInk,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    route.description,
                    style: const TextStyle(color: nextStepMuted, height: 1.5),
                  ),
                  TextButton(
                    onPressed: () => _openRoute(context, route.track),
                    child: const Text('Explore this route →'),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_situation == PlanBSituation.marks)
          const InfoPanel(
            color: Color(0xFFF8F6FA),
            child: Text(
              'Subject rewrites may be possible through recognised programmes such as the Second Chance Matric Programme. Check current eligibility, dates and registration details with the Department of Basic Education.',
              style: TextStyle(color: nextStepMuted, height: 1.5),
            ),
          ),
        if (_situation == PlanBSituation.cannotAfford ||
            _situation == PlanBSituation.bursaryDeclined)
          const InfoPanel(
            color: Color(0xFFFFF0DE),
            child: Text(
              'If you have received an NSFAS funding decision, confirm current rules directly with NSFAS before taking a gap year. A gap year may affect future funding eligibility.',
              style: TextStyle(color: Color(0xFF9E5A10), height: 1.5),
            ),
          ),
      ],
    );
  }

  void _openRoute(BuildContext context, String track) {
    if (track == 'study') {
      AppNavigation.open<void>(context, const StudyFinderScreen());
    } else {
      AppNavigation.open<void>(context, const MatricJobFinderScreen());
    }
  }
}