import 'package:flutter/material.dart';
import 'package:pbl3/source/tech/view/tech_main.dart';
import 'package:pbl3/source/tech/view/home.dart';
import 'package:pbl3/source/tech/view/assign.dart';
import 'package:pbl3/source/tech/view/history.dart';
import 'package:pbl3/source/tech/view/setting.dart';


class BottomNavigationBarTech extends StatefulWidget {
  @override
  _BottomNavigationBarTechState createState() =>
      _BottomNavigationBarTechState();
}

class _BottomNavigationBarTechState extends State<BottomNavigationBarTech> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    TechHomePage(), // home page of tech , nơi hiện thông báo cho tech
    IssueReportScreen(), // nơi hiện danh sách sự cố cần tech xử lý
    History(techId: '12345'), // nơi hiện lịch sử xử lý của tech
    techSetting(), // nơi hiện cài đặt của tech
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
            label: 'Sự cố',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in_outlined),
            label: 'Lịch sử',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }
}