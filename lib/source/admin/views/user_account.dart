import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbl3/source/admin/controller/account_controller.dart';
import 'package:pbl3/source/admin/model/account_model.dart';

class UserAccountsTab extends StatelessWidget {
  final AccountController _userController = AccountController();

  void _detailUser(BuildContext context, AccountModel user) {
    String formattedDate = user.createdAt != null
        ? DateFormat('dd/MM/yyyy HH:mm:ss').format(user.createdAt!)
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
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Họ và tên"),
                subtitle: Text(user.name ?? "Chưa có thông tin"),
              ),
              ListTile(
                leading: const Icon(Icons.mail),
                title: const Text("Email"),
                subtitle: Text(user.email ?? "Chưa có thông tin"),
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text("Địa chỉ"),
                subtitle: Text(user.address ?? "Chưa có thông tin"),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text("Ngày tạo"),
                subtitle: Text(formattedDate),
              ),
              ElevatedButton(
                child: const Text("Đóng"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: Text(user.status == 'Active' ? "Khóa" : "Mở"),
                onPressed: () async {
                  try {
                    await _userController.toggleAccountStatus(
                        user.id, user.status);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Đã cập nhật trạng thái tài khoản thành ${user.status == 'Active' ? 'Không hoạt động' : 'Hoạt động'}.',
                        ),
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Người dùng'),
      ),
      body: StreamBuilder<List<AccountModel>>(
        stream: _userController.getUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có người dùng nào.'));
          }

          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final bool isActive = user.status == 'Active';

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        user.avatar != null ? NetworkImage(user.avatar!) : null,
                    child:
                        user.avatar == null ? const Icon(Icons.person) : null,
                  ),
                  title: Text(user.name ?? 'Không rõ tên'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${user.email ?? 'Không rõ email'}'),
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
                        _userController.deleteUser(user.id);
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
