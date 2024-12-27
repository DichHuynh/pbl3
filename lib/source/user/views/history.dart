// lib/views/screens/issue_history.dart
import 'package:flutter/material.dart';
import '../controllers/issues.dart';
import '../models/issues.dart';

class IssueHistoryScreen extends StatelessWidget {
  final String userId; // Truyền userId của người dùng hiện tại

  IssueHistoryScreen({required this.userId});

  final IssueService _issueService = IssueService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch Sử Báo Cáo Sự Cố'),
      ),
      body: StreamBuilder<List<Issue>>(
        stream: _issueService.getIssuesByUser(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Lỗi khi tải dữ liệu: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có báo cáo sự cố nào.'));
          }

          final issues = snapshot.data!;

          return ListView.builder(
            itemCount: issues.length,
            itemBuilder: (context, index) {
              final issue = issues[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(issue.description),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Vị trí: ${issue.location}'),
                      Text('Thời gian: ${issue.createdAt.toLocal()}'),
                      Text('Trạng thái: ${issue.status}'),
                    ],
                  ),
                  leading: Icon(Icons.report_problem, color: Colors.red),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
