import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
         leading: const Padding(
          padding: EdgeInsets.all(8),
          child: AppLogo(size: 40),
        ),
        title: const Text('Visit Drežnica – Administracija'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(child: Text(auth.session?.fullName ?? '')),
          ),
          IconButton(
            tooltip: 'Odjava',
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Text('Dobrodošli, ${auth.session?.firstName ?? ''}!',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}