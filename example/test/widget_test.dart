import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Basic test', (WidgetTester tester) async {
    // Build a simple widget and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Text('Test'),
      ),
    ));

    // Verify that our widget shows the text
    expect(find.text('Test'), findsOneWidget);
  });
} 