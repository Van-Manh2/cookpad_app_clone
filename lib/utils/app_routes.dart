import 'package:cookpad_app_clone/screens/add_food_form.dart';
import 'package:cookpad_app_clone/screens/home_screen.dart';
import 'package:cookpad_app_clone/screens/login_screen.dart';
// import 'package:cookpad_app_clone/screens/search_screen.dart';
import 'package:cookpad_app_clone/screens/welcome_screen.dart';
import 'package:go_router/go_router.dart';
import '../screens/login_account_screen.dart';
import '../screens/register_screen.dart';
import '../screens/explore_page.dart';
import '../setting/setting_page.dart';
import '../setting/setting_profile.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => WelcomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/login-account', builder: (context, state) => LoginAccountScreen()),
    GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
    GoRoute(path: '/home/explorePage', builder: (context, state) => ExplorePage()),
    GoRoute(path: '/home/explorePage/add-food-form', builder: (context, state) => AddFoodForm()),
    GoRoute(path: '/home/SettingPage', builder: (context, state) => SettingPage()),
    GoRoute(path: '/profile', builder: (context, state) => ProfileSetting()),

    // GoRoute(path: '/home/search', builder: (context, state) => SearchScreen()),

    // GoRoute(path: '/home/your-recipe', builder: (context, state) => YourRecipeScreen()),
  ]
);