import 'package:flutter/material.dart';
import 'package:pbl3/source/login.dart';

class PersonalAccountPage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const PersonalAccountPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tài khoản cá nhân",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.blue,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        userData['avatar']), // Thay bằng đường dẫn ảnh của bạn
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userData['name'] ?? "Nguyễn Văn A", // Hiển thị tên từ Firestore
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    userData['email'] ?? "nguyenvana@example.com", // Hiển thị email
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            // Content section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Divider(height: 20, thickness: 1),
                  // Options
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, color: Colors.white),
                    ),
                    title: const Text(
                      "Chỉnh sửa thông tin",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      // Xử lý logic chỉnh sửa thông tin
                    },
                  ),
                  const Divider(height: 20, thickness: 1),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock, color: Colors.white),
                    ),
                    title: const Text(
                      "Đổi mật khẩu",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      // Xử lý logic đổi mật khẩu
                    },
                  ),
                  const Divider(height: 20, thickness: 1),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.logout, color: Colors.white),
                    ),
                    title: const Text(
                      "Đăng xuất",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (contex) => LoginPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
