import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageEquipmentScreen extends StatefulWidget {
  const ManageEquipmentScreen({super.key});
  @override
  _ManageEquipmentState createState() => _ManageEquipmentState();
}

class _ManageEquipmentState extends State<ManageEquipmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý Vật tư Thiết bị')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('equipment').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Có lỗi xảy ra khi tải dữ liệu'));
          }

          final documents = snapshot.data?.docs ?? [];

          if (documents.isEmpty) {
            return const Center(
                child: Text('Không có thiết bị nào được ghi nhận.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final equipment = documents[index];
              final installDate =
                  (equipment['install_date'] as Timestamp).toDate();
              final lastInspection =
                  (equipment['last_inspection'] as Timestamp).toDate();
              final specification =
                  equipment['Specification'] ?? 'Không có thông tin';
              final location = equipment['location'] ?? 'Chưa xác định';
              final status = equipment['status'];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(specification),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Vị trí: $location'),
                      Text('Ngày cài đặt: ${installDate.toLocal()}'),
                      Text('Lần kiểm tra cuối: ${lastInspection.toLocal()}'),
                      Text('Trạng thái: $status'),
                    ],
                  ),
                  trailing: Icon(
                    _getStatusIcon(status), // Gọi hàm lấy icon dựa trên trạng thái
                    color: _getStatusColor(status), // Màu sắc icon tùy theo trạng thái
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    if (status.contains("Maintaincing")) {
      return Icons.build; // Icon cho trạng thái bảo trì
    } else if (status.contains("InActive")) {
      return Icons.check_circle; // Icon cho trạng thái đang hoạt động
    } else if (status.contains("Fault")) {
      return Icons.error; // Icon cho trạng thái lỗi
    }
    return Icons.help_outline; // Icon mặc định nếu không xác định
  }

  Color _getStatusColor(String status) {
    if (status.contains("Maintaincing")) {
      return Colors.orange; // Màu cam cho bảo trì
    } else if (status.contains("InActive")) {
      return Colors.green; // Màu xanh cho đang hoạt động
    } else if (status.contains("Fault")) {
      return Colors.red; // Màu đỏ cho lỗi
    }
    return Colors.grey; // Màu xám cho trạng thái không xác định
  }
}
