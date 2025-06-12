import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiClient {
  static Future<http.Response> sendDataToBackend(
      Map<String, dynamic> data) async {
    final jwt = Supabase.instance.client.auth.currentSession?.accessToken;
    if (jwt == null) {
      throw Exception('No JWT found. User is not logged in.');
    }

    // Replace with your actual backend endpoint
    final url = Uri.parse('https://your-backend.com/api/sync');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $jwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    return response;
  }
}
