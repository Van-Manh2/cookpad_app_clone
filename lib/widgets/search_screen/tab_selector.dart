import 'package:flutter/material.dart';

class TabSelector extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final Function(int) onTabChanged;

  const TabSelector({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length, (index) {
        final isSelected = index == selectedIndex;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTabChanged(index),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border(
                  bottom:
                      isSelected
                          ? BorderSide(color: Colors.orange, width: 2)
                          : BorderSide.none,
                ),
              ),
              child: Center(
                child: Text(
                  labels[index],
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
