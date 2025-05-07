import 'package:flutter/material.dart';

class OverviewPage extends StatelessWidget {
  final VoidCallback onNavigateToTransactions;
  final VoidCallback onNavigateToAddTransaction;
  final VoidCallback onNavigateToSettings;
  final VoidCallback onLogout;

  const OverviewPage({
    super.key,
    required this.onNavigateToTransactions,
    required this.onNavigateToAddTransaction,
    required this.onNavigateToSettings,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vue d\'ensemble'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: onLogout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onNavigateToTransactions,
              child: const Text('Voir les Transactions'),
            ),
            ElevatedButton(
              onPressed: onNavigateToAddTransaction,
              child: const Text('Ajouter une Transaction'),
            ),
            ElevatedButton(
              onPressed: onNavigateToSettings,
              child: const Text('Paramètres'),
            ),
          ],
        ),
      ),
    );
  }
}