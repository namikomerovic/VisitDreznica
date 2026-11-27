import 'package:flutter/widgets.dart';

/// Za ekrane koji tekst grade pri učitavanju (ili ga dobijaju sa servera):
/// kad korisnik promijeni jezik, podaci se ponovo učitaju na novom jeziku.
mixin ReloadOnLocaleChange<T extends StatefulWidget> on State<T> {
  Locale? _locale;

  void onLocaleChanged();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    if (_locale != null && _locale != locale) onLocaleChanged();
    _locale = locale;
  }
}
