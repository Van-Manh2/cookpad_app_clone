import 'package:cookpad_app_clone/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == 0) {
      context.go(AppRoutes.home);
    } else if (index == 1) {
      context.go('/home/your-recipe');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onTap(context, index),
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
        BottomNavigationBarItem(
          icon: Icon(Icons.book_outlined),
          label: 'Kho món ngon của bạn',
        ),
      ],
    );
  }
}
