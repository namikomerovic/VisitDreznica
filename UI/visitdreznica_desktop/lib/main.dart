import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import 'layout/master_screen.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('bs');

  const apiUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:5291');
  final api = ApiClient(baseUrl: apiUrl);

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: api),
        ChangeNotifierProvider(create: (_) => AuthProvider(api, requiredRole: AppRoles.admin)),
        ChangeNotifierProvider(create: (_) => NotificationProvider(api)),
      ],
      child: const VisitDreznicaAdminApp(),
    ),
  );
}

class VisitDreznicaAdminApp extends StatelessWidget {
  const VisitDreznicaAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.select<AuthProvider, bool>((auth) => auth.isLoggedIn);

    return MaterialApp(
      key: ValueKey(isLoggedIn),
      title: 'Visit Drežnica – Administracija',
      debugShowCheckedModeBanner: false,
      locale: const Locale('bs'),
      supportedLocales: const [Locale('bs')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(colorSchemeSeed: const Color(0xFF0F766E), useMaterial3: true),
      home: isLoggedIn ? const MasterScreen() : const LoginScreen(),
    );
  }
}