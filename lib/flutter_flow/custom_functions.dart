import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

String formatLiveDateTime(DateTime dateTime) {
  final now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final messageDay = DateTime(dateTime.year, dateTime.month, dateTime.day);

  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final time = '$hour:$minute';

  const months = [
    '',
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря',
  ];

  if (messageDay == today) {
    return 'Сегодня, $time';
  }

  if (messageDay == yesterday) {
    return 'Вчера, $time';
  }

  if (dateTime.year == now.year) {
    return '${dateTime.day} ${months[dateTime.month]}, $time';
  }

  return '${dateTime.day} ${months[dateTime.month]} ${dateTime.year}, $time';
}

String formatNotificationDate(DateTime dateTime) {
  final now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));

  final itemDay = DateTime(
    dateTime.year,
    dateTime.month,
    dateTime.day,
  );

  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');

  if (itemDay == today) {
    return '$hour:$minute';
  }

  if (itemDay == yesterday) {
    return 'Вчера';
  }

  const months = [
    '',
    'янв',
    'фев',
    'мар',
    'апр',
    'май',
    'июн',
    'июл',
    'авг',
    'сен',
    'окт',
    'ноя',
    'дек'
  ];

  if (dateTime.year == now.year) {
    return '${dateTime.day} ${months[dateTime.month]}';
  }

  return '${dateTime.day} ${months[dateTime.month]} ${dateTime.year}';
}

bool isEmailValid(String? email) {
  if (email == null || email.trim().isEmpty) {
    return false;
  }

  final regex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  return regex.hasMatch(email.trim());
}
