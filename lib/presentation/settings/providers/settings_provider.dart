import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/settings_service.dart';

class SettingsState {
  final int dailyFundAmount;
  final String themeMode;
  final String currencySymbol;

  const SettingsState({
    required this.dailyFundAmount,
    required this.themeMode,
    required this.currencySymbol,
  });

  SettingsState copyWith({
    int? dailyFundAmount,
    String? themeMode,
    String? currencySymbol,
  }) {
    return SettingsState(
      dailyFundAmount: dailyFundAmount ?? this.dailyFundAmount,
      themeMode: themeMode ?? this.themeMode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
    );
  }
}

final settingsServiceProvider = Provider<SettingsService>((ref) {
  throw UnimplementedError('settingsServiceProvider must be overridden');
});

final settingsNotifierProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    final service = ref.read(settingsServiceProvider);
    return SettingsState(
      dailyFundAmount: service.dailyFundAmount,
      themeMode: service.themeMode,
      currencySymbol: service.currencySymbol,
    );
  }

  Future<void> setDailyFundAmount(int value) async {
    await ref.read(settingsServiceProvider).setDailyFundAmount(value);
    state = state.copyWith(dailyFundAmount: value);
  }

  Future<void> setThemeMode(String value) async {
    await ref.read(settingsServiceProvider).setThemeMode(value);
    state = state.copyWith(themeMode: value);
  }

  Future<void> setCurrencySymbol(String value) async {
    await ref.read(settingsServiceProvider).setCurrencySymbol(value);
    state = state.copyWith(currencySymbol: value);
  }
}
