enum PlanBSituation {
  marks,
  rejected,
  waitlisted,
  deadlinesClosed,
  cannotAfford,
  bursaryDeclined,
  unsure,
  wantsWork,
}

class PlanBRoute {
  const PlanBRoute({
    required this.title,
    required this.description,
    required this.track,
  });

  final String title;
  final String description;
  final String track;
}

class PlanBService {
  List<PlanBRoute> routesFor(PlanBSituation situation) {
    switch (situation) {
      case PlanBSituation.marks:
        return const [
          PlanBRoute(
            title: 'Explore higher certificates and TVET',
            description:
                'Compare entry requirements and ask institutions about bridging routes.',
            track: 'study',
          ),
          PlanBRoute(
            title: 'Consider a structured skills route',
            description:
                'Explore learnerships while checking subject rewrite options.',
            track: 'work',
          ),
        ];
      case PlanBSituation.rejected:
      case PlanBSituation.waitlisted:
      case PlanBSituation.deadlinesClosed:
        return const [
          PlanBRoute(
            title: 'Keep another study route open',
            description:
                'Check later application dates, higher certificates and TVET options.',
            track: 'study',
          ),
          PlanBRoute(
            title: 'Build experience while you plan',
            description:
                'Compare learnerships and entry-level work. Confirm openings directly.',
            track: 'work',
          ),
        ];
      case PlanBSituation.cannotAfford:
      case PlanBSituation.bursaryDeclined:
        return const [
          PlanBRoute(
            title: 'Compare funding and lower-cost routes',
            description:
                'Review bursaries, public funding criteria and travel or accommodation costs.',
            track: 'study',
          ),
          PlanBRoute(
            title: 'Earn while building skills',
            description:
                'Explore paid workplace learning and short skills programmes.',
            track: 'work',
          ),
        ];
      case PlanBSituation.unsure:
        return const [
          PlanBRoute(
            title: 'Try a career pathway',
            description:
                'Compare a qualification route with workplace learning before deciding.',
            track: 'study',
          ),
          PlanBRoute(
            title: 'Explore work and skills',
            description:
                'Start with practical experience and revisit study options later.',
            track: 'work',
          ),
        ];
      case PlanBSituation.wantsWork:
        return const [
          PlanBRoute(
            title: 'Find an entry-level role',
            description:
                'Check requirements and apply only through verified channels.',
            track: 'work',
          ),
          PlanBRoute(
            title: 'Compare learnerships',
            description:
                'Ask about training, stipends, costs and accreditation before accepting.',
            track: 'work',
          ),
        ];
    }
  }
}