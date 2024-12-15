import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ManageUsersScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

void _detailUser(BuildContext context, Map<String, dynamic> user) {
  String formattedDate = user['createdAt'] != null
      ? DateFormat('dd/MM/yyyy HH:mm:ss').format(user['createdAt'].toDate())
      : 'Không có dữ liệu';
      
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
              "Thông tin chi tiết",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(CupertinoIcons.person),
              title: const Text("Họ và tên"),
              subtitle: Text(user['name'] ?? "Chưa có thông tin"),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(CupertinoIcons.mail),
              title: const Text("Email"),
              subtitle: Text(user['email'] ?? "Chưa có thông tin"),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(CupertinoIcons.location),
              title: const Text("Địa chỉ"),
              subtitle: Text(user['address'] ?? "Chưa có thông tin"),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(CupertinoIcons.calendar),
              title: const Text("Ngày tạo"),
              subtitle: Text(formattedDate),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  child: const Text("Đóng"),
                  onPressed: () => Navigator.pop(context),
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
