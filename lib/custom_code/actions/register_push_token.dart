// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future registerPushToken() async {
  try {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      return;
    }

    final token = await FirebaseMessaging.instance.getToken();

    if (token == null || token.isEmpty) {
      return;
    }

    final platform = Platform.isIOS ? 'ios' : 'android';

    await supabase.from('user_push_tokens').upsert(
      {
        'user_id': user.id,
        'fcm_token': token,
        'platform': platform,
      },
      onConflict: 'fcm_token',
    );
  } catch (_) {
    return;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
