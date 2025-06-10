import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:quotify/core/theme/theme.dart';
import 'package:quotify/features/auth/view/Pages/login_page.dart';
=======
import 'package:brana/core/theme/theme.dart';
import 'package:brana/features/auth/view/Pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:brana/features/pdf_reader/view/pdf_reader_page.dart';
>>>>>>> supabase

void main() async {
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.darkTheme,
      home: const LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/pdfreader': (context) => PdfReaderPage(),
      },
    );
  }
}
