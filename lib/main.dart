import 'package:flutter/material.dart';
import 'package:quotify/core/theme/theme.dart';
import 'package:quotify/features/auth/view/Pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme,
      home: const LoginPage(),
    );
  }
}
