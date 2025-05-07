import 'package:flutter/material.dart';

class BudgetGoalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Objectifs Budgétaires')),
      body: Center(
        child: Text('Liste des objectifs budgétaires'),
      ),
    );
  }
}
