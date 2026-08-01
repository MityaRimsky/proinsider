import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _favoriteForecast =
          prefs.getStringList('ff_favoriteForecast')?.map(int.parse).toList() ??
              _favoriteForecast;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  List<int> _favoriteForecast = [];
  List<int> get favoriteForecast => _favoriteForecast;
  set favoriteForecast(List<int> value) {
    _favoriteForecast = value;
    prefs.setStringList(
        'ff_favoriteForecast', value.map((x) => x.toString()).toList());
  }

  void addToFavoriteForecast(int value) {
    favoriteForecast.add(value);
    prefs.setStringList('ff_favoriteForecast',
        _favoriteForecast.map((x) => x.toString()).toList());
  }

  void removeFromFavoriteForecast(int value) {
    favoriteForecast.remove(value);
    prefs.setStringList('ff_favoriteForecast',
        _favoriteForecast.map((x) => x.toString()).toList());
  }

  void removeAtIndexFromFavoriteForecast(int index) {
    favoriteForecast.removeAt(index);
    prefs.setStringList('ff_favoriteForecast',
        _favoriteForecast.map((x) => x.toString()).toList());
  }

  void updateFavoriteForecastAtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    favoriteForecast[index] = updateFn(_favoriteForecast[index]);
    prefs.setStringList('ff_favoriteForecast',
        _favoriteForecast.map((x) => x.toString()).toList());
  }

  void insertAtIndexInFavoriteForecast(int index, int value) {
    favoriteForecast.insert(index, value);
    prefs.setStringList('ff_favoriteForecast',
        _favoriteForecast.map((x) => x.toString()).toList());
  }

  String _authEmail = '';
  String get authEmail => _authEmail;
  set authEmail(String value) {
    _authEmail = value;
  }

  bool _isGoogleAuthEnabled = false;
  bool get isGoogleAuthEnabled => _isGoogleAuthEnabled;
  set isGoogleAuthEnabled(bool value) {
    _isGoogleAuthEnabled = value;
  }

  int _pendingPlanId = 0;
  int get pendingPlanId => _pendingPlanId;
  set pendingPlanId(int value) {
    _pendingPlanId = value;
  }

  int _unreadNotificationsCount = 0;
  int get unreadNotificationsCount => _unreadNotificationsCount;
  set unreadNotificationsCount(int value) {
    _unreadNotificationsCount = value;
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
