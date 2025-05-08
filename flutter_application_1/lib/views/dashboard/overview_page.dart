import 'package:flutter/material.dart';

class OverviewPage extends StatelessWidget {
  final VoidCallback onNavigateToTransactions;
  final VoidCallback onNavigateToAddTransaction;
  final VoidCallback onNavigateToSettings;
  final VoidCallback onNavigateToCategories; // Ajouté
  final VoidCallback onLogout;

  const OverviewPage({
    super.key,
    required this.onNavigateToTransactions,
    required this.onNavigateToAddTransaction,
    required this.onNavigateToSettings,
    required this.onNavigateToCategories, // Ajouté
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
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
              child: const Text('View Transactions'),
            ),
            ElevatedButton(
              onPressed: onNavigateToAddTransaction,
              child: const Text('Add Transaction'),
            ),
            ElevatedButton(
              onPressed: onNavigateToSettings,
              child: const Text('Settings'),
            ),
            ElevatedButton(
              onPressed: onNavigateToCategories, // Ajouté
              child: const Text('Manage Categories'),
            ),
            

          ],
        ),
      ),
    );
  }
}