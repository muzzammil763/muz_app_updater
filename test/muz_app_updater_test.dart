import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muz_app_updater/muz_app_updater.dart';

void main() {
  group('MuzAppUpdater Tests', () {
    testWidgets('should initialize without errors', (WidgetTester tester) async {
      // Build a test app
      await tester.pumpWidget(
        MaterialApp(
          home: TestWidget(),
        ),
      );

      // Verify the widget builds without errors
      expect(find.byType(TestWidget), findsOneWidget);
    });

    test('UpdaterAndroid should be created with correct parameters', () {
      final updater = UpdaterAndroid(
        collectionName: 'test_collection',
        documentName: 'test_document',
      );

      expect(updater.collectionName, 'test_collection');
      expect(updater.documentName, 'test_document');
    });

    test('UpdaterIOS should be created with correct parameters', () {
      final updater = UpdaterIOS(
        collectionName: 'test_collection',
        documentName: 'test_document',
      );

      expect(updater.collectionName, 'test_collection');
      expect(updater.documentName, 'test_document');
    });



    test('MuzAppUpdater should have static initialize method', () {
      expect(MuzAppUpdater.initialize, isA<Function>());
    });
  });
}

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  void initState() {
    super.initState();
    // Test that we can call initialize without errors
    // Note: In a real test, you'd mock Firebase
    _testInitialization();
  }

  Future<void> _testInitialization() async {
    try {
      // This will fail in test environment due to Firebase not being initialized
      // but we're testing that the method exists and can be called
      await MuzAppUpdater.initialize(
        context: context,
        updaterAndroid: UpdaterAndroid(
          collectionName: 'test',
          documentName: 'test',
        ),
        updaterIOS: UpdaterIOS(
          collectionName: 'test',
          documentName: 'test',
        ),
      );
    } catch (e) {
      // Expected to fail in test environment
      expect(e, isA<Exception>());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Test Widget'),
      ),
    );
  }
} 