import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/transaction.dart';
import '../../models/category.dart';
import '../../providers/transaction_provider.dart';
import '../../services/BudgetService.dart';

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
  String? _category; // Nullable pour éviter les erreurs si aucune catégorie n'est disponible
  List<Category> _categories = [];
  bool _isLoading = true; // Gestion de l'état de chargement

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      if (kIsWeb) {
        setState(() {
          _categories = [
            Category(id: 1, name: 'Salary', isIncome: 1),
            Category(id: 2, name: 'Food', isIncome: 0),
            Category(id: 3, name: 'Utilities', isIncome: 0),
          ];
          _category = _categories.isNotEmpty ? _categories.first.id.toString() : null;
          _isLoading = false;
        });
        return;
      }
      final budgetService = BudgetService();
      final categories = await budgetService.getCategories();
      if (categories.isEmpty) {
        final db = await budgetService.getDatabase();
        await db.insert('categories', {'name': 'Salary', 'isIncome': 1});
        await db.insert('categories', {'name': 'Food', 'isIncome': 0});
        await db.insert('categories', {'name': 'Utilities', 'isIncome': 0});
        final updatedCategories = await budgetService.getCategories();
        setState(() {
          _categories = updatedCategories;
          _category = _categories.isNotEmpty ? _categories.first.id.toString() : null;
          _isLoading = false;
        });
      } else {
        setState(() {
          _categories = categories;
          _category = _categories.isNotEmpty ? _categories.first.id.toString() : null;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading categories: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load categories: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _categories.isEmpty
                ? const Center(child: Text('No categories available'))
                : SingleChildScrollView( 
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(labelText: 'Description'),
                            validator: (value) =>
                                value == null || value.isEmpty ? 'Veuillez entrer une description' : null,
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
                            items: _categories.map((category) {
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
                            validator: (value) => value == null ? 'Veuillez sélectionner une catégorie' : null,
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
                                final selectedCategory = _categories.firstWhere(
                                  (cat) => cat.id?.toString() == _category,
                                  orElse: () => Category(id: 0, name: '', isIncome: 0),
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
                                  await Provider.of<TransactionProvider>(context, listen: false)
                                      .addTransaction(transaction);
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
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}