import 'package:shared_preferences/shared_preferences.dart';

Future<bool> checkWalkthroughSeen() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('walkthrough_seen') ??
      false; // Retorna true se já viu, false caso contrário
}

Future<void> setWalkthroughSeen() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('walkthrough_seen', true);
}
