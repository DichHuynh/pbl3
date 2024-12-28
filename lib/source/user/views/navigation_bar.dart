import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pbl3/source/user/views/home.dart';
import 'package:pbl3/source/user/views/report.dart';
import 'package:pbl3/source/user/views/setting.dart';
import 'package:pbl3/source/user/views/history.dart';

class BottomNavigationBarUser extends StatefulWidget {
  @override
  _BottomNavigationBarUserState createState() =>
      _BottomNavigationBarUserState();
}

class _BottomNavigationBarUserState extends State<BottomNavigationBarUser> {
  int _selectedIndex = 0;
  String _userId = '';
  List<Widget> _pages = [];

  // Lấy userId từ FirebaseAuth
  Future<void> _getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
        _pages = [
          HomeScreen(),
          IssueReportScreen(onReportSuccess: _onReportSuccess),
          IssueHistoryScreen(userId: _userId),
          SettingsScreen(),
        ];
      });
    }
  }

  // Xử lý sự kiện khi chọn tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Điều hướng đến tab lịch sử báo cáo sau khi gửi báo cáo
  void _onReportSuccess() {
    setState(() {
      _selectedIndex = 2; // Chuyển đến tab "Lịch sử"
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _userId.isEmpty
          ? Center(child: CircularProgressIndicator())
          : IndexedStack(
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
