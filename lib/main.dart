import 'package:flutter/material.dart';
import 'registration_screen.dart';

// This is the starting point of the app.
void main() {
  runApp(const RegistrationApp());
}

class RegistrationApp extends StatelessWidget {
  const RegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      // The home screen is the registration form.
      home: const RegistrationScreen(),
    );
  }
}
