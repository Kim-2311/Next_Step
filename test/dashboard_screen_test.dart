import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:next_step/screens/dashboard/dashboard_screen.dart';

void main() {
  testWidgets('dashboard content scrolls while bottom navigation stays fixed', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.text('Recently saved'), findsOneWidget);

    final homeLabel = find.text('Home');
    final homePositionBeforeScroll = tester.getTopLeft(homeLabel);
    final scrollableFinder = find.descendant(
      of: find.byType(SingleChildScrollView),
      matching: find.byType(Scrollable),
    );
    final scrollable = tester.state<ScrollableState>(scrollableFinder);

    await tester.dragFrom(
      tester.getRect(find.byType(SingleChildScrollView)).center,
      const Offset(0, -1200),
    );
    await tester.pumpAndSettle();

    expect(scrollable.position.pixels, greaterThan(0));
    expect(tester.getTopLeft(homeLabel), homePositionBeforeScroll);
    expect(
      find.text(
        'Suggestions use your results, interests and location. '
        'Matching is guidance, not a guarantee of eligibility.',
      ),
      findsOneWidget,
    );
  });
}
