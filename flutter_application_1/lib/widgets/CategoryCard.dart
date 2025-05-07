import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final String type;

  const CategoryCard({
    super.key,
    required this.name,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text(type),
      ),
    );
  }
}