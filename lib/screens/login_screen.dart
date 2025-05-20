import 'package:cookpad_app_clone/services/auth_service.dart';
import 'package:cookpad_app_clone/widgets/social_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  final authService = AuthService();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/login_screen/logo_cookpad2.png',
                    height: 70,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Đăng ký hoặc Đăng nhập',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              Column(
                children: [
                  SocialButton(
                    imagePath: 'assets/login_screen/logo_google.png',
                    text: 'Tiếp tục với google',
                    textColor: Colors.white,
                    boxColor: Colors.black,
                    borderColor: Colors.black,
                    onPressed: () async {
                      final userCredential = await authService.signInGoogle();
                      if (userCredential != null) {
                        // ignore: use_build_context_synchronously
                        context.go('/home');
                      } else {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đăng nhập thất bại')),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  SocialButton(
                    imagePath: 'assets/login_screen/logo_apple.png',
                    text: 'Tiếp tục với Apple',
                    textColor: Colors.black,
                    boxColor: Colors.white,
                    borderColor: Color(0xFFEEEEEE),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: const Divider(color: Colors.grey, thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'hoặc',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: const Divider(color: Colors.grey, thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SocialButton(
                    imagePath: 'assets/login_screen/logo_facebook.png',
                    text: 'Tiếp tục với Facebook',
                    textColor: Colors.black,
                    boxColor: Colors.white,
                    borderColor: Color(0xFFEEEEEE),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 20),
                  SocialButton(
                    imagePath: 'assets/login_screen/logo_email.png',
                    text: 'Tiếp tục với email',
                    textColor: Colors.black,
                    boxColor: Colors.white,
                    borderColor: Color(0xFFEEEEEE),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Khi sử dụng Cookpad, bạn đồng ý với Điều Khoản Dịch Vụ & Chính Sách Bảo Mật của chúng tôi',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
