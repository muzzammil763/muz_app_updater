import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:muz_app_updater/muz_app_updater.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muz App Updater Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Muz App Updater Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isInitialized = false;
  String _status = 'Not initialized';

  @override
  void initState() {
    super.initState();
    _initializeAppUpdater();
  }

  Future<void> _initializeAppUpdater() async {
    try {
      await MuzAppUpdater.initialize(
        context: context,
        updaterAndroid: UpdaterAndroid(
          collectionName: 'app_updates',
          documentName: 'android',
        ),
        updaterIOS: UpdaterIOS(
          collectionName: 'app_updates',
          documentName: 'ios',
        ),
        setupFirestoreCollections: true, // Set to true for first-time setup
      );
      
      setState(() {
        _isInitialized = true;
        _status = 'App updater initialized successfully!';
      });
    } catch (e) {
      setState(() {
        _status = 'Error initializing app updater: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                _isInitialized ? Icons.check_circle : Icons.error,
                size: 80,
                color: _isInitialized ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 20),
              Text(
                _isInitialized ? 'App Updater Ready' : 'Initializing...',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                _status,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text(
                'This example demonstrates how to use the Muz App Updater package:',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Features:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text('• Automatic app update checks'),
                      Text('• Platform-specific configurations'),
                      Text('• Firebase Firestore integration'),
                      Text('• Force update support'),
                      Text('• Custom update URLs'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Check the console for initialization logs and any update dialogs that may appear.',
                style: TextStyle(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 