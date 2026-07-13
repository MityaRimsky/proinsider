// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> sendOtpEmail(String email) async {
  final supabase = Supabase.instance.client;
  final normalizedEmail = email.trim().toLowerCase();

  if (normalizedEmail.isEmpty) {
    throw Exception('Введите email');
  }

  try {
    await supabase.auth.signInWithOtp(
      email: normalizedEmail,
      shouldCreateUser: true,
    );
  } on AuthException catch (e) {
    debugPrint('sendOtpEmail AuthException: ${e.message}');
    throw Exception(e.message);
  } catch (e) {
    debugPrint('sendOtpEmail error: $e');
    throw Exception('Не удалось отправить код. Попробуйте ещё раз.');
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
