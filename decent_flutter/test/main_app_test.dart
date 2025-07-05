import 'package:flutter_test/flutter_test.dart';
import 'package:decent_flutter/main.dart';
void main() {
  testWidgets('displays Hello World text', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());

    expect(find.text('2!'), findsOneWidget);
  });
}