import 'package:cookpad_app_clone/models/recipe.dart';
import 'package:cookpad_app_clone/services/auth_service.dart';
import 'package:cookpad_app_clone/services/recipe_service.dart';
import 'package:cookpad_app_clone/utils/app_routes.dart';
import 'package:cookpad_app_clone/widgets/search_screen/search_history_section.dart';
import 'package:cookpad_app_clone/widgets/search_screen/search_input_field.dart';
import 'package:cookpad_app_clone/widgets/search_screen/search_suggestion_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  final RecipeService recipeService;
  final AuthService authService;

  const SearchScreen({
    super.key,
    required this.recipeService,
    required this.authService,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController controller;
  List<String> history = [];
  List<Recipe> suggestions = [];
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    loadSearchHistory();
    controller.addListener(onSearchTextChanged);
  }

  void onSearchTextChanged() async {
    final query = controller.text.trim();

    if (query.isEmpty) {
      setState(() {
        isTyping = false;
        suggestions = [];
      });
      return;
    }

    final results = await widget.recipeService.searchRecipes(query);
    setState(() {
      isTyping = true;
      suggestions = results;
    });
  }

  Future<void> loadSearchHistory() async {
    final user = await widget.authService.getCurrentUser();
    if (user != null) {
      final data = await widget.recipeService.getSearchHistory(user.uid, 10);
      print("===> History loaded: $data");
      setState(() {
        history = data;
      });
    } else {
      print("No user logged in");
      setState(() {
        history = [];
      });
    }
  }

  Future<void> onSubmitted(String keyword) async {
    await widget.recipeService.saveSearchKeyword(keyword);
    await loadSearchHistory();
    context.go('${AppRoutes.home}/list-search', extra: keyword);
  }

  Future<void> onClearHistory() async {
    await widget.recipeService.clearSearchHistory();
    await loadSearchHistory();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.go(AppRoutes.home),
                    icon: Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  Expanded(
                    child: SearchInputField(
                      controller: controller,
                      onSubmitted: onSubmitted,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.tune, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  isTyping
                      ? SearchSuggestionSection(
                        suggestions: suggestions,
                        onSelected: onSubmitted,
                      )
                      : SingleChildScrollView(
                        padding: const EdgeInsets.all(10),
                        child: SearchHistorySection(
                          history: history,
                          onTap: onSubmitted,
                          onClear: onClearHistory,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
