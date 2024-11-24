import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pbl3/source/user/issue.dart';

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key});

  @override
  _ReportIssuePageState createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _resolutionDateController = TextEditingController();
  final _reportDateController = TextEditingController();
  Uint8List? _image;

  @override
  void dispose(){
    _descController.dispose();
    _locationController.dispose();
    _resolutionDateController.dispose();
    _reportDateController.dispose();
    super.dispose();
  }

  Future<String?> _uploadImage(Uint8List imageBytes) async {
    final cloudinaryUrl =
        Uri.parse("https://api.cloudinary.com/v1_1/dy3gsgb0j/image/upload");
    final request = http.MultipartRequest("POST", cloudinaryUrl);
    request.fields['upload_preset'] = 'ml_default';

    // Tạo MultipartFile từ Uint8List
    request.files.add(http.MultipartFile.fromBytes('file', imageBytes,
        filename: 'image.jpg'));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);
      return jsonData['secure_url']; // URL của ảnh đã tải lên
    } else {
      if (response.statusCode != 200) {
        final responseData = await response.stream.bytesToString();
        print('Lỗi khi tải ảnh lên Cloudinary: ${response.statusCode}, Chi tiết: $responseData');
        return null;
      }
    }
  }

  // Hàm để chọn ảnh
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Chuyển đổi File sang Uint8List
      _image = await pickedFile.readAsBytes();
      setState(() {});
    }
  }

  void _submitReport() async {
    if (_formKey.currentState!.validate()) {
      String imageUrl = '';
      if (_image != null) {
        imageUrl = await _uploadImage(_image!) ?? '';
      }
      await _firestore.collection('issues').add({
      'description': _descController.text,
      'location': _locationController.text,
      'reportDate': Timestamp.now(),
      'imageUrl': imageUrl,
      'status': 'Chưa xử lý',
    }).then((value) {
      // Xử lý khi báo cáo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Báo cáo của bạn đã được gửi!')),
      );
    });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const IssuePage()),
      );
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 248, 255), // Màu nền tổng thể
      appBar: AppBar(
        title: const Text('Báo cáo sự cố hạ tầng'),
        backgroundColor: const Color.fromARGB(255, 53, 174, 223), // Màu xanh chủ đạo
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10.0),
                  child: const Text(
                    'Báo cáo sự cố hạ tầng',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 53, 174, 223),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(
                    labelText: 'Mô tả sự cố',
                    labelStyle: const TextStyle(color: Color.fromARGB(255, 53, 174, 223)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 53, 174, 223)),
                    ),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mô tả';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Vị trí',
                    labelStyle: const TextStyle(color: Color.fromARGB(255, 53, 174, 223)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 53, 174, 223)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập vị trí';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image, color: Colors.white),
                  label: const Text('Chọn ảnh đính kèm'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255,107,163,190),
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      _image!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _submitReport,
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text('Gửi báo cáo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 198, 214, 55),
                    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}