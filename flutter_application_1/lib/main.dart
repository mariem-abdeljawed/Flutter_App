import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/auth_provider.dart';
import 'package:flutter_application_1/providers/dashboard_provider.dart';
import 'package:flutter_application_1/providers/transaction_provider.dart';
import 'package:flutter_application_1/services/database_service.dart';
import 'package:flutter_application_1/views/auth/login_page.dart';
import 'package:flutter_application_1/views/dashboard/overview_page.dart';
import 'package:flutter_application_1/views/transaction/add_transaction_page.dart';
import 'package:flutter_application_1/views/transaction/transactionlistpage.dart';
import 'package:flutter_application_1/views/settings/settings_page.dart';
import 'package:provider/provider.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await DatabaseService.instance.database;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: MaterialApp(
        title: 'Gestion Budgétaire',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/login',
        routes: {
         '/login': (context) => const LoginPage(),

              
          '/overview': (context) => OverviewPage(
                onNavigateToTransactions: () {
                  Navigator.pushNamed(context, '/transactions');
                },
                onNavigateToAddTransaction: () {
                  Navigator.pushNamed(context, '/add-transaction');
                },
                onNavigateToSettings: () {
                  Navigator.pushNamed(context, '/settings');
                },
                onLogout: () {
                  Provider.of<AuthProvider>(context, listen: false).signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
          '/transactions': (context) => TransactionListPage(
                onLogout: () {
                  Provider.of<AuthProvider>(context, listen: false).signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
          '/add-transaction': (context) => AddTransactionPage(
                onLogout: () {
                  Provider.of<AuthProvider>(context, listen: false).signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
          '/settings': (context) => SettingsPage(
                onLogout: () {
                  Provider.of<AuthProvider>(context, listen: false).signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
        },
      ),
    );
  }
}

Future<void> saveData() async {
  if (kIsWeb) {
    print("⚠️ Le stockage local n'est pas supporté sur Web.");
    return;
  }

  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.txt');
    await file.writeAsString('Hello Flutter!');
    print("✅ Données sauvegardées dans ${file.path}");
  } catch (e) {
    print("❌ Erreur lors de la sauvegarde : $e");
  }
}
