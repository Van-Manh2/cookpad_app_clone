import 'package:cookpad_app_clone/models/recipe.dart';
import 'package:cookpad_app_clone/services/recipe_service.dart';
import 'package:cookpad_app_clone/utils/app_routes.dart';
import 'package:cookpad_app_clone/widgets/home_screen/popular_search.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeService _recipeService = RecipeService();

  late Future<List<Recipe>> _popularRecipes;

  @override
  void initState() {
    super.initState();
    _popularRecipes = _recipeService.getPopularRecipes(
      8,
    ); // lấy 5 món phổ biến nhất
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('icon_cookpad.png'),
                          backgroundColor: Colors.white,
                          radius: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Tìm kiếm',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications_none),
                      color: Colors.white,
                      iconSize: 30,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    context.go('${AppRoutes.home}/search');
                  },
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.black, size: 30),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            'Gõ vào tên các nguyên liệu...',
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tìm kiếm phổ biến',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<Recipe>>(
                  future: _popularRecipes,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Lỗi: ${snapshot.error}',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'Chưa có công thức phổ biến',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else {
                      final recipes = snapshot.data!;
                      return SizedBox(
                        height: 300,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 2,
                              ),
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            final recipe = recipes[index];
                            return GestureDetector(
                              onTap: () {},
                              child: PopularSearch(
                                title: recipe.name,
                                imageUrl: recipe.imageUrl,
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tìm kiếm gần đây',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.go('${AppRoutes.home}/history-search');
                      },
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    onTap: () {
                      context.go('${AppRoutes.home}/search');
                    },
                    leading: Image.asset(
                      'assets/login_screen/logo_apple.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: const Text(
                      'Món Mặn',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Cách đây 5 giây',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Món mới lên sóng gần đây',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.go('${AppRoutes.home}/search');
                      },
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Container(
                //   height: 200,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: FutureBuilder<List<Recipe>>(
                //     future: _recentRecipes,
                //     builder: (context, snapshot) {
                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //         return const Center(child: CircularProgressIndicator());
                //       } else if (snapshot.hasError) {
                //         return const Center(
                //           child: Text(
                //             "Lỗi dữ liệu",
                //             style: TextStyle(color: Colors.white),
                //           ),
                //         );
                //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                //         return const Center(
                //           child: Text(
                //             "Không có món mới",
                //             style: TextStyle(color: Colors.white),
                //           ),
                //         );
                //       }

                //       final recipes = snapshot.data!;
                //       return ListView.builder(
                //         scrollDirection: Axis.horizontal,
                //         itemCount: recipes.length,
                //         itemBuilder: (context, index) {
                //           final recipe = recipes[index];
                //           return PopularSearch(recipe: recipe);
                //         },
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
