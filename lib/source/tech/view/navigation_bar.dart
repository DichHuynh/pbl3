import 'package:flutter/material.dart';
import 'package:pbl3/source/tech/view/tech_main.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String _techId = '';
  List<Widget> _pages = [];

  //Lấy techId từ FirebaseAuth
  Future<void> _getTechId() async {
    User? tech = FirebaseAuth.instance.currentUser;
    if (tech != null) {
      setState(() {
        _techId = tech.uid;
        _pages = [
          TechHomePage(),
          IssueReportScreen(techId: _techId),
          History(techId: _techId),
          techSetting(),
        ];
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _getTechId();
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
        elevation: 4,
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