import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/transaction.dart';
import '../../models/category.dart';
import '../../providers/transaction_provider.dart';

class AddTransactionPage extends StatefulWidget {
  final VoidCallback? onLogout;

  const AddTransactionPage({super.key, this.onLogout});

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  String? _category;

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final categories = provider.categories;
        print('Categories in AddTransactionPage: ${categories.map((c) => c.name).toList()}');
        if (_category == null && categories.isNotEmpty) {
          _category = categories.first.id.toString();
        }
        return ScaffoldMessenger(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Ajouter une transaction'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                if (widget.onLogout != null)
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: widget.onLogout,
                  ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: categories.isEmpty
                  ? const Center(child: Text('Aucune catégorie disponible'))
                  : SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(labelText: 'Description'),
                              validator: (value) => value == null || value.isEmpty
                                  ? 'Veuillez entrer une description'
                                  : null,
                            ),
                            TextFormField(
                              controller: _amountController,
                              decoration: const InputDecoration(labelText: 'Montant'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer un montant';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Veuillez entrer un montant valide';
                                }
                                return null;
                              },
                            ),
                            DropdownButtonFormField<String>(
                              value: _category,
                              decoration: const InputDecoration(labelText: 'Catégorie'),
                              items: categories.map((category) {
                                return DropdownMenuItem(
                                  value: category.id?.toString(),
                                  child: Text('${category.name} (${category.type})'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _category = value;
                                  });
                                }
                              },
                              validator: (value) => value == null
                                  ? 'Veuillez sélectionner une catégorie'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final amount = double.tryParse(_amountController.text);
                                  if (amount == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Montant invalide')),
                                    );
                                    return;
                                  }
                                  final selectedCategory = categories.firstWhere(
                                    (cat) => cat.id?.toString() == _category,
                                    orElse: () => Category(id: 0, name: 'Inconnue', isIncome: 0),
                                  );
                                  final transaction = Transaction(
                                    id: null,
                                    amount: amount,
                                    category: _category!,
                                    type: selectedCategory.type,
                                    date: DateTime.now().toIso8601String(),
                                    description: _descriptionController.text.isNotEmpty
                                        ? _descriptionController.text
                                        : null,
                                  );
                                  try {
                                    await provider.addTransaction(transaction);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Transaction ajoutée avec succès')),
                                    );
                                    Navigator.pop(context);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Erreur : $e')),
                                    );
                                  }
                                }
                              },
                              child: const Text('Ajouter la transaction'),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}