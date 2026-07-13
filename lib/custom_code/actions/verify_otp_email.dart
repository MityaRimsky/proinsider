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

Future<bool> verifyOtpEmail(
  String email,
  String otp,
) async {
  final supabase = Supabase.instance.client;
  final normalizedEmail = email.trim().toLowerCase();
  final normalizedOtp = otp.trim();

  if (normalizedEmail.isEmpty || normalizedOtp.length != 6) {
    return false;
  }

  try {
    final response = await supabase.auth.verifyOTP(
      email: normalizedEmail,
      token: normalizedOtp,
      type: OtpType.email,
    );

    return response.session != null;
  } on AuthException catch (e) {
    debugPrint(
      'verifyOtpEmail AuthException: '
      '${e.message}, code: ${e.code}',
    );

    return false;
  } catch (e) {
    debugPrint('verifyOtpEmail unexpected error: $e');
    return false;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
