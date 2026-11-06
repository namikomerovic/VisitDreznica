import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  const apiUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:5291');
  final api = ApiClient(baseUrl: apiUrl);

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: api),
        ChangeNotifierProvider(create: (_) => AuthProvider(api, requiredRole: AppRoles.admin)),
      ],
      child: const VisitDreznicaAdminApp(),
    ),
  );
}

class VisitDreznicaAdminApp extends StatelessWidget {
  const VisitDreznicaAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visit Drežnica – Administracija',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF0F766E),
        useMaterial3: true,
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) => auth.isLoggedIn ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }
}