import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:pbl3/source/user/userHome.dart';
import 'package:pbl3/source/user/views/user_main.dart';

import 'package:pbl3/source/login%20signup/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();

  Uint8List? _avatar;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
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
        print(
            'Lỗi khi tải ảnh lên Cloudinary: ${response.statusCode}, Chi tiết: $responseData');
        return null;
      }
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Tạo tài khoản người dùng
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        String avatarUrl = '';
        if (_avatar != null) {
          avatarUrl = await _uploadImage(_avatar!) ?? '';
        }

        // Lưu thông tin người dùng vào Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': _nameController.text,
          'email': _emailController.text,
          'address': _addressController.text,
          'avatar': avatarUrl,
          'role': "user",
          'createdAt': Timestamp.now(),
        });

        // Lấy dữ liệu từ Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Chuyển đến trang PersonalAccountPage
        Navigator.push(
          context,
          MaterialPageRoute(
              // builder: (context) => UserHomePage(userData: userData),
              builder: (context) => UserMainScreen()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          _showErrorDialog('The password is too weak.');
        } else if (e.code == 'email-already-in-use') {
          _showErrorDialog('This email is already in use.');
        }
      } catch (e) {
        _showErrorDialog('Error creating account: $e');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 253),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Đăng ký người dùng mới',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                CupertinoTextField(
                  controller: _nameController,
                  placeholder: 'Nhập họ và tên',
                  prefix: Icon(CupertinoIcons.person,
                      color: CupertinoColors.systemGrey),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 15),
                CupertinoTextField(
                  controller: _emailController,
                  placeholder: 'Nhập email',
                  prefix: Icon(CupertinoIcons.mail_solid,
                      color: CupertinoColors.systemGrey),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),
                CupertinoTextField(
                  controller: _passwordController,
                  placeholder: 'Nhập mật khẩu',
                  prefix: Icon(CupertinoIcons.lock,
                      color: CupertinoColors.systemGrey),
                  obscureText: true,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 15),
                CupertinoTextField(
                  controller: _confirmPasswordController,
                  placeholder: 'Nhập lại mật khẩu',
                  prefix: Icon(CupertinoIcons.lock,
                      color: CupertinoColors.systemGrey),
                  obscureText: true,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 15),
                CupertinoTextField(
                  controller: _addressController,
                  placeholder: 'Nhập địa chỉ',
                  prefix: Icon(CupertinoIcons.location,
                      color: CupertinoColors.systemGrey),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 15),
                _buildFilePickerButton('Chọn avatar'),
                const SizedBox(height: 15),
                // CupertinoTextField(
                //   placeholder: "Số điện thoại",
                //   prefix: Icon(CupertinoIcons.phone,
                //       color: CupertinoColors.systemGrey),
                //   suffix: Text("+84",
                //       style: TextStyle(color: CupertinoColors.activeBlue)),
                // ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 15)),
                    child: const Text(
                      'Đăng ký',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text(
                    'Bạn đã có tài khoản? Đăng nhập',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hint,
      {bool isPassword = false, bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập $label';
        }
        if (isEmail && !value.contains('@')) {
          return 'Email không hợp lệ';
        }
        return null;
      },
    );
  }

  Widget _buildFilePickerButton(String label) {
    return OutlinedButton(
      onPressed: () async {
        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          // Sử dụng phần mềm đọc file để lấy dữ liệu bytes
          final byteData = await pickedFile.readAsBytes();
          setState(() {
            _avatar = byteData; // Thay đổi loại dữ liệu cho phù hợp
          });
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(_avatar == null ? 'Không có tệp nào được chọn' : 'Tệp đã chọn'),
        ],
      ),
    );
  }
}
