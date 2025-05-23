import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../services/recipe_service.dart';
import '../services/auth_service.dart';
import '../widgets/recipe_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final RecipeService _recipeService = RecipeService();
  final AuthService _authService = AuthService();
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _detailsScrollController = ScrollController();
  bool _focusComment = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            const Icon(Icons.account_circle, color: Colors.orange, size: 32),
        title: const Text('My Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authService.logout(),
          ),
        ],
      ),
      body: StreamBuilder<List<RecipeModel>>(
        stream:
            _recipeService.getRecipesByAuthor(_authService.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final recipes = snapshot.data ?? [];

          if (recipes.isEmpty) {
            return const Center(
              child: Text('No recipes yet. Add your first recipe!'),
            );
          }

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: recipe.picture.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            recipe.picture,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.restaurant, size: 40);
                            },
                          ),
                        )
                      : const Icon(Icons.restaurant, size: 40),
                  title: Text(recipe.name),
                  subtitle: Text(
                    recipe.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Edit',
                        onPressed: () => _showRecipeForm(recipe: recipe),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Delete',
                        onPressed: () => _showDeleteConfirmation(recipe),
                      ),
                      IconButton(
                        icon: const Icon(Icons.comment),
                        tooltip: 'Comment',
                        onPressed: () {
                          setState(() {
                            _focusComment = true;
                          });
                          _showRecipeDetails(recipe, focusComment: true);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _focusComment = false;
                    });
                    _showRecipeDetails(recipe);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showRecipeForm();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showRecipeForm({RecipeModel? recipe, bool isRequest = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.9,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: RecipeForm(
                  initialRecipe: recipe,
                  isRequest: isRequest,
                  onSubmit: (updatedRecipe) async {
                    try {
                      if (recipe == null) {
                        await _recipeService.createRecipe(updatedRecipe);
                      } else {
                        await _recipeService.updateRecipe(
                            recipe.id!, updatedRecipe);
                      }
                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Recipe saved successfully'),
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showRecipeDetails(RecipeModel recipe, {bool focusComment = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (recipe.picture.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          recipe.picture,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              height: 200,
                              child: Center(
                                child: Icon(Icons.restaurant, size: 80),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            recipe.name,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        if (recipe.status == 'approved')
                          ElevatedButton.icon(
                            onPressed: () {
                              _showRecipeForm(isRequest: true, recipe: recipe);
                            },
                            icon: const Icon(Icons.send),
                            label: const Text('Send Request'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (recipe.authorEmail != null)
                      Text(
                        'Author: ${recipe.authorEmail}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    const SizedBox(height: 8),
                    Text(
                      'Diet: ${_getDietType(recipe.diet)}',
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Cooking Time: ${recipe.time}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      recipe.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Ingredients',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ...recipe.ingredients.map((ingredient) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            const Icon(Icons.fiber_manual_record, size: 12),
                            const SizedBox(width: 8),
                            Expanded(child: Text(ingredient)),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    Text(
                      'Steps',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ...recipe.steps.asMap().entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${entry.key + 1}.',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(entry.value)),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    if (recipe.status == 'approved') ...[
                      Text(
                        'Comments',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      ...recipe.comments.map((comment) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment.userEmail,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(comment.content),
                                const SizedBox(height: 4),
                                Text(
                                  comment.timestamp
                                      .toDate()
                                      .toString()
                                      .split('.')[0],
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              decoration: const InputDecoration(
                                hintText: 'Add a comment...',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 2,
                              autofocus: focusComment,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              if (_commentController.text.isNotEmpty) {
                                _recipeService.addComment(
                                  recipe.id!,
                                  Comment(
                                    userId: _authService.currentUser!.uid,
                                    userEmail: _authService.currentUser!.email!,
                                    content: _commentController.text,
                                    timestamp: Timestamp.now(),
                                  ),
                                );
                                _commentController.clear();
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(RecipeModel recipe) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Recipe'),
          content: Text('Are you sure you want to delete "${recipe.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await _recipeService.deleteRecipe(recipe.id!);
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Recipe deleted successfully'),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getDietType(int diet) {
    switch (diet) {
      case 0:
        return 'Regular';
      case 1:
        return 'Vegetarian';
      case 2:
        return 'Vegan';
      case 3:
        return 'Gluten-Free';
      default:
        return 'Unknown';
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
