// widgets/search_screen/search_history_section.dart
import 'package:flutter/material.dart';

class SearchHistorySection extends StatelessWidget {
  final List<String> history;
  final void Function(String) onTap;
  final VoidCallback onClear;

  const SearchHistorySection({
    super.key,
    required this.history,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tìm kiếm gần đây',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              TextButton(
                onPressed: onClear,
                child: const Text('Xóa', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            children:
                history
                    .map(
                      (keyword) => ActionChip(
                        backgroundColor: Colors.grey[800],
                        label: Text(
                          keyword,
                          style: const TextStyle(color: Colors.white),
                        ),
                        onPressed: () => onTap(keyword),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}
