import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _keyDailyFund = 'daily_fund_amount';
  static const _keyThemeMode = 'theme_mode';
  static const _keyCurrencySymbol = 'currency_symbol';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  int get dailyFundAmount {
    if (_prefs == null) return 300;
    return _prefs!.getInt(_keyDailyFund) ?? 300;
  }

  Future<void> setDailyFundAmount(int value) async {
    await _prefs?.setInt(_keyDailyFund, value);
  }

  String get themeMode {
    if (_prefs == null) return 'system';
    return _prefs!.getString(_keyThemeMode) ?? 'system';
  }

  Future<void> setThemeMode(String value) async {
    await _prefs?.setString(_keyThemeMode, value);
  }

  String get currencySymbol {
    if (_prefs == null) return '₱';
    return _prefs!.getString(_keyCurrencySymbol) ?? '₱';
  }

  Future<void> setCurrencySymbol(String value) async {
    await _prefs?.setString(_keyCurrencySymbol, value);
  }
}
