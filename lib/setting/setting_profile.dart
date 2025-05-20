import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileSetting> {
  final User? user = FirebaseAuth.instance.currentUser;
  String bio = '';
  String? avatarUrl;
  bool isEditingBio = false;
  final TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    if (doc.exists) {
      setState(() {
        bio = doc['bio'] ?? '';
        avatarUrl = doc['avatarUrl'];
      });
    }
  }

  Future<void> updateBio(String newBio) async {
    if (user == null) return;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
      {'bio': newBio},
      SetOptions(merge: true),
    );
    setState(() {
      bio = newBio;
      isEditingBio = false;
    });
  }

  Future<void> deleteBio() async {
    if (user == null) return;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'bio': FieldValue.delete(),
    });
    setState(() {
      bio = '';
    });
  }

  Future<void> pickAndUploadAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (picked != null) {
      final file = File(picked.path);
      final ref = FirebaseStorage.instance.ref().child('avatars/${user!.uid}.jpg');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
        {'avatarUrl': url},
        SetOptions(merge: true),
      );

      setState(() {
        avatarUrl = url;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cập nhật ảnh đại diện thành công.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text('Không có người dùng nào đang đăng nhập.', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Hồ sơ cá nhân', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickAndUploadAvatar,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                    backgroundColor: Colors.grey[800],
                    child: avatarUrl == null
                        ? const Icon(Icons.person, size: 60, color: Colors.orange)
                        : null,
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.edit, color: Colors.orange),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Email & UID
            Card(
              color: Colors.grey[900],
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Email:', style: TextStyle(color: Colors.white70)),
                    Text(user!.email ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const Text('UID:', style: TextStyle(color: Colors.white70)),
                    Text(user!.uid, style: const TextStyle(fontSize: 13, color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Bio
            Card(
              color: Colors.grey[900],
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tiểu sử', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 10),
                    isEditingBio
                        ? Column(
                            children: [
                              TextField(
                                controller: bioController..text = bio,
                                maxLines: 3,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[850],
                                  border: const OutlineInputBorder(),
                                  hintText: 'Nhập tiểu sử của bạn...',
                                  hintStyle: const TextStyle(color: Colors.white54),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => setState(() => isEditingBio = false),
                                    child: const Text('Hủy', style: TextStyle(color: Colors.orange)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => updateBio(bioController.text),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Lưu'),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bio.isNotEmpty ? bio : 'Chưa có tiểu sử.',
                                style: const TextStyle(fontSize: 15, color: Colors.white70),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (bio.isNotEmpty)
                                    TextButton.icon(
                                      onPressed: deleteBio,
                                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                                      label: const Text('Xóa tiểu sử', style: TextStyle(color: Colors.red)),
                                    ),
                                  TextButton.icon(
                                    onPressed: () => setState(() => isEditingBio = true),
                                    icon: const Icon(Icons.edit, color: Colors.orange),
                                    label: const Text('Chỉnh sửa', style: TextStyle(color: Colors.orange)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: const Icon(Icons.logout),
              label: const Text('Đăng xuất'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
