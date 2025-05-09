import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import '../../models/category.dart';
import '../../providers/transaction_provider.dart';
import '../../views/category/CreateCategoryPage.dart';
import '../../views/category/EditCategoryPage';


class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final categories = provider.categories;
        print('Categories in CategoryPage: ${categories.map((c) => c.name).toList()}');
        return ScaffoldMessenger(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Catégories'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: categories.isEmpty
                ? const Center(child: Text('Aucune catégorie trouvée'))
                : ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return ListTile(
                        title: Text(category.name),
                        subtitle: Text('Type: ${category.type == 'income' ? 'Revenu' : 'Dépense'}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                            onPressed: () async {
                            final result = await Navigator.push(
                                context,
                                    MaterialPageRoute(
                                  builder: (_) => EditCategoryPage(category: category),
                          ),
                            );
                          if (result == true) {
                                   // Mise à jour automatique via le provider
                        }
                          },

                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                if (kIsWeb && category.id != null && category.id! <= 3) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Les catégories par défaut ne peuvent pas être supprimées sur le web')),
                                  );
                                  return;
                                }
                                try {
                                  await provider.deleteCategory(category.id!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Catégorie supprimée avec succès')),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Erreur lors de la suppression : $e')),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateCategoryPage()),
                );
                if (result == true) {
                  // Categories are already updated via TransactionProvider
                }
              },
              child: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
  }