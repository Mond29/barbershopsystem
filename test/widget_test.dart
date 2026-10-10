import 'package:flutter_test/flutter_test.dart';

import 'package:barbershop_app/main.dart';
import 'package:barbershop_app/screens/booking_screen.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Barbershop app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BarbershopApp());
    await tester.pumpAndSettle();
    expect(find.text('BARBERSHOP'), findsOneWidget);
    expect(find.text('Book Now'), findsWidgets);
  });

  testWidgets('booking fits a narrow phone and locks the MOA location', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: BookingScreen()));
    await tester.pumpAndSettle();

    expect(find.text('SM Mall of Asia'), findsOneWidget);
    expect(find.text('ONLY LOCATION'), findsOneWidget);
    expect(
      find.text('Automatically selected for this booking'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
