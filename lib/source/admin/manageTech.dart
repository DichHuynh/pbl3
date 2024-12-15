import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbl3/source/admin/addTechnician.dart';

class ManageTech extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//hàm hiển thị chi tiết người dùng
  void _detailTech(BuildContext context, Map<String, dynamic> user) {
    final TextEditingController nameController =
        TextEditingController(text: user['name']);
    final TextEditingController emailController =
        TextEditingController(text: user['email']);
    final TextEditingController addressController =
        TextEditingController(text: user['address']);
    final TextEditingController phoneController =
        TextEditingController(text: user['phone']);
    final TextEditingController expertiseController =
        TextEditingController(text: user['expertise']);
    List<String> expertiseOptions = [
      'Chuyên viên điện',
      'Chuyên viên nước',
      'Chuyên viên dân dụng',
      'Chuyên viên mạng',
      'Thêm mới'
    ];
    String? selectedExpertise = user['expertise']; // Chuyên môn được chọn
    bool isCustomExpertise = false; // Xác định nếu "Thêm mới" được chọn

    // Định dạng ngày tạo từ Timestamp
    String formattedDate = user['createdAt'] != null
        ? DateFormat('dd/MM/yyyy HH:mm:ss').format(user['createdAt'].toDate())
        : 'Không có dữ liệu';

    final TextEditingController createdAtController =
        TextEditingController(text: formattedDate);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Chỉnh sửa thông tin",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  CupertinoTextField(
                    controller: nameController,
                    placeholder: "Họ và tên",
                    prefix: const Icon(CupertinoIcons.person),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CupertinoTextField(
                    controller: emailController,
                    placeholder: "Email",
                    prefix: const Icon(CupertinoIcons.mail),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CupertinoTextField(
                    controller: phoneController,
                    placeholder: "Phone Number",
                    prefix: const Icon(CupertinoIcons.phone),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CupertinoTextField(
                    controller: addressController,
                    placeholder: "Nhập địa chỉ",
                    prefix: const Icon(CupertinoIcons.location,
                        color: CupertinoColors.systemGrey),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: isCustomExpertise ? 'Thêm mới' : selectedExpertise,
                    items: expertiseOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        if (value == 'Thêm mới') {
                          isCustomExpertise = true;
                          expertiseController.clear();
                        } else {
                          isCustomExpertise = false;
                          selectedExpertise = value;
                          expertiseController.text = value!;
                        }
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Chuyên môn',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (isCustomExpertise)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: TextFormField(
                        controller: expertiseController,
                        decoration: const InputDecoration(
                          labelText: 'Chuyên môn (nhập mới)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Vui lòng nhập chuyên môn' : null,
                      ),
                    ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: createdAtController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Ngày tạo',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton.filled(
                        child: const Text("Lưu"),
                        onPressed: () async {
                          try {
                            // Cập nhật thông tin người dùng lên Firestore
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user[
                                    'id']) // ID của người dùng trong Firestore
                                .update({
                              'name': nameController.text.trim(),
                              'email': emailController.text.trim(),
                              'address': addressController.text.trim(),
                              'updatedAt': Timestamp.now(),
                              'expertise': expertiseController.text.trim(),
                              'phone': phoneController.text.trim(),
                            });

                            // Hiển thị thông báo thành công
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Cập nhật thông tin thành công!")),
                            );

                            // Đóng modal
                            Navigator.pop(context);
                          } catch (e) {
                            // Hiển thị thông báo lỗi
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Lỗi: ${e.toString()}")),
                            );
                          }
                        },
                      ),
                      CupertinoButton.filled(
                        child: Text(user['status'] == 'Active' ? "Khóa" : "Mở"),
                        onPressed: () async {
                          try {
                            final newStatus = user['status'] == 'Active'
                                ? 'Inactive'
                                : 'Active';
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user['id'])
                                .update({'status': newStatus});

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Đã cập nhật trạng thái tài khoản thành ${newStatus == 'Active' ? 'Hoạt động' : 'Không hoạt động'}.'),
                              ),
                            );
                            Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Lỗi: ${e.toString()}')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

// hàm xóa người dùng
  void _deleteUser(String userId) {
    // Hàm xóa người dùng
    _firestore.collection('users').doc(userId).delete();
    print('Xóa người dùng với ID: $userId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Người dùng'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .where('role', isEqualTo: 'Tech')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Không có người dùng nào.'));
          }

          final users = snapshot.data!.docs.map((doc) {
            return {
              'id': doc.id,
              ...doc.data() as Map<String, dynamic>,
            };
          }).toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final bool isActive =
                  user['status'] == 'Active'; // Kiểm tra trạng thái tài khoản

              return Card(
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      user['avatar'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 50);
                      },
                    ),
                  ),
                  title: Text(user['name'] ?? 'Không rõ tên'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${user['email'] ?? 'Không rõ email'}'),
                      const SizedBox(height: 4),
                      Text(
                        'Trạng thái: ${isActive ? 'Đang hoạt động' : 'Bị khóa'}',
                        style: TextStyle(
                          color: isActive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _detailTech(context, user);
                      } else if (value == 'delete') {
                        _deleteUser(user['id']);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                          value: 'edit', child: Text('Chi tiết')),
                      const PopupMenuItem(value: 'delete', child: Text('Xóa')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(
            bottom: 16.0), // Để căn chỉnh nút với mép dưới
        // Đoạn này để căn chỉnh kích thước cho tối đa 60 pixels
        child: SizedBox(
          width: 100, // Đặt chiều rộng tùy chỉnh cho nút
          height: 40, // Đặt chiều cao tùy chỉnh cho nút
          child: CupertinoButton(
            color: const Color.fromARGB(255, 92, 255, 59), // Màu nền của nút
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            borderRadius: BorderRadius.circular(20.0), // Bo góc tương tự FAB
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTechnician()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Căn giữa nội dung
              children: const [
                Icon(
                  CupertinoIcons.add,
                  size: 18,
                  color: Colors.black,
                ),
                SizedBox(width: 2), // Khoảng cách giữa biểu tượng và văn bản
                Text(
                  "Thêm mới",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
