import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/recipe_service.dart';
import '../models/recipe_model.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final AuthService _authService = AuthService();
  final RecipeService _recipeService = RecipeService();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  String _searchQuery = '';
  int _selectedDietType = -1; // -1 represents "All" or default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            const Icon(Icons.account_circle, color: Colors.orange, size: 32),
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authService.logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search recipes...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: _selectedDietType,
                  decoration: InputDecoration(
                    labelText: 'Diet Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: -1,
                      child: Text('All'),
                    ),
                    const DropdownMenuItem(
                      value: 0,
                      child: Text('Regular'),
                    ),
                    const DropdownMenuItem(
                      value: 1,
                      child: Text('Vegetarian'),
                    ),
                    const DropdownMenuItem(
                      value: 2,
                      child: Text('Vegan'),
                    ),
                    const DropdownMenuItem(
                      value: 3,
                      child: Text('Gluten-Free'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedDietType = value ?? -1;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _searchQuery.isEmpty
                ? StreamBuilder<List<RecipeModel>>(
                    stream: _recipeService.getPublicRecipes(),
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
                      final filteredRecipes = _selectedDietType == -1
                          ? recipes
                          : recipes
                              .where(
                                  (recipe) => recipe.diet == _selectedDietType)
                              .toList();

                      if (filteredRecipes.isEmpty) {
                        return Center(
                          child: Text(
                            _selectedDietType == -1
                                ? 'No published recipes available.'
                                : 'No ${_getDietType(_selectedDietType)} recipes available.',
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = filteredRecipes[index];
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
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(Icons.restaurant,
                                              size: 40);
                                        },
                                      ),
                                    )
                                  : const Icon(Icons.restaurant, size: 40),
                              title: Text(recipe.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipe.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Diet: ${_getDietType(recipe.diet)}',
                                    style: TextStyle(
                                      color: Colors.orangeAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                _showRecipeDetails(recipe);
                              },
                            ),
                          );
                        },
                      );
                    },
                  )
                : StreamBuilder<List<RecipeModel>>(
                    stream: _recipeService.searchRecipes(_searchQuery),
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
                      final filteredRecipes = _selectedDietType == -1
                          ? recipes
                          : recipes
                              .where(
                                  (recipe) => recipe.diet == _selectedDietType)
                              .toList();

                      if (filteredRecipes.isEmpty) {
                        return Center(
                          child: Text(
                            _selectedDietType == -1
                                ? 'No recipes found.'
                                : 'No ${_getDietType(_selectedDietType)} recipes found.',
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = filteredRecipes[index];
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
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(Icons.restaurant,
                                              size: 40);
                                        },
                                      ),
                                    )
                                  : const Icon(Icons.restaurant, size: 40),
                              title: Text(recipe.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipe.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Diet: ${_getDietType(recipe.diet)}',
                                    style: TextStyle(
                                      color: Colors.orangeAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                _showRecipeDetails(recipe);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showRecipeDetails(RecipeModel recipe) {
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
                    Text(
                      recipe.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Diet Type: ${_getDietType(recipe.diet)}',
                      style: Theme.of(context).textTheme.titleMedium,
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
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () async {
                              if (_commentController.text.isNotEmpty) {
                                try {
                                  await _recipeService.addComment(
                                    recipe.id!,
                                    Comment(
                                      userId: _authService.currentUser!.uid,
                                      userEmail:
                                          _authService.currentUser!.email!,
                                      content: _commentController.text,
                                      timestamp: Timestamp.now(),
                                    ),
                                  );
                                  _commentController.clear();
                                  // Show success message
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Comment added successfully'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Error adding comment: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
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
    _searchController.dispose();
    _commentController.dispose();
    super.dispose();
  }
}
