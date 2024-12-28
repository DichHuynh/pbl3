// lib/views/screens/issue_report.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../controller/controller.dart';
import '../model/issue.dart';

class IssueReportScreen extends StatefulWidget {
  @override
  _IssueReportScreenState createState() => _IssueReportScreenState();
}

class _IssueReportScreenState extends State<IssueReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  File? _image;
  final IssueService _issueService = IssueService();

  
  void _submitReport() async {
    if(_formKey.currentState!.validate()) {
      final issue = Issue(
        id: '',
        userId: '',
        description: _noteController.text.trim(),
        location: '',
        createdAt: DateTime.now(),
        status: 'pending',
        techId: '12345',
        imageUrl: '',
        techNote: '',
      );

      try {
        await _issueService.createIssue(issue);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Báo cáo thành công!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể gửi báo cáo: $e')),
        );
      }
    }
  }

  // main widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách công việc'),
      ),
      body: DataTable(
        columns:[
          DataColumn(label: Text('STT')),
          DataColumn(label: Text('Sự cố')),
          DataColumn(label: Text('Trạng thái')),
          DataColumn(label: Text('Báo cáo')),
        ],
        rows: [
          DataRow(cells:[
            DataCell(Text('1')),
            DataCell(Text('Sự cố 1')), //fetch from firebase later
            DataCell(Text('Đã xử lý')), //fetch from firebase later
            DataCell(IconButton(
              icon: Icon(Icons.report), // nhảy lên mục báo cáocáo
              onPressed: () {_reportDialog();}
              )
            ),
          ]),
          DataRow(cells:[
            DataCell(Text('2')),
            DataCell(Text('Sự cố 2')),
            DataCell(Text('Chưa xử lý')),
            DataCell(IconButton(
              icon: Icon(Icons.pending), // nhảy lên mục báo cáo
              onPressed: () {_reportDialog();})),
          ]),
          DataRow(cells:[
            DataCell(Text('3')),
            DataCell(Text('Sự cố 3')),
            DataCell(Text('Đang xử lý')),
            DataCell(IconButton(
              icon: Icon(Icons.done), // nhảy lên mục báo cáo
              onPressed: () {_reportDialog();})),
          ])
        ],
      ),
    );
  }

  void _reportDialog(){
    showDialog(
      context: context,
      builder: (context) {
        final _formKey = GlobalKey<FormState>();
        final _noteController = TextEditingController();
        File? _image;


        Future<void> _pickImage() async {
          final picker = ImagePicker();
          final pickedFile = await picker.pickImage(source: ImageSource.gallery);
          if (pickedFile != null) {
            setState(() {
              _image = File(pickedFile.path);
            });
          }
        }
        
        return AlertDialog(
          title: Text('Báo cáo hoàn thành xử lý sự cố'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column (
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () async {
                      await _pickImage();
                      setState(() {}); // rebuild the widget to display the image
                    },
                    child: _image != null
                        ? Image.file(
                          _image!,
                          height: 75,
                          fit: BoxFit.cover,
                        )
                        : Container(
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text('Tải hình ảnh lên')),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        labelText: 'Ghi chú',
                        border:OutlineInputBorder(),
                      ), maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập ghi chú';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              )
            ),
            actions:[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Hủy'),
              ),
              TextButton(
                onPressed: _submitReport,
                child: Text('Cập nhật'),
              ),
            ],
        );
      }
    );
  }
}


