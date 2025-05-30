import 'package:cookpad_app_clone/models/recipe.dart';
import 'package:cookpad_app_clone/services/recipe_service.dart';
import 'package:cookpad_app_clone/utils/app_routes.dart';
import 'package:cookpad_app_clone/widgets/search_screen/build_tab_selector.dart';
import 'package:cookpad_app_clone/widgets/search_screen/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListSearchScreen extends StatefulWidget {
  const ListSearchScreen({super.key});

  @override
  State<ListSearchScreen> createState() => _ListSearchScreenState();
}

class _ListSearchScreenState extends State<ListSearchScreen> {
  late TextEditingController _controller;
  String searchQuery = '';
  int selectedIndex = 0;
  late Future<List<Recipe>> _loadData;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is String) {
      searchQuery = extra.trim().toLowerCase();
      _controller.text = searchQuery;
      _loadData = fetchRecipesByQuery();
    }
  }

  Future<List<Recipe>> fetchRecipesByQuery() {
    if (searchQuery.isEmpty) return Future.value([]);
    if (selectedIndex == 0) {
      return RecipeService().getNewestRecipesByKeyword(searchQuery, 10);
    } else {
      return RecipeService().getPopularRecipesByKeyword(searchQuery, 10);
    }
  }

  void onTabChanged(int index) {
    setState(() {
      selectedIndex = index;
      _loadData = fetchRecipesByQuery();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          context.go(AppRoutes.home);
                        },
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 350,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black,
                          border: Border.all(color: Colors.white, width: 0.5),
                        ),
                        child: Center(
                          child: TextField(
                            onTap: () {
                              context.go('${AppRoutes.home}/search');
                            },
                            controller: _controller,
                            autofocus: true,
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value.trim().toLowerCase();
                                _loadData = fetchRecipesByQuery();
                              });
                            },
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            cursorColor: Colors.white,
                            cursorWidth: 1,
                            cursorHeight: 20,
                            decoration: const InputDecoration(
                              hintText: 'Gõ vào tên các nguyên liệu...',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                              prefixIcon: Icon(Icons.search, size: 20),
                              prefixIconColor: Colors.white,
                              isCollapsed: true,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.tune,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              BuildTabSelector(
                selectedIndex: selectedIndex,
                onTabChanged: onTabChanged,
              ),

              const SizedBox(height: 20),

              Expanded(
                child: FutureBuilder<List<Recipe>>(
                  future: _loadData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Lỗi tải dữ liệu: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'Không có dữ liệu nào',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    final recipeList = snapshot.data!;
                    return ListView.builder(
                      itemCount: recipeList.length,
                      itemBuilder: (context, index) {
                        final recipe = recipeList[index];
                        return RecipeCard(recipe: recipe);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
