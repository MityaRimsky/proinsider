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

String formatSubscriptionRemaining(
  String? planName,
  int? remainingForecasts,
  DateTime? expiresAt,
  bool? hasAccess,
) {
  if (hasAccess != true) {
    return 'Выберите тариф';
  }

  final normalizedName = planName?.trim().toLowerCase();

  if (normalizedName == 'premium' || normalizedName == 'gold') {
    final int count = (remainingForecasts ?? 0).clamp(0, 999999).toInt();

    final int mod10 = count % 10;
    final int mod100 = count % 100;

    final bool singular = mod10 == 1 && mod100 != 11;

    String word;

    if (singular) {
      word = 'прогноз';
    } else if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
      word = 'прогноза';
    } else {
      word = 'прогнозов';
    }

    final String verb = singular ? 'Остался' : 'Осталось';

    return '$verb $count $word';
  }

  if (normalizedName == 'live') {
    if (expiresAt == null) {
      return 'Срок действия не указан';
    }

    final DateTime date = expiresAt.toLocal();
    final DateTime now = DateTime.now();

    const months = <String>[
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

    if (date.year == now.year) {
      return 'Действует до ${date.day} ${months[date.month]}';
    }

    return 'Действует до ${date.day} ${months[date.month]} ${date.year}';
  }

  return 'Выберите тариф';
}

String notificationBadgeText(int notificationCount) {
  if (notificationCount > 99) {
    return '99+';
  }

  return notificationCount.toString();
}

String? formatForecastStatus(
  bool? hasAccess,
  int? remainingForecasts,
) {
  if (hasAccess != true) {
    return 'Выберите тариф';
  }

  final int count = (remainingForecasts ?? 0).clamp(0, 999999).toInt();

  final int mod10 = count % 10;
  final int mod100 = count % 100;

  final bool singular = mod10 == 1 && mod100 != 11;

  String word;

  if (singular) {
    word = 'прогноз';
  } else if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
    word = 'прогноза';
  } else {
    word = 'прогнозов';
  }

  final String verb = singular ? 'Остался' : 'Осталось';

  return '$verb $count $word';
}

String? formatSubscriptionStatus(
  bool? hasAccess,
  DateTime? expiresAt,
) {
  if (hasAccess != true) {
    return 'Выберите тариф';
  }

  if (expiresAt == null) {
    return 'Срок действия не указан';
  }

  final DateTime date = expiresAt.toLocal();
  final DateTime now = DateTime.now();

  const months = <String>[
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

  if (date.year == now.year) {
    return 'Действует до ${date.day} ${months[date.month]}';
  }

  return 'Действует до ${date.day} ${months[date.month]} ${date.year}';
}

String getForecastStatus(
  DateTime startTime,
  String resultStatus,
) {
  final now = DateTime.now();
  final localStartTime = startTime.toLocal();

  if (resultStatus != 'pending') {
    return 'Завершён';
  }

  if (!localStartTime.isAfter(now)) {
    return 'Ожидаем результат';
  }

  final isToday = localStartTime.year == now.year &&
      localStartTime.month == now.month &&
      localStartTime.day == now.day;

  return isToday ? 'Сегодня' : 'Скоро';
}

String buildNotificationMessage(
  DateTime? matchTime,
  double? coefficient,
) {
  if (matchTime == null) {
    return '';
  }

  final localTime = matchTime.toLocal();

  final hours = localTime.hour.toString().padLeft(2, '0');
  final minutes = localTime.minute.toString().padLeft(2, '0');

  final coef = (coefficient ?? 0).toStringAsFixed(2);

  return '$hours:$minutes | Общий КФ: $coef';
}
