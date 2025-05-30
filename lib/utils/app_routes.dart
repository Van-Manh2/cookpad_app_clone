import 'package:cookpad_app_clone/models/search.dart';
import 'package:cookpad_app_clone/screens/history_search_screen.dart';
import 'package:cookpad_app_clone/screens/home_screen.dart';
import 'package:cookpad_app_clone/screens/list_search_screen.dart';
import 'package:cookpad_app_clone/screens/login_screen.dart';
import 'package:cookpad_app_clone/screens/search_screen.dart';
import 'package:cookpad_app_clone/screens/welcome_screen.dart';
import 'package:cookpad_app_clone/screens/your_recipe_screen.dart';
import 'package:cookpad_app_clone/services/auth_service.dart';
import 'package:cookpad_app_clone/services/recipe_service.dart';
import 'package:cookpad_app_clone/widgets/bottom_nav_bar_layout.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const welcome = '/';
  static const login = '/login';
  static const home = '/home';
}

final recipeService = RecipeService();
final authService = AuthService();
late Search search;

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.welcome,
  routes: [
    GoRoute(
      path: AppRoutes.welcome,
      builder: (context, state) => WelcomeScreen(),
    ),
    GoRoute(path: AppRoutes.login, builder: (context, state) => LoginScreen()),

    ShellRoute(
      builder:
          (context, state, child) =>
              BottomNavBarLayout(location: state.uri.toString(), child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) {
            final search =
                state.extra as Search? ??
                Search(
                  id: '',
                  userId: '',
                  keyword: '',
                  timestamp: DateTime.now(),
                );
            return HomeScreen(search: search);
          },
          routes: [
            GoRoute(
              path: 'search',
              builder:
                  (context, state) => SearchScreen(
                    recipeService: recipeService,
                    authService: authService,
                  ),
            ),
            GoRoute(
              path: 'list-search',
              builder: (context, state) => ListSearchScreen(),
            ),
            GoRoute(
              path: 'history-search',
              builder: (context, state) => HistorySearchScreen(),
            ),
            GoRoute(
              path: 'your-recipe',
              builder: (context, state) => const YourRecipeScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
