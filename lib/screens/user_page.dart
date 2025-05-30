import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/recipe_service.dart';
import '../models/recipe_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/user_model.dart';


class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}


class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {

  final AuthService _authService = AuthService();
  final RecipeService _recipeService = RecipeService();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  String _searchQuery = '';
  int _selectedDietType = -1; // -1 represents "All" or default

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset(
            'assets/icon_cookpad.png',
            width: 20,
            height: 20,
            color: Colors.white,
          ),
        ),
        title: const Text('Home'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Recipes'),
            Tab(text: 'Saved Recipes'),
          ],
        ),
        actions: [
          StreamBuilder<UserModel?>(
            stream: _authService.currentUserModel,
            builder: (context, snapshot) {
              final user = snapshot.data;
              if (user != null && user.role == 'premium') {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child:
                      Icon(Icons.emoji_events, color: Colors.amber, size: 32),
                );
              }
              return const SizedBox.shrink();
            },
          ),

      
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authService.logout(),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All Recipes Tab
          Column(
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

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final recipes = snapshot.data ?? [];
                          final filteredRecipes = _selectedDietType == -1
                              ? recipes
                              : recipes
                                  .where((recipe) =>
                                      recipe.diet == _selectedDietType)
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
                                  leading: recipe.imageUrl.isNotEmpty
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            recipe.imageUrl,
                                          ),
                                        )
                                      : const Icon(Icons.restaurant, size: 40),
                                  title: Text(recipe.name),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final recipes = snapshot.data ?? [];
                          final filteredRecipes = _selectedDietType == -1
                              ? recipes
                              : recipes
                                  .where((recipe) =>
                                      recipe.diet == _selectedDietType)
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
                                  leading: recipe.imageUrl.isNotEmpty
                                      ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            recipe.imageUrl,
                                          ),
                                        )
                                      : const Icon(Icons.restaurant, size: 40),
                                  title: Text(recipe.name),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
          // Saved Recipes Tab
          StreamBuilder<List<RecipeModel>>(
            stream:
                _recipeService.getSavedRecipes(_authService.currentUser!.uid),
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
                  child: Text('No saved recipes yet.'),
                );
              }

              return ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: recipe.imageUrl.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                recipe.imageUrl,
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
        ],
      ),
      floatingActionButton: StreamBuilder<UserModel?>(
        stream: _authService.currentUserModel,
        builder: (context, snapshot) {
          final user = snapshot.data;
          if (user == null || user.role == 'premium' || user.role == 'admin') {
            return const SizedBox.shrink();
          }
          return FloatingActionButton.extended(
            icon: const Icon(Icons.star),
            label: const Text('Go Premium'),
            backgroundColor: Colors.orangeAccent,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Become a Premium User'),
                    content:
                        const Text('Do you want to become a premium user?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            await _authService.updateUserRole(
                                user.uid, 'premium');
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('You are now a premium user!')),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Colors.red),
                              );
                            }
                          }
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
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

                    if (recipe.imageUrl.isNotEmpty)
                      Image.network(
                        recipe.imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
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
                        StreamBuilder<bool>(
                          stream: _recipeService.isRecipeSaved(
                            _authService.currentUser!.uid,
                            recipe.id!,
                          ),
                          builder: (context, snapshot) {
                            final isSaved = snapshot.data ?? false;
                            return IconButton(
                              icon: Icon(
                                isSaved
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: isSaved ? Colors.orange : Colors.grey,
                              ),
                              onPressed: () async {
                                try {
                                  if (isSaved) {
                                    await _recipeService.removeSavedRecipe(
                                      _authService.currentUser!.uid,
                                      recipe.id!,
                                    );
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Recipe removed from saved recipes'),
                                        ),
                                      );
                                    }
                                  } else {
                                    await _recipeService.saveRecipe(
                                      _authService.currentUser!.uid,
                                      recipe.id!,
                                    );
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Recipe saved successfully'),
                                        ),
                                      );
                                    }
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
                            );
                          },
                        ),
                      ],

                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Diet Type: ${_getDietType(recipe.diet)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
 
                    Row(
                      children: [
                        StreamBuilder<String?>(
                          stream: _recipeService.getUserRating(
                            _authService.currentUser!.uid,
                            recipe.id!,
                          ),
                          builder: (context, snapshot) {
                            final userRating = snapshot.data;
                            return Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.thumb_up,
                                    color: userRating == 'like'
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                  onPressed: () async {
                                    try {
                                      if (userRating == 'like') {
                                        await _recipeService.removeRating(
                                          _authService.currentUser!.uid,
                                          recipe.id!,
                                        );
                                      } else {
                                        await _recipeService.likeRecipe(
                                          _authService.currentUser!.uid,
                                          recipe.id!,
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('Error: $e'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                                StreamBuilder<RecipeModel?>(
                                  stream: _recipeService
                                      .getRecipeById(recipe.id!)
                                      .asStream(),
                                  builder: (context, snapshot) {
                                    final recipe = snapshot.data;
                                    return Text(
                                      '${recipe?.likes.length ?? 0}',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 16),
                                IconButton(
                                  icon: Icon(
                                    Icons.thumb_down,
                                    color: userRating == 'dislike'
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  onPressed: () async {
                                    try {
                                      if (userRating == 'dislike') {
                                        await _recipeService.removeRating(
                                          _authService.currentUser!.uid,
                                          recipe.id!,
                                        );
                                      } else {
                                        await _recipeService.dislikeRecipe(
                                          _authService.currentUser!.uid,
                                          recipe.id!,
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('Error: $e'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                                StreamBuilder<RecipeModel?>(
                                  stream: _recipeService
                                      .getRecipeById(recipe.id!)
                                      .asStream(),
                                  builder: (context, snapshot) {
                                    final recipe = snapshot.data;
                                    return Text(
                                      '${recipe?.dislikes.length ?? 0}',
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (recipe.youtubeLink.isNotEmpty)
                      StreamBuilder<UserModel?>(
                        stream: _authService.currentUserModel,
                        builder: (context, snapshot) {
                          final user = snapshot.data;
                          if (user == null) return const SizedBox.shrink();
                          if (user.canWatchVideos) {
                            return TextButton.icon(
                              icon: const Icon(Icons.ondemand_video,
                                  color: Colors.red),
                              label: Text(
                                recipe.youtubeLink,
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              onPressed: () {
                                final url = Uri.parse(recipe.youtubeLink);
                                launchUrl(url,
                                    mode: LaunchMode.platformDefault);
                              },
                            );
                          } else {
                            return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.lock,
                                      color: Colors.orangeAccent),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Upgrade to Premium to watch video',
                                    style:
                                        TextStyle(color: Colors.orangeAccent),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
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

    _tabController.dispose();
    super.dispose();
  }
}
