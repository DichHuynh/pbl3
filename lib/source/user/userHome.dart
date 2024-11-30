import 'package:flutter/material.dart';
import 'package:pbl3/source/user/PageofDuong.dart';
import 'package:pbl3/source/user/issue.dart';
import 'package:pbl3/source/user/personal.dart'; // Đảm bảo tệp `personal.dart` tồn tại
import 'package:pbl3/source/user/report.dart';
import 'package:pbl3/source/user/iconpage.dart';

class UserHomePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UserHomePage({super.key, required this.userData});

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<UserHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang thông tin cơ sở hạ tầng'),
        backgroundColor: Colors.blue, // Màu nền cho AppBar
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCard(
                    context,
                    icon: Icons.report_problem,
                    title: 'Báo cáo Sự cố',
                    description:
                        'Gửi thông tin về sự cố giao thông bạn gặp phải.',
                    pageBuilder: (context) => ReportIssuePage(),
                  ),
                  SizedBox(height: 16),
                  _buildCard(
                    context,
                    icon: Icons.assignment_turned_in,
                    title: 'Theo dõi Tiến trình Xử lý',
                    description: 'Theo dõi tiến độ xử lý sự cố bạn đã báo.',
                    pageBuilder: (context) => TrackProgressScreen(),
                  ),
                  SizedBox(height: 16),
                  _buildCard(
                    context,
                    icon: Icons.feedback,
                    title: 'Gửi Phản hồi',
                    description: 'Đánh giá chất lượng xử lý sự cố.',
                    pageBuilder: (context) => FeedbackScreen(),
                  ),
                  SizedBox(height: 16),
                  _buildCard(
                    context,
                    icon: Icons.info,
                    title: 'Thông tin Cơ sở hạ tầng Giao thông',
                    description:
                        'Xem thông tin về các cơ sở hạ tầng giao thông.',
                    pageBuilder: (context) => TrafficInfoScreen(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Báo cáo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Giới thiệu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
        currentIndex: 0, // Đặt mặc định mục "Trang chủ" được chọn
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => IssuePage()),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReportIssuePage()),
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PersonalAccountPage(userData: widget.userData)),
            );
          }
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
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
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: pageBuilder),
            );
        }
        
      ),
    );
  }
}

//Navigation Bar
class IconContainer extends StatelessWidget {
  final String imageUrl;
  final String label;

  const IconContainer({super.key, required this.imageUrl, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imageUrl,
          width: 100,
          height: 100,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.image_not_supported,
                size: 100, color: Colors.grey);
          },
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
