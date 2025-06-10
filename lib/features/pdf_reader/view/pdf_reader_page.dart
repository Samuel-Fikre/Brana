import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PdfReaderPage extends StatelessWidget {
  const PdfReaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await Supabase.instance.client.auth.signOut();
                Navigator.of(context).pushReplacementNamed('/login');
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error signing out: $e')),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          user != null ? 'Hello, ${user.email ?? 'User'}!' : 'No user found.',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
