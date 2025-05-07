import 'package:flutter/material.dart';
import 'CreateCategoryPage.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: const Center(child: Text('List of Categories')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  CreateCategoryPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}