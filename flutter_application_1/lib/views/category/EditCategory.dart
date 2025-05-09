import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/category.dart';
import '../../providers/transaction_provider.dart';

class EditCategoryPage extends StatefulWidget {
  final Category category;

  const EditCategoryPage({super.key, required this.category});

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  late TextEditingController _nameController;
  late bool _isIncome;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _isIncome = widget.category.isIncome == 1;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveCategory() {
    final updatedCategory = Category(
      id: widget.category.id,
      name: _nameController.text,
      isIncome: _isIncome ? 1 : 0,
    );

    Provider.of<TransactionProvider>(context, listen: false)
        .updateCategory(updatedCategory);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier la Catégorie')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom de la catégorie'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Type : '),
                Radio(
                  value: true,
                  groupValue: _isIncome,
                  onChanged: (val) => setState(() => _isIncome = val!),
                ),
                const Text('Revenu'),
                Radio(
                  value: false,
                  groupValue: _isIncome,
                  onChanged: (val) => setState(() => _isIncome = val!),
                ),
                const Text('Dépense'),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveCategory,
              child: const Text('Enregistrer les modifications'),
            ),
          ],
        ),
      ),
    );
  }
}
