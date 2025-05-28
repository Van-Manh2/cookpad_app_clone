import 'package:flutter/material.dart';

class SearchInputField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSubmitted;

  const SearchInputField({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          controller: controller,
          onSubmitted: onSubmitted,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(color: Colors.white, fontSize: 15),
          cursorColor: Colors.white,
          cursorWidth: 1,
          cursorHeight: 20,
          decoration: InputDecoration(
            hintText: 'Gõ vào tên các nguyên liệu...',
            hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            prefixIcon: Icon(Icons.search, size: 20, color: Colors.white),
            isCollapsed: true,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
