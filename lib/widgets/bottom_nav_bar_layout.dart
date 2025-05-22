import 'package:cookpad_app_clone/utils/app_routes.dart';
import 'package:cookpad_app_clone/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBarLayout extends StatelessWidget {
  final Widget child;
  final String location;

  const BottomNavBarLayout({
    super.key,
    required this.child,
    required this.location,
  });

  int get currentIndex {
    if (location.startsWith('/home/search')) return 0;
    if (location.startsWith('/home/your-recipe')) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavBar(currentIndex: currentIndex),
    );
  }
}
