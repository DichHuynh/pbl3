import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pbl3/source/admin/addTechnician.dart';
import 'package:pbl3/source/admin/controller/account_controller.dart';
import 'package:pbl3/source/admin/model/tech_model.dart';

class TechnicalAccountsTab extends StatelessWidget {
  final AccountController controller = AccountController();

  void _detailTech(BuildContext context, Technician technician) {
    // Logic to show details and update a technician
    // This will include a modal to edit technician details
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final TextEditingController nameController =
            TextEditingController(text: technician.name);
        final TextEditingController emailController =
            TextEditingController(text: technician.email);
        final TextEditingController addressController =
            TextEditingController(text: technician.address);
        final TextEditingController phoneController =
            TextEditingController(text: technician.phone);
        final TextEditingController expertiseController =
            TextEditingController(text: technician.expertise);

        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Chỉnh sửa thông tin",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: nameController,
                placeholder: "Họ và tên",
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: emailController,
                placeholder: "Email",
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: phoneController,
                placeholder: "Số điện thoại",
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: addressController,
                placeholder: "Địa chỉ",
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: expertiseController,
                placeholder: "Chuyên môn",
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text("Lưu"),
                    onPressed: () async {
                      try {
                        final updatedTechnician = Technician(
                          id: technician.id,
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          address: addressController.text.trim(),
                          phone: phoneController.text.trim(),
                          expertise: expertiseController.text.trim(),
                          avatar: technician.avatar, // Avatar remains the same
                          status: technician.status,
                          createdAt: technician.createdAt,
                        );

                        await controller.updateTechnician(
                          updatedTechnician,
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          address: addressController.text.trim(),
                          phone: phoneController.text.trim(),
                          expertise: expertiseController.text.trim(),
                          context: context,
                        );
                        Navigator.pop(context); // Close the modal
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                  CupertinoButton(
                    child: Text(technician.status == 'Active' ? "Khóa" : "Mở"),
                    onPressed: () async {
                      try {
                        await controller.toggleAccountStatus(
                            technician.id, technician.status);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Đã cập nhật trạng thái tài khoản thành ${technician.status == 'Active' ? 'Không hoạt động' : 'Hoạt động'}.',
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
        title: const Text('Quản lý Kỹ thuật viên'),
      ),
      body: StreamBuilder<List<Technician>>(
        stream: controller.getTechniciansStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có người dùng nào.'));
          }

          final technicians = snapshot.data!;

          return ListView.builder(
            itemCount: technicians.length,
            itemBuilder: (context, index) {
              final technician = technicians[index];

              return Card(
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      technician.avatar,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 50);
                      },
                    ),
                  ),
                  title: Text(technician.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${technician.email}'),
                      const SizedBox(height: 4),
                      Text(
                        'Trạng thái: ${technician.status == 'Active' ? 'Đang hoạt động' : 'Bị khóa'}',
                        style: TextStyle(
                          color: technician.status == 'Active'
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _detailTech(context, technician);
                      } else if (value == 'delete') {
                        controller.deleteTechnician(technician.id);
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
        margin: const EdgeInsets.only(bottom: 16.0),
        child: SizedBox(
          width: 100,
          height: 40,
          child: CupertinoButton(
            color: const Color.fromARGB(255, 92, 255, 59),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            borderRadius: BorderRadius.circular(20.0),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddTechnician()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(CupertinoIcons.add, size: 18, color: Colors.black),
                SizedBox(width: 2),
                Text("Thêm mới",
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
