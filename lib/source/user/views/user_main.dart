import 'package:flutter/material.dart';
import 'package:pbl3/source/user/views/navigation_bar.dart';

class UserMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Đặt nền của toàn bộ trang là màu trắng
      body:
          BottomNavigationBarUser(), // Hiển thị nội dung của thanh điều hướng dưới đây
    );
  }
}
