import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import 'screens/auth/login_screen.dart';
import 'screens/shell/main_shell.dart';
import 'providers/favorites_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  const apiUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5291',
  );
  final api = ApiClient(baseUrl: apiUrl);
  final themeController = ThemeController();
  await themeController.load();
  final localeController = LocaleController();
  await localeController.load();

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: api),
        ChangeNotifierProvider(create: (_) => FavoritesProvider(api)),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(api, requiredRole: AppRoles.guest),
        ),
        ChangeNotifierProvider(create: (_) => NotificationProvider(api)),
        ChangeNotifierProvider<ThemeController>.value(value: themeController),
        ChangeNotifierProvider<LocaleController>.value(value: localeController),
      ],
      child: const VisitDreznicaApp(),
    ),
  );
}

class VisitDreznicaApp extends StatelessWidget {
  const VisitDreznicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.select<AuthProvider, bool>(
      (auth) => auth.isLoggedIn,
    );

    return MaterialApp(
      key: ValueKey(isLoggedIn),
      onGenerateTitle: (_) => tr.appName,
      debugShowCheckedModeBanner: false,
      locale: context.watch<LocaleController>().locale,
      supportedLocales: LocaleController.supported,
      localizationsDelegates: const [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: context.watch<ThemeController>().mode,
      builder: (context, child) => LocaleScope(child: child!),
      home: isLoggedIn ? const MainShell() : const LoginScreen(),
    );
  }
}
