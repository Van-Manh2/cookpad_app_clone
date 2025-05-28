import 'package:cookpad_app_clone/widgets/search_screen/tab_selector.dart';
import 'package:flutter/material.dart';

class BuildTabSelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  const BuildTabSelector({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabSelector(
          labels: ['Mới nhất', 'Phổ biến'],
          selectedIndex: selectedIndex,
          onTabChanged: onTabChanged,
        ),
      ],
    );
  }
}
