import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_localizations.dart';

/// Trenutni prijevodi. Koristi se svugdje: u widgetima, modelima, validaciji i porukama grešaka.
L10n get tr => LocaleController.strings;

class LocaleController extends ChangeNotifier {
  static const _key = 'language';
  static const supported = [Locale('bs'), Locale('en')];

  static Locale _current = const Locale('bs');
  static L10n _strings = lookupL10n(_current);

  static L10n get strings => _strings;

  /// Kod jezika koji se šalje API-ju (Accept-Language) i koristi za formate.
  static String get languageCode => _current.languageCode;

  Locale get locale => _current;

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_key);
      _apply(supported.firstWhere((x) => x.languageCode == saved, orElse: () => supported.first));
    } catch (_) {
      _apply(supported.first);
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (locale.languageCode == _current.languageCode) return;

    _apply(locale);
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, locale.languageCode);
    } catch (_) {
      // Ako se izbor ne sačuva, jezik i dalje vrijedi do zatvaranja aplikacije.
    }
  }

  static void _apply(Locale locale) {
    _current = locale;
    _strings = lookupL10n(locale);
    Intl.defaultLocale = locale.languageCode;
  }
}
