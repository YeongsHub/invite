import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HostSettingsNotifier extends AsyncNotifier<String> {
  static const _emailKey = 'host_rsvp_email';

  @override
  Future<String> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey) ?? '';
  }

  Future<void> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email.trim());
    state = AsyncData(email.trim());
  }
}

final hostSettingsProvider =
    AsyncNotifierProvider<HostSettingsNotifier, String>(
  HostSettingsNotifier.new,
);
