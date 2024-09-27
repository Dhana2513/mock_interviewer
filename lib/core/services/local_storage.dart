import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageKey {
  static const userName = 'user_name';
}

class LocalStorage {
  static LocalStorage instance = LocalStorage._();
  SharedPreferences? _pref;

  LocalStorage._() {
    init();
  }

  String get userName =>
      _pref?.getString(LocalStorageKey.userName) ?? 'default';

  Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }

  Future<bool> setUserName({required String userName}) async {
    if (_pref == null) {
      await init();
    }

    return await _pref?.setString(LocalStorageKey.userName, userName) ?? false;
  }

  Future<String?> getUserName() async {
    if (_pref == null) {
      await init();
    }

    return _pref?.getString(LocalStorageKey.userName);
  }
}
