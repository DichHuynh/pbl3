import 'package:flutter/material.dart';
import 'package:pbl3/source/admin/views/navigation_bar.dart';

class AdminMainScreen extends StatelessWidget {
  final String? userData;

  const AdminMainScreen({Key? key, this.userData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(userData);
    return Scaffold(
      backgroundColor: Colors.white, // Đặt nền của toàn bộ trang là màu trắng
      body:
          BottomNavigationBarAdmin(userId: userData), // Hiển thị nội dung của thanh điều hướng dưới đây
    );
  }
}