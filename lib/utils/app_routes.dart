import 'package:cookpad_app_clone/screens/home_screen.dart';
import 'package:cookpad_app_clone/screens/login_screen.dart';
import 'package:cookpad_app_clone/screens/search_screen.dart';
import 'package:cookpad_app_clone/screens/welcome_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => WelcomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/home/search', builder: (context, state) => SearchScreen()),
    // GoRoute(path: '/home/your-recipe', builder: (context, state) => YourRecipeScreen()),
  ]
);
