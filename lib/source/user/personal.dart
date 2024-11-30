import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pbl3/source/login.dart';

class PersonalAccountPage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const PersonalAccountPage({super.key, required this.userData});

  void _showEditModal(BuildContext context, String userId) {

    final TextEditingController nameController =
        TextEditingController(text: userData['name'] ?? "Nguyễn Văn A");
    final TextEditingController emailController = TextEditingController(
        text: userData['email'] ?? "nguyenvana@example.com");
    final TextEditingController addressController =
        TextEditingController(text: userData['address'] ?? "Địa chỉ của bạn");
    

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Chỉnh sửa thông tin",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: nameController,
                placeholder: "Họ và tên",
                prefix: Icon(CupertinoIcons.person),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: emailController,
                placeholder: "Email",
                prefix: Icon(CupertinoIcons.mail),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 15),
              CupertinoTextField(
                controller: addressController,
                placeholder: 'Nhập địa chỉ',
                prefix: Icon(CupertinoIcons.location,
                    color: CupertinoColors.systemGrey),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text("Hủy"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton.filled(
                    child: const Text("Lưu"),
                    onPressed: () async {
                    try {
                      // Lưu thông tin người dùng lên Firestore
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .update({
                        'name': nameController.text.trim(),
                        'email': emailController.text.trim(),
                        'address': addressController.text.trim(),
                        'updatedAt': Timestamp.now(),
                      });

                      // Hiển thị thông báo thành công
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Cập nhật thông tin thành công!")),
                      );

                      // Đóng modal
                      Navigator.pop(context);
                    } catch (e) {
                      // Hiển thị thông báo lỗi
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Lỗi: ${e.toString()}")),
                      );
                    }
                  },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

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
                    userData['name'] ??
                        "Nguyễn Văn A", // Hiển thị tên từ Firestore
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    userData['email'] ??
                        "nguyenvana@example.com", // Hiển thị email
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    onTap: () => _showEditModal(context, userData['id']),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
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
