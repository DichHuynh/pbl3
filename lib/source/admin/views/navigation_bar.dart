import 'package:flutter/material.dart';
import 'package:pbl3/source/admin/views/account.dart';
import 'package:pbl3/source/user/views/home.dart'; // Đảm bảo đã import HomeScreen
import 'package:pbl3/source/admin/views/assign_task.dart'; // Đảm bảo đã import HomeScreen

import 'package:pbl3/source/admin/views/manage_user.dart'; // Đảm bảo đã import HomeScreen
import 'package:pbl3/source/admin/views/evaluated.dart'; // Đảm bảo đã import HomeScreen

// import 'package:pbl3/views/users/report.dart'; // Đảm bảo đã import HomeScreen
// import 'package:pbl3/views/users/history.dart'; // Đảm bảo đã import HomeScreen
// import 'package:pbl3/views/users/notification.dart';
// import 'package:pbl3/views/users/settings.dart';
class BottomNavigationBarAdmin extends StatefulWidget {
  final String? userId;

  BottomNavigationBarAdmin({this.userId});

  @override
  _BottomNavigationBarAdminState createState() =>
      _BottomNavigationBarAdminState();
}
// Add this line to initialize userId
late final Map<String, dynamic> userId;
class _BottomNavigationBarAdminState extends State<BottomNavigationBarAdmin> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(),
      AssignTask(),
      Evaluated(),
      ManageUser(),
      AccountPage(userId: widget.userId), // Truyền userId vào AccountPage
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 5,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_problem_outlined),
            label: 'Phân công',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Đánh giá',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Quản lý người dùng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}
