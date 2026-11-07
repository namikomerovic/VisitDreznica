import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import 'screens/auth/login_screen.dart';
import 'screens/shell/main_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('bs');

  const apiUrl = String.fromEnvironment('API_URL', defaultValue: 'http://10.0.2.2:5291');
  final api = ApiClient(baseUrl: apiUrl);

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: api),
        ChangeNotifierProvider(create: (_) => AuthProvider(api, requiredRole: AppRoles.guest)),
        ChangeNotifierProvider(create: (_) => NotificationProvider(api)),
      ],
      child: const VisitDreznicaApp(),
    ),
  );
}

class VisitDreznicaApp extends StatelessWidget {
  const VisitDreznicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.select<AuthProvider, bool>((auth) => auth.isLoggedIn);

    return MaterialApp(
      key: ValueKey(isLoggedIn),
      title: 'Visit Drežnica',
      debugShowCheckedModeBanner: false,
      locale: const Locale('bs'),
      supportedLocales: const [Locale('bs')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(colorSchemeSeed: const Color(0xFF0F766E), useMaterial3: true),
      home: isLoggedIn ? const MainShell() : const LoginScreen(),
    );
  }
}