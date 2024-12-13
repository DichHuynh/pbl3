import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ManageUsersScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _detailUser(BuildContext context, Map<String, dynamic> user) {
    final TextEditingController nameController =
        TextEditingController(text: user['name']);
    final TextEditingController emailController =
        TextEditingController(text: user['email']);
    final TextEditingController addressController =
        TextEditingController(text: user['address']);
// Định dạng ngày tạo từ Timestamp
    String formattedDate = '';
    if (user['createAt'] != null) {
      formattedDate =
          DateFormat('dd/MM/yyyy HH:mm:ss').format(user['createAt'].toDate());
    }

    final TextEditingController createdAtController =
        TextEditingController(text: formattedDate);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(8),
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
                  CupertinoButton(
                    child: const Text("Hủy"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton.filled(
                    child: Text(user['status'] == 'Active' ? "Khóa" : "Mở"),
                    onPressed: () async {
                      try {
                        // Cập nhật trạng thái tài khoản
                        final newStatus =
                            user['status'] == 'Active' ? 'Inactive' : 'Active';
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user['id'])
                            .update({'status': newStatus});

                        // Hiển thị thông báo thành công
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Đã cập nhật trạng thái tài khoản thành ${newStatus == 'Active' ? 'Hoạt động' : 'Không hoạt động'}.'),
                          ),
                        );

                        // Đóng modal sau khi cập nhật
                        Navigator.pop(context);
                      } catch (e) {
                        // Hiển thị thông báo lỗi
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
  }

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
            .where('role', isEqualTo: 'user')
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
                  leading: CircleAvatar(
                    backgroundImage: user['avatar'] != null
                        ? NetworkImage(user['avatar'])
                        : null,
                    child: user['avatar'] == null
                        ? const Icon(Icons.person)
                        : null,
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
                        _detailUser(context, user);
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
    );
  }
}
