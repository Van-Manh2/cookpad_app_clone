import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Cài đặt'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          if (user != null)
            Container(
              width: double.infinity,
              color: Colors.grey[900],
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.account_circle, size: 50, color: Colors.orange),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tài khoản đang đăng nhập',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email ?? 'Không rõ',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const Divider(color: Colors.grey),

          // Danh sách cài đặt
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildSettingItem(
                  context,
                  icon: Icons.person,
                  title: 'Tài khoản của tôi',
                  onTap: () => context.push('/profile'),
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.lock,
                  title: 'Bảo mật',
                  onTap: () => context.push('/security'),
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.notifications,
                  title: 'Thông báo',
                  onTap: () => context.push('/notifications'),
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.color_lens,
                  title: 'Giao diện',
                  onTap: () => context.push('/appearance'),
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.help_outline,
                  title: 'Câu hỏi thường gặp',
                  onTap: () => context.push('/faq'),
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.feedback,
                  title: 'Gửi góp ý',
                  onTap: () => context.push('/feedback'),
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.logout,
                  title: 'Đăng xuất',
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text("Xác nhận", style: TextStyle(color: Colors.white)),
      content: const Text("Bạn có chắc chắn muốn đăng xuất?", style: TextStyle(color: Colors.white)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(ctx).pop();
            await FirebaseAuth.instance.signOut();
            context.go('/login'); // <- dùng GoRouter để chuyển về trang login
          },
          child: const Text("Đăng xuất", style: TextStyle(color: Colors.orange)),
        ),
      ],
    ),
  );
}

}
