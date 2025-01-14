// File: lib/views/add_technician_view.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pbl3/source/admin/controller/account_controller.dart';

import 'package:pbl3/source/admin/model/tech_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddTechnician extends StatefulWidget {
  @override
  _AddTechnicianState createState() => _AddTechnicianState();
}

class _AddTechnicianState extends State<AddTechnician> {
  final AccountController _controller = AccountController();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _expertiseController = TextEditingController();

  List<String> _expertiseOptions = [
    'Chuyên viên điện',
    'Chuyên viên nước',
    'Chuyên viên dân dụng',
    'Chuyên viên mạng',
    'Thêm mới'
  ];
  
  String? _selectedExpertise = 'Chuyên viên điện';
  bool _isCustomExpertise = false;
  String? _avatarUrl;

  // Chức năng chọn ảnh
  Future<void> _pickAvatar() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();
      String? uploadUrl = await _uploadToCloudinary(imageBytes);
      if (uploadUrl != null) {
        setState(() {
          _avatarUrl = uploadUrl;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tải ảnh thành công!')),
        );
      } else {
        throw Exception("Không thể tải ảnh lên Cloudinary");
      }
    }
  }

  Future<String?> _uploadToCloudinary(Uint8List imageBytes) async {
    // Upload ảnh lên Cloudinary
    try {
      final cloudinaryUrl = Uri.parse("https://api.cloudinary.com/v1_1/dy3gsgb0j/image/upload");
      final request = http.MultipartRequest("POST", cloudinaryUrl);
      request.fields['upload_preset'] = 'ml_default';
      request.files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: 'image.jpg'));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = json.decode(responseData);
        return jsonData['secure_url'];
      }
    } catch (e) {
      print("Lỗi khi tải lên Cloudinary: $e");
      return null;
    }
  }

  Future<void> _registerTechnician() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mật khẩu không khớp')),
        );
        return;
      }
      
      // Tạo kỹ thuật viên mới
      Technician technician = Technician(
        id: '', // ID sẽ được tạo trên Firebase
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
        expertise: _isCustomExpertise ? _expertiseController.text.trim() : _selectedExpertise!,
        avatar: _avatarUrl ?? '',
        role: 'Tech',
        status: 'Active',
      );

      try {
        await _controller.registerTechnician(technician);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng ký thành công!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm Kỹ thuật viên')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickAvatar,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _avatarUrl != null ? NetworkImage(_avatarUrl!) : null,
                    child: _avatarUrl == null ? const Icon(Icons.add_a_photo, size: 50) : null,
                  ),
                ),
              ),
              // Các trường thông tin khác
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Họ và tên'),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập họ và tên' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty || !value.contains('@') ? 'Email không hợp lệ' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
                validator: (value) => value!.length < 6 ? 'Mật khẩu ít nhất 6 ký tự' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Xác nhận mật khẩu'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập xác nhận mật khẩu' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Địa chỉ'),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập địa chỉ' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập số điện thoại' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedExpertise,
                items: _expertiseOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    if (value == 'Thêm mới') {
                      _isCustomExpertise = true;
                      _expertiseController.clear();
                    } else {
                      _isCustomExpertise = false;
                      _selectedExpertise = value;
                      _expertiseController.text = value!;
                    }
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Chuyên môn',
                  border: OutlineInputBorder(),
                ),
              ),
              if (_isCustomExpertise)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextFormField(
                    controller: _expertiseController,
                    decoration: const InputDecoration(
                      labelText: 'Chuyên môn (nhập mới)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Vui lòng nhập chuyên môn' : null,
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _registerTechnician,
                child: const Text('Thêm kỹ thuật viên'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
