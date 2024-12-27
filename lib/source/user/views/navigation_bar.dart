import 'package:flutter/material.dart';
import 'package:pbl3/source/user/views/home.dart'; // Đảm bảo đã import HomeScreen
import 'package:pbl3/source/user/views/report.dart'; // Đảm bảo đã import HomeScreen

import 'package:pbl3/source/user/views/setting.dart'; // Đảm bảo đã import HomeScreen
import 'package:pbl3/source/user/views/history.dart'; // Đảm bảo đã import HomeScreen

// import 'package:pbl3/views/users/report.dart'; // Đảm bảo đã import HomeScreen
// import 'package:pbl3/views/users/history.dart'; // Đảm bảo đã import HomeScreen
// import 'package:pbl3/views/users/notification.dart';
// import 'package:pbl3/views/users/settings.dart';
class BottomNavigationBarUser extends StatefulWidget {
  @override
  _BottomNavigationBarUserState createState() =>
      _BottomNavigationBarUserState();
}

class _BottomNavigationBarUserState extends State<BottomNavigationBarUser> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    IssueReportScreen(),
    IssueHistoryScreen(userId: '12345'), // Thay userId thực tế
    SettingsScreen(),
  ];

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
            label: 'Báo cáo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes_outlined),
            label: 'Lịch sử',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }
}
