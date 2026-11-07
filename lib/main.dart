import 'package:flutter/material.dart';
import 'screens/auth_gate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SecureHttpApp());
}

class SecureHttpApp extends StatelessWidget {
  const SecureHttpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keamanan Data & HTTP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}
