// lib/views/screens/issue_report.dart
import 'package:flutter/material.dart';
import '../models/issues.dart';
import '../controllers/issues.dart';

class IssueReportScreen extends StatefulWidget {
  @override
  _IssueReportScreenState createState() => _IssueReportScreenState();
}

class _IssueReportScreenState extends State<IssueReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final IssueService _issueService = IssueService();

  void _submitReport() async {
    if (_formKey.currentState!.validate()) {
      final issue = Issue(
        id: '', // Firebase sẽ tự tạo ID
        userId: '12345', // Thay bằng ID người dùng hiện tại
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        createdAt: DateTime.now(),
        status: 'pending',
      );

      try {
        await _issueService.createIssue(issue);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Báo cáo sự cố thành công!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể gửi báo cáo: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Báo Cáo Sự Cố'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Mô tả sự cố'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mô tả sự cố';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Vị trí sự cố'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập vị trí sự cố';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitReport,
                child: Text('Gửi Báo Cáo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
