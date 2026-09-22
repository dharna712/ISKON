import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/verse.dart';

/// Small persisted-state layer (language choice, starred/mastered verses),
/// mirroring the old app's localStorage usage.
class AppPrefs {
  AppPrefs._();
  static final AppPrefs instance = AppPrefs._();

  final ValueNotifier<AppLang> lang = ValueNotifier(AppLang.en);
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final saved = _prefs!.getString('lang');
    if (saved == 'hi') lang.value = AppLang.hi;
  }

  Future<void> setLang(AppLang value) async {
    lang.value = value;
    await _prefs?.setString('lang', value == AppLang.hi ? 'hi' : 'en');
  }

  bool isStarred(String verseId) => _prefs?.getBool('starred_$verseId') ?? false;

  Future<void> toggleStarred(String verseId) async {
    await _prefs?.setBool('starred_$verseId', !isStarred(verseId));
  }

  bool isMastered(String verseId) => _prefs?.getBool('mastered_$verseId') ?? false;

  Future<void> markMastered(String verseId) async {
    await _prefs?.setBool('mastered_$verseId', true);
  }
}
