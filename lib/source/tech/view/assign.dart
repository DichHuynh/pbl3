// lib/views/screens/issue_report.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pbl3/source/user/views/history.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../controller/controller.dart';
import '../model/Issue.dart';
import 'dart:typed_data';


class IssueReportScreen extends StatefulWidget {
  final String techId;
  
  IssueReportScreen({required this.techId});

  @override
  _IssueReportScreenState createState() => _IssueReportScreenState();
}

class _IssueReportScreenState extends State<IssueReportScreen> {
  final IssueService _issueService = IssueService();

  // main widget
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách công việc'),
      ),
      body: StreamBuilder<List<Issue>>(
        stream: _issueService.getIssuesByTech(widget.techId),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Lỗi khi tải dữ liệu: ${snapshot.error}')
            );
          }
          if( !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có công việc nào.'));
          }

          final issues = snapshot.data!;

          return ListView.builder(
            itemCount: issues.length,
            itemBuilder: (context, index){
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
                      if(issue.imageUrl != null && issue.imageUrl!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImagePreviewScreen(imageUrl: issue.imageUrl!),
                                ),
                              );
                            },
                            child: Text(
                              'Hình ảnh',
                              style: TextStyle( 
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),

                    ],
                  ),
                  leading: Icon(Icons.pending_actions_outlined, color: Colors.orange),
                  trailing: IconButton(
                    icon: Icon(Icons.edit_notifications_outlined, color: Colors.green),
                    onPressed: () {
                      _reportDialog(context, issue);
                    }
                  )
                )
              );
            },
          );
        },
      ),
    );
  }
}

void _reportDialog(BuildContext context, Issue issue) async {
  final TextEditingController noteController = TextEditingController();
  final _controller = IssueService();
  Uint8List? selectedImageBytes; // Lưu trữ dữ liệu ảnh

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Cập nhật báo cáo xử lý'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              // Thêm ghi chú
              TextFormField(
                controller: noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú xử lý',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Chọn hình ảnh
              TextField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Hình ảnh đã chọn',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.image),
                ),
                onTap: () async {
                  // Mở trình chọn ảnh
                  selectedImageBytes = await _controller.pickImage();
                  if (selectedImageBytes != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã chọn ảnh thành công!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Không thể chọn ảnh')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          TextButton(
            onPressed: () async {
              if (noteController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng nhập ghi chú'),
                  ),
                );
                return;
              }

              try {
                // Gọi hàm updateIssue với dữ liệu ảnh
                await _controller.updateIssue(
                  issueId: issue.id,
                  notes: noteController.text,
                  imageBytes: selectedImageBytes,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cập nhật thành công')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Cập nhật thất bại: $e')),
                );
              }
            },
            child: const Text('Cập nhật'),
          ),
        ],
      );
    },
  );
}


