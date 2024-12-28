import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:pbl3/source/admin/views/tech_account.dart';
import 'package:pbl3/source/admin/views/user_account.dart';

class ManageUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quản lý Tài khoản'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Tài khoản Người dùng'),
              Tab(text: 'Tài khoản Kỹ thuật'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UserAccountsTab(), // Replace with actual widget
            TechnicalAccountsTab(), // Replace with actual widget
          ],
        ),
      ),
    );
  }
}

