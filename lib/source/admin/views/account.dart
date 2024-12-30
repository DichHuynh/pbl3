import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pbl3/source/admin/controller/account_controller.dart';
import 'package:pbl3/source/admin/model/account_model.dart';
import 'package:pbl3/source/login.dart';

class AccountPage extends StatefulWidget {
  final String? userId;

  const AccountPage({super.key, required this.userId});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late AccountController _userController;
  AccountModel? _user;

  @override
  void initState() {
    super.initState();
    _userController = AccountController();
    _loadAccount();
  }

  Future<void> _loadAccount() async {
    try {
      AccountModel user = await _userController.getAccount(widget.userId!);
      setState(() {
        _user = user;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}')));
    }
  }

  void _showEditModal(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: _user?.name ?? '');
    final TextEditingController emailController =
        TextEditingController(text: _user?.email ?? '');
    final TextEditingController addressController =
        TextEditingController(text: _user?.address ?? '');

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
                prefix: Icon(CupertinoIcons.person),
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: emailController,
                placeholder: "Email",
                prefix: Icon(CupertinoIcons.mail),
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: addressController,
                placeholder: 'Địa chỉ',
                prefix: Icon(CupertinoIcons.location),
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
                    child: const Text("Lưu"),
                    onPressed: () async {
                      try {
                        AccountModel updatedAccount = AccountModel(
                          id: _user!.id,
                          name: nameController.text,
                          email: emailController.text,
                          address: addressController.text,
                          avatar: _user!.avatar,
                          status: _user!.status, // Không cập nhật, giữ nguyên
                          createdAt: _user!.createdAt,
                        );
                        await _userController.updateAccount(
                            widget.userId!, updatedAccount);
                        Navigator.pop(context);
                        setState(() {
                          _user = updatedAccount;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Cập nhật thành công!")),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Lỗi: ${e.toString()}")),
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

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tài khoản cá nhân"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.blue,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(_user!.avatar),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _user!.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _user!.email,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            const Divider(height: 20, thickness: 1),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, color: Colors.white),
              ),
              title: const Text(
                "Chỉnh sửa thông tin",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              onTap: () => _showEditModal(context),
            ),
            const Divider(height: 20, thickness: 1),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock, color: Colors.white),
              ),
              title: const Text(
                "Đổi mật khẩu",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                // Xử lý logic đổi mật khẩu
              },
            ),
            const Divider(height: 20, thickness: 1),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.logout, color: Colors.white),
              ),
              title: const Text(
                "Đăng xuất",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
