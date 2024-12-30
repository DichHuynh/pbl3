import 'package:flutter/material.dart';
import 'package:pbl3/source/admin/views/evaluated_com.dart';
import 'package:pbl3/source/admin/views/evaluated_over.dart';

class Evaluated extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Đánh giá công việc'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 40, 149, 238),
          foregroundColor: Colors.white,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Sự cố đã hoàn thành'),
              Tab(text: 'Sự cố quá hạn'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CompletedTask(), // Replace with actual widget
            OverdueTask(), // Replace with actual widget
          ],
        ),
      ),
    );
  }
}
