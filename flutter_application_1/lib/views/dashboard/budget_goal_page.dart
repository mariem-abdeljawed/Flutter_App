import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/dashboard/create_budget_goal_page.dart';
import 'package:provider/provider.dart';
import '../../models/budget_goal.dart';
import '../../providers/BudgetProvider.dart';

class BudgetGoalPage extends StatelessWidget {
  const BudgetGoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budget Goals')),
      body: Consumer<BudgetProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.goals.length,
            itemBuilder: (context, index) {
              final goal = provider.goals[index];
              return ListTile(
                title: Text(goal.category),
                subtitle: Text('Goal: ${goal.amount} DT'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateBudgetGoalPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}