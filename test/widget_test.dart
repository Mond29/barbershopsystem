import 'package:flutter_test/flutter_test.dart';

import 'package:barbershop_app/data/sample_data.dart';
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

  testWidgets('dashboard header fits a 320px-wide screen', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BarbershopApp());
    await tester.pumpAndSettle();

    expect(find.text('BARBERSHOP'), findsOneWidget);
    expect(find.text('Our Location'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('contacts fit a 320px-wide screen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BarbershopApp());
    await tester.tap(find.text('Contacts'));
    await tester.pumpAndSettle();

    expect(find.text('Gentleman Concierge'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('services and category chips fit a 320px-wide screen', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const BarbershopApp());
    await tester.tap(find.text('Services').last);
    await tester.pumpAndSettle();

    expect(find.text('Our Services'), findsOneWidget);
    expect(find.text('Haircut'), findsWidgets);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Hairstyle Guide').first);
    await tester.pumpAndSettle();

    expect(find.text('Modern Mullet'), findsOneWidget);
    expect(tester.takeException(), isNull);
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

  testWidgets('booking option cards have consistent sizes', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: BookingScreen(preselectedService: SampleData.services.first),
      ),
    );
    await tester.pumpAndSettle();

    final haircutCard = find.ancestor(
      of: find.text('Haircut'),
      matching: find.byType(AnimatedContainer),
    );
    final shampooCard = find.ancestor(
      of: find.text('Haircut with Shampoo & Blowdry'),
      matching: find.byType(AnimatedContainer),
    );

    expect(
      tester.getSize(haircutCard.first),
      tester.getSize(shampooCard.first),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('barber cards form an even responsive grid', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: BookingScreen(preselectedService: SampleData.services.first),
      ),
    );
    await tester.tap(find.text('Next Step 2/4'));
    await tester.pumpAndSettle();

    final firstCard = find.byKey(const ValueKey('barber-card-0'));
    final secondCard = find.byKey(const ValueKey('barber-card-1'));
    final lastCard = find.byKey(const ValueKey('barber-card-5'));

    expect(tester.getSize(firstCard), tester.getSize(secondCard));
    expect(tester.getSize(firstCard), tester.getSize(lastCard));
    expect(tester.takeException(), isNull);
  });
}
