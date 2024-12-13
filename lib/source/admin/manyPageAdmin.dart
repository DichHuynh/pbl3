import 'package:flutter/material.dart';
import 'package:pbl3/source/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hệ thống Quản lý Sự cố',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      initialRoute: '/',
      routes: {
        // '/manageIssues': (context) => const ManageIssuesScreen(),
        // '/manageEquipment': (context) => const ManageEquipmentScreen(),
        '/maintenanceSchedule': (context) => const MaintenanceScheduleScreen(),
        '/reports': (context) => const ReportsScreen(),
        // '/manageUsers': (context) => const ManageUsersScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/systemSettings': (context) => const SystemSettingsScreen(),
      },
      home: Scaffold(
        appBar: AppBar(title: const Text('Hệ thống Quản lý Sự cố')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/manageIssues');
                },
                child: const Text('Quản lý Sự cố'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/manageEquipment');
                },
                child: const Text('Quản lý Vật tư Thiết bị'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/maintenanceSchedule');
                },
                child: const Text('Lập kế hoạch Bảo trì'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/reports');
                },
                child: const Text('Xem Báo cáo'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/manageUsers');
                },
                child: const Text('Quản lý Người dùng'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/notifications');
                },
                child: const Text('Thông báo và Cảnh báo'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/systemSettings');
                },
                child: const Text('Cài đặt Hệ thống'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------ Màn hình Quản lý Sự cố ------------------
// class ManageIssuesScreen extends StatelessWidget {
//   const ManageIssuesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Quản lý Sự cố')),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16.0),
//         itemCount: 5, // Giả sử có 5 sự cố để quản lý
//         itemBuilder: (context, index) {
//           return Card(
//             child: ListTile(
//               title: Text('Sự cố $index'),
//               subtitle: const Text('Tình trạng xử lý: Đang xử lý'),
//               trailing: const Icon(Icons.check_circle, color: Colors.green),
//               onTap: () {
//                 // Xử lý phân công sự cố
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// ------------------ Màn hình Quản lý Vật tư Thiết bị ------------------
// class ManageEquipmentScreen extends StatelessWidget {
//   const ManageEquipmentScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Quản lý Vật tư Thiết bị')),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16.0),
//         itemCount: 3, // Giả sử có 3 thiết bị
//         itemBuilder: (context, index) {
//           return Card(
//             child: ListTile(
//               title: Text('Thiết bị $index'),
//               subtitle: const Text('Tình trạng: Đang bảo trì'),
//               trailing: const Icon(Icons.build, color: Colors.orange),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// ------------------ Màn hình Lập kế hoạch Bảo trì ------------------
class MaintenanceScheduleScreen extends StatelessWidget {
  const MaintenanceScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lập kế hoạch Bảo trì')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Mở màn hình tạo kế hoạch bảo trì mới
              },
              child: const Text('Tạo Kế hoạch Bảo trì'),
            ),
            const SizedBox(height: 20),
            const Text('Danh sách kế hoạch bảo trì'),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 3, // Giả sử có 3 kế hoạch bảo trì
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('Kế hoạch bảo trì $index'),
                      subtitle: const Text('Ngày: 01/12/2024'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------ Màn hình Xem Báo cáo ------------------
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xem Báo cáo')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 3, // Giả sử có 3 báo cáo
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('Báo cáo $index'),
              subtitle: const Text('Chi tiết báo cáo về sự cố và bảo trì'),
              trailing: const Icon(Icons.visibility),
              onTap: () {
                // Xử lý xem chi tiết báo cáo
              },
            ),
          );
        },
      ),
    );
  }
}

// ------------------ Màn hình Quản lý Người dùng ------------------
// class ManageUsersScreen extends StatelessWidget {
//   const ManageUsersScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Quản lý Người dùng')),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16.0),
//         itemCount: 3, // Giả sử có 3 người dùng
//         itemBuilder: (context, index) {
//           return Card(
//             child: ListTile(
//               title: Text('Người dùng $index'),
//               subtitle: const Text('Phân quyền: Quản trị viên'),
//               trailing: const Icon(Icons.edit, color: Colors.blue),
//               onTap: () {
//                 // Xử lý chỉnh sửa thông tin người dùng
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// ------------------ Màn hình Thông báo và Cảnh báo ------------------
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo và Cảnh báo')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 3, // Giả sử có 3 thông báo
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('Thông báo $index'),
              subtitle: const Text('Thông tin về sự cố hoặc bảo trì'),
            ),
          );
        },
      ),
    );
  }
}

// ------------------ Màn hình Cài đặt Hệ thống ------------------
class SystemSettingsScreen extends StatelessWidget {
  const SystemSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt Hệ thống')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginPage()),);
              },
              child: const Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }
}
