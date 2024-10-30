import 'package:flutter/material.dart';
import 'package:pbl3/login/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Đăng ký người dùng mới',
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      print("Họ và tên: ${_nameController.text}");
      print("Email: ${_emailController.text}");
      print("Mật khẩu: ${_passwordController.text}");
      print("Địa chỉ: ${_addressController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Đăng ký người dùng mới',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                _buildTextField(_nameController, 'Họ và tên', 'Nhập họ và tên'),
                SizedBox(height: 15),
                _buildTextField(_emailController, 'Email', 'Nhập email', isEmail: true),
                SizedBox(height: 15),
                _buildTextField(_passwordController, 'Mật khẩu', 'Nhập mật khẩu', isPassword: true),
                SizedBox(height: 15),
                _buildTextField(_confirmPasswordController, 'Nhập lại mật khẩu', 'Nhập lại mật khẩu', isPassword: true),
                SizedBox(height: 15),
                _buildFilePickerButton('Chọn avatar'),
                SizedBox(height: 15),
                _buildTextField(_addressController, 'Địa chỉ', 'Nhập địa chỉ'),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(
                      'Đăng ký',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: EdgeInsets.symmetric(vertical: 15)),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(
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

  Widget _buildTextField(TextEditingController controller, String label, String hint, {bool isPassword = false, bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
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
      onPressed: () {
        // Implement file picker functionality here
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('Không có tệp nào được chọn'),
        ],
      ),
    );
  }
}
