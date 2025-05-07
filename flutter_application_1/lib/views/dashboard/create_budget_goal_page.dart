import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/budget_goal.dart';
import '../../providers/BudgetProvider.dart';

class CreateBudgetGoalPage extends StatefulWidget {
  const CreateBudgetGoalPage({super.key});

  @override
  _CreateBudgetGoalPageState createState() => _CreateBudgetGoalPageState();
}

class _CreateBudgetGoalPageState extends State<CreateBudgetGoalPage> {
  final _categoryController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Budget Goal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final goal = BudgetGoal(
                  category: _categoryController.text,
                  amount: double.parse(_amountController.text),
                  month: DateTime.now().month,
                  year: DateTime.now().year,
                );
                Provider.of<BudgetProvider>(context, listen: false)
                    .addGoal(goal);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}