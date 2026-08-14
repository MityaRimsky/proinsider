// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:firebase_messaging/firebase_messaging.dart';

Future<bool> getOpenedPushData() async {
  try {
    final message = await FirebaseMessaging.instance.getInitialMessage();

    // Приложение открыто НЕ через push.
    if (message == null) {
      FFAppState().pushType = '';
      FFAppState().pushCardId = 0;
      return false;
    }

    final data = message.data;

    final type = data['type']?.toString().toLowerCase() ?? '';

    int cardId = 0;

    if (type == 'gold' || type == 'premium') {
      cardId = int.tryParse(
            data['forecast_card_id']?.toString() ?? '',
          ) ??
          0;
    }

    FFAppState().pushType = type;
    FFAppState().pushCardId = cardId;

    return true;
  } catch (e) {
    FFAppState().pushType = '';
    FFAppState().pushCardId = 0;
    return false;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
