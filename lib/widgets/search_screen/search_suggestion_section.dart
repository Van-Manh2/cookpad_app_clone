// widgets/search_screen/search_suggestion_section.dart
import 'package:cookpad_app_clone/models/recipe.dart';
import 'package:flutter/material.dart';

class SearchSuggestionSection extends StatelessWidget {
  final List<Recipe> suggestions;
  final void Function(String) onSelected;

  const SearchSuggestionSection({
    super.key,
    required this.suggestions,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return SizedBox();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final recipe = suggestions[index];
        return ListTile(
          leading: Icon(Icons.search, color: Colors.white),
          title: Text(recipe.name, style: const TextStyle(color: Colors.white)),
          onTap: () => onSelected(recipe.name),
        );
      },
    );
  }
}
