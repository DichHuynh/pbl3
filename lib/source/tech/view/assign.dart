// lib/views/screens/issue_report.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pbl3/source/user/views/history.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../controller/controller.dart';
import '../model/Issue.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'dart:typed_data';


class IssueReportScreen extends StatefulWidget {
  final String techId;
  
  IssueReportScreen({required this.techId});

  @override
  _IssueReportScreenState createState() => _IssueReportScreenState();
}

class _IssueReportScreenState extends State<IssueReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final _image = '';
  final IssueService _issueService = IssueService();
  bool _isSubmitting = false; // Biến kiểm tra trạng thái gửi báo cáo
  


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
                      _reportDialog();
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
                          height: 100,
                          width: 500,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 226, 226, 226),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              Icon(Icons.add_a_photo, color: const Color.fromARGB(255, 57, 57, 57)),
                              Text('Tải hình ảnh lên')
                          ],
                        ),
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

  void _submitReport() async {
    if(_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      String imageUrl = '';
      if(_image != null) {
        imageUrl = await _issueService.uploadImageToCloudinary(_image) ?? '';
      }

      final issue = Issue(
        id: '',
        userId: '',
        description: '',
        location: '',
        createdAt: DateTime.now(),
        status: 'done',
        techId: widget.techId,
        imageUrl: imageUrl,
        techNote: _noteController.text.trim(),
      );

      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vui lòng tải lên hình ảnh.')),
        );
        return;
      }

      if (widget.techId == null || widget.techId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể xác định kỹ thuật viên.')),
        );
        return;
      }


      try {
        await _issueService.updateIssue(issue.id, issue);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Báo cáo thành công!')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể gửi báo cáo: $e')),
        );
      } finally {
        setState((){
          _isSubmitting = false;
        });
      }
    }
  }
}




