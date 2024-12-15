import 'package:flutter/material.dart';
import 'package:pbl3/source/admin/ManageIssue.dart';
import 'package:pbl3/source/admin/manageEquipment.dart';
import 'package:pbl3/source/admin/manageTech.dart';
import 'package:pbl3/source/admin/manageUser.dart';
import 'package:pbl3/source/admin/manyPageAdmin.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang Quản trị'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildCard(
              context,
              icon: Icons.report_problem,
              title: 'Quản lý Sự cố',
              description: 'Xem và quản lý các sự cố được báo cáo.',
              pageBuilder: (context) => ManageIssuesScreen(),
            ),
            SizedBox(height: 16),
            _buildCard(
              context,
              icon: Icons.build,
              title: 'Quản lý Vật tư Thiết bị',
              description: 'Quản lý thiết bị, vật tư và tình trạng bảo trì.',
              pageBuilder: (context) => ManageEquipmentScreen(),
            ),
            SizedBox(height: 16),
            _buildCard(
              context,
              icon: Icons.schedule,
              title: 'Lập kế hoạch Bảo trì',
              description: 'Quản lý lịch trình bảo trì định kỳ.',
              pageBuilder: (context) => MaintenanceScheduleScreen(),
            ),
            SizedBox(height: 16),
            _buildCard(
              context,
              icon: Icons.report,
              title: 'Quản lý nhân sự',
              description: 'Quản lý các tài khoản kỹ thuật của hệ thống.',
              pageBuilder: (context) => ManageTech(),
            ),
            SizedBox(height: 16),
            _buildCard(
              context,
              icon: Icons.person_add,
              title: 'Quản lý Người dùng',
              description: 'Quản lý người dùng và phân quyền.',
              pageBuilder: (context) => ManageUsersScreen(),
            ),
            SizedBox(height: 16),
            _buildCard(
              context,
              icon: Icons.notifications,
              title: 'Thông báo và Cảnh báo',
              description: 'Quản lý thông báo cho người dùng.',
              pageBuilder: (context) => NotificationsScreen(),
            ),
            SizedBox(height: 16),
            _buildCard(
              context,
              icon: Icons.settings,
              title: 'Cài đặt Hệ thống',
              description: 'Quản lý cài đặt của hệ thống.',
              pageBuilder: (context) => SystemSettingsScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String description,
      required WidgetBuilder pageBuilder}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: pageBuilder),
          );
        },
      ),
    );
  }
}
