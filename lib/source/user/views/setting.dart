import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pbl3/source/login.dart'; // Import màn hình đăng nhập

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Hàm mở dialog thay đổi mật khẩu
  void _showChangePasswordDialog() {
    final TextEditingController _oldPasswordController =
        TextEditingController();
    final TextEditingController _newPasswordController =
        TextEditingController();
    final TextEditingController _confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thay đổi mật khẩu'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Mật khẩu cũ'),
              ),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Mật khẩu mới'),
              ),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Xác nhận mật khẩu mới'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                final oldPassword = _oldPasswordController.text;
                final newPassword = _newPasswordController.text;
                final confirmPassword = _confirmPasswordController.text;

                // Kiểm tra mật khẩu mới và xác nhận mật khẩu mới
                if (newPassword == confirmPassword) {
                  try {
                    User? user = FirebaseAuth.instance.currentUser;

                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Vui lòng đăng nhập trước khi thay đổi mật khẩu')),
                      );
                      return; // Dừng lại nếu người dùng chưa đăng nhập
                    }

                    // Xác thực lại người dùng với mật khẩu cũ
                    AuthCredential credential = EmailAuthProvider.credential(
                        email: user.email!, password: oldPassword);

                    // Reauthenticate người dùng
                    await user.reauthenticateWithCredential(credential);

                    // Cập nhật mật khẩu mới
                    await user.updatePassword(newPassword);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đổi mật khẩu thành công')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã xảy ra lỗi: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mật khẩu mới không khớp')),
                  );
                }

                Navigator.of(context).pop();
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  // Hàm để đăng xuất
  void _logout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xác nhận đăng xuất'),
          content: Text('Bạn chắc chắn muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                // Đăng xuất khỏi Firebase
                FirebaseAuth.instance.signOut();
                // Chuyển hướng về màn hình đăng nhập
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
        centerTitle: true, // Sử dụng true để căn giữa tiêu đề
        backgroundColor: const Color.fromARGB(255, 151, 191, 224),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Cài đặt chỉnh sửa tài khoản
            ListTile(
              title: Text('Đổi mật khẩu'),
              leading: Icon(Icons.account_circle),
              onTap: _showChangePasswordDialog, // Mở dialog thay đổi mật khẩu
            ),
            // Cài đặt đăng xuất
            ListTile(
              title: Text('Đăng xuất'),
              leading: Icon(Icons.exit_to_app),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
