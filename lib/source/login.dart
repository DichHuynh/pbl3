// package cho firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

// package cho flutter và các file khác
import 'package:flutter/material.dart';
import 'package:pbl3/source/admin/views/admin_main.dart';
// import 'package:pbl3/source/user/userHome.dart';
import 'package:pbl3/source/user/views/user_main.dart';

// import 'package:pbl3/source/tech/techHome.dart';
// import 'package:pbl3/source/admin/adminHome.dart';
// =======
import 'package:pbl3/source/tech/view/tech_main.dart';
import 'package:pbl3/source/admin/adminHome.dart';

import 'package:pbl3/source/tech/view/tech_main.dart';
import 'package:pbl3/source/admin/adminHome.dart';

import 'package:pbl3/source/signUp.dart';

// widget chính : trang đăng nhậpnhập
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Hệ thống thông tin cơ sở hạ tầng',
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Đăng nhập không thành công!'),
          content: Text('Email hoặc mật khẩu không đúng.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Truy vấn dữ liệu người dùng từ Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();
        String userRole = userDoc['role'];
        String userId = userCredential.user!.uid; // Vai trò người dùng
        // Map<String, dynamic> userData =
        //     userDoc.data() as Map<String, dynamic>; // Thông tin người dùng

        // Điều hướng dựa trên vai trò
        if (userRole == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminMainScreen(userData: userId)),
          );
        } else if (userRole == 'Tech') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TechMainScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              // builder: (context) => UserHomePage(userData: userData),
              builder: (context) => UserMainScreen(),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = 'Không tìm thấy người dùng với email này.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Mật khẩu không chính xác.';
        } else {
          errorMessage = 'Lỗi: ${e.message}';
        }

        showErrorDialog(errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Logo
                  Image.asset(
                    'assets/anhmau.jpg', // Đảm bảo 'anhmau.jpg' đã được thêm vào thư mục assets và khai báo trong pubspec.yaml
                    height: screenHeight * 0.1, // Chiều cao logo theo tỷ lệ
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Title
                  Text(
                    'HỆ THỐNG THÔNG TIN CƠ SỞ HẠ TẦNG',
                    style: TextStyle(
                      fontSize: screenWidth *
                          0.05, // Kích thước chữ theo tỷ lệ màn hình
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'NHẬP THÔNG TIN CỦA BẠN',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập địa chỉ email';
                      }
                      if (!value.contains('@')) {
                        return 'Địa chỉ email không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mật khẩu',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu';
                      }
                      if (value.length < 6) {
                        return 'Mật khẩu phải có ít nhất 6 ký tự';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Remember Me Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                      ),
                      const Text('Ghi nhớ tài khoản')
                    ],
                  ),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      ),
                      onPressed: _submitForm,
                      child: Text(
                        'ĐĂNG NHẬP',
                        style: TextStyle(
                            fontSize: screenWidth * 0.04, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Links for "Forgot Password?" and "Sign Up"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Add your forgot password logic here
                        },
                        child: const Text('Quên mật khẩu?',
                            style: TextStyle(fontSize: 12)),
                      ),
                      const Text('|'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()),
                          );
                        },
                        child: const Text('Bạn chưa có tài khoản? Đăng ký',
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Footer
                  const Text(
                    'Copyright by Nhóm 4',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
