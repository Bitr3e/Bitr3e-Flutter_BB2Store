import 'package:flutter_test/flutter_test.dart';

import 'package:bb2store_cash_inventory/main.dart';

void main() {
  testWidgets('App displays title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('BB2 Store'), findsOneWidget);
  });
}
