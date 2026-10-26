
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'screens/auth_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/onboarding/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const NextStepApp());
}

class NextStepApp extends StatelessWidget {
  const NextStepApp({super.key});

  static const purple = Color(0xFF59329B);
  static const teal = Color(0xFF18A7A5);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NextStep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: purple,
          primary: purple,
          secondary: teal,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: purple,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  static const _welcomeKey = 'seenWelcome';
  bool? _seenWelcome;

  @override
  void initState() {
    super.initState();
    _loadWelcomeFlag();
  }

  Future<void> _loadWelcomeFlag() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _seenWelcome = prefs.getBool(_welcomeKey) ?? false);
  }

  Future<void> _finishWelcome() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_welcomeKey, true);
    if (!mounted) return;
    setState(() => _seenWelcome = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_seenWelcome == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: NextStepApp.purple),
        ),
      );
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: NextStepApp.purple),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'We could not check your login status. '
                  'Please restart the app and try again.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        // Signed in: go straight to the app
        if (snapshot.data != null) {
          return const DashboardScreen();
        }

        // Signed out and has not seen the welcome screens yet
        if (!_seenWelcome!) {
          return WelcomeScreen(onFinished: _finishWelcome);
        }

        // Signed out, welcome already seen
        return const AuthScreen();
      },
    );
  }
}