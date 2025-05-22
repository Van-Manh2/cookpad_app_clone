import 'package:cookpad_app_clone/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    context.go(AppRoutes.home);
                  },
                  icon: Icon(Icons.chevron_left, color: Colors.white, size: 25),
                ),

                Container(
                  width: 350,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 0.5),
                  ),
                  child: Center(
                    child: TextField(
                      autofocus: true,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      cursorColor: Colors.white,
                      cursorWidth: 1,
                      cursorHeight: 20,
                      decoration: InputDecoration(
                        hintText: 'Gõ vào tên các nguyên liệu...',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                        ),
                        prefixIcon: Icon(Icons.search, size: 20),
                        prefixIconColor: Colors.white,
                        isCollapsed: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.tune, color: Colors.white, size: 25),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                       
                    },
                    child: SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          'Mới nhất',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          'Phổ biến',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
