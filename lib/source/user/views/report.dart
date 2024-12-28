import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../models/issues.dart';
import '../controllers/issues.dart';
import '../views/history.dart'; // Đảm bảo bạn đã tạo màn hình lịch sử báo cáo

class IssueReportScreen extends StatefulWidget {
  final Function
      onReportSuccess; // Callback để điều hướng khi gửi báo cáo thành công

  IssueReportScreen({required this.onReportSuccess});

  @override
  _IssueReportScreenState createState() => _IssueReportScreenState();
}

class _IssueReportScreenState extends State<IssueReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _issueService = IssueService();
  Uint8List? _image;
  String _userId = '';
  bool _isSubmitting = false; // Biến kiểm tra trạng thái gửi báo cáo

  // Lấy userId từ Firebase
  Future<void> _getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  // Chọn hình ảnh từ thư viện
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = await pickedFile.readAsBytes();
      setState(() {});
    }
  }

  // Gửi báo cáo
  void _submitReport() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true; // Bắt đầu quá trình gửi báo cáo
      });

      String imageUrl = '';
      if (_image != null) {
        imageUrl = await _issueService.uploadImageToCloudinary(_image!) ?? '';
      }

      final issue = Issue(
        id: '',
        userId: _userId,
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        createdAt: DateTime.now(),
        status: 'Chưa xử lý',
        imageUrl: imageUrl,
      );

      try {
        await _issueService.createIssue(issue);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã báo cáo sự cố thành công!'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 50.0), // Tùy chỉnh vị trí
            duration: Duration(seconds: 2),
          ),
        );
        widget.onReportSuccess(); // Điều hướng sau khi gửi báo cáo thành công
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể gửi báo cáo: $e')),
        );
      } finally {
        setState(() {
          _isSubmitting = false; // Kết thúc quá trình gửi báo cáo
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Báo Cáo Sự Cố'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 40, 149, 238),
        foregroundColor: Colors.white, // Màu chữ
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mô tả sự cố
                Text(
                  'Mô tả sự cố:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Nhập mô tả chi tiết về sự cố...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mô tả sự cố';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Vị trí sự cố
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Vị trí sự cố',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập vị trí sự cố';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Tải hình ảnh
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.image),
                  label: Text('Chọn hình ảnh'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 167, 168, 171),
                  ),
                ),
                SizedBox(height: 16),
                if (_image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.memory(
                      _image!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(height: 20),

                // Nút gửi báo cáo
                Center(
                  child: ElevatedButton(
                    onPressed: _isSubmitting
                        ? null
                        : _submitReport, // Disable button when submitting
                    child: _isSubmitting
                        ? CircularProgressIndicator(
                            color: Colors
                                .white) // Hiển thị loading khi gửi báo cáo
                        : Text('Gửi Báo Cáo'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 40),
                      backgroundColor: Colors.blue, // Màu nền của nút
                      foregroundColor: Colors.white, // Màu chữ
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5, // Độ cao của nút, làm cho nó nổi lên
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
