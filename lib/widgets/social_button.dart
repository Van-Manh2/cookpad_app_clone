import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String imagePath;
  final String text;
  final Color textColor;
  final Color boxColor;
  final Color borderColor;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.imagePath,
    required this.text,
    required this.textColor,
    required this.boxColor,
    required this.borderColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: boxColor,
          elevation: 0,
          side: BorderSide(color: borderColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                imagePath,
                height: 30,
                width: 30,
                fit: BoxFit.contain,
              ),
            ),
            Center(
              child: Text(
                text,
                style: TextStyle(color: textColor, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
