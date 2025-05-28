class UserModel {
  final String uid;
  final String username;
  final String email;
  final String role;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.role = 'user',
  });

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'role': role};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'],
      email: map['email'] ?? '',
      role: map['role'] ?? 'user',
    );
  }
}
