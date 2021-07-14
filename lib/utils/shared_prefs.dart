import 'package:shared_preferences/shared_preferences.dart';

const String _keyIsFirstOpen = 'keyIsFirstOpen';

Future<SharedPreferences> _sharedPreferences = SharedPreferences.getInstance();

void firstOpen(bool value) {
  _sharedPreferences.then(
    (sp) => sp.setBool(
      _keyIsFirstOpen,
      value,
    ),
  );
}

Future<bool> isFirstOpen() async {
  SharedPreferences sp = await _sharedPreferences;
  return sp.getBool(_keyIsFirstOpen) ?? true;
}