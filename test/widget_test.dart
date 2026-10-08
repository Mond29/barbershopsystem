import 'package:flutter_test/flutter_test.dart';

import 'package:barbershop_app/main.dart';

void main() {
  testWidgets('Barbershop app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BarbershopApp());
    await tester.pumpAndSettle();
    expect(find.text('BARBERSHOP'), findsOneWidget);
    expect(find.text('Book Now'), findsWidgets);
  });
}
