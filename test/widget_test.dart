import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello'),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TestApp());

    expect(find.text('Hello'), findsOneWidget);
  });
}
