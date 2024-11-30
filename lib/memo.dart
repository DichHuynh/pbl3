import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hệ thống Báo cáo Sự cố Giao thông',
      
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => UserHomeScreen(),
        '/reportIssue': (context) => ReportIssueScreen(),
        '/trackProgress': (context) => TrackProgressScreen(),
        '/feedback': (context) => FeedbackScreen(),
        '/trafficInfo': (context) => TrafficInfoScreen(),
      },
    );
  }
}

// ------------------ Trang Người dùng ------------------
class UserHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang Người dùng'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCard(
              context,
              icon: Icons.report_problem,
              title: 'Báo cáo Sự cố',
              description: 'Gửi thông tin về sự cố giao thông bạn gặp phải.',
              routeName: '/reportIssue',
            ),
            SizedBox(height: 16),
            _buildCard(
              context,
              icon: Icons.assignment_turned_in,
              title: 'Theo dõi Tiến trình Xử lý',
              description: 'Theo dõi tiến độ xử lý sự cố bạn đã báo.',
              routeName: '/trackProgress',
            ),
            SizedBox(height: 16),
            _buildCard(
              context,
              icon: Icons.feedback,
              title: 'Gửi Phản hồi',
              description: 'Đánh giá chất lượng xử lý sự cố.',
              routeName: '/feedback',
            ),
            SizedBox(height: 16),
            _buildCard(
              context,
              icon: Icons.info,
              title: 'Thông tin Cơ sở hạ tầng Giao thông',
              description: 'Xem thông tin về các cơ sở hạ tầng giao thông.',
              routeName: '/trafficInfo',
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
      required String routeName}) {
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
        onTap: () => Navigator.pushNamed(context, routeName),
      ),
    );
  }
}

// ------------------ Trang Báo cáo sự cố ------------------
class ReportIssueScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Báo cáo Sự cố Giao thông')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Trường mô tả sự cố
            TextField(
              decoration: InputDecoration(
                labelText: 'Mô tả Sự cố',
                border: OutlineInputBorder(),
              ),
              maxLines: 3, // Để nhập nội dung dài
            ),
            SizedBox(height: 16),

            // Trường chọn loại sự cố
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Chọn Loại Sự cố',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: 'Đèn tín hiệu hỏng', child: Text('Đèn tín hiệu hỏng')),
                DropdownMenuItem(value: 'Cột đèn chiếu sáng bị gãy', child: Text('Cột đèn chiếu sáng bị gãy')),
                DropdownMenuItem(value: 'Khác', child: Text('Khác')),
              ],
              onChanged: (value) {},
            ),
            SizedBox(height: 16),

            // Trường chọn vị trí
            TextField(
              decoration: InputDecoration(
                labelText: 'Vị trí (Ví dụ: Đường ABC, Phường XYZ)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Nút chọn ảnh
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hình ảnh minh họa:',
                  style: TextStyle(fontSize: 16),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Thêm logic chọn ảnh từ thư viện hoặc chụp ảnh
                  },
                  icon: Icon(Icons.photo_camera),
                  label: Text('Chọn ảnh'),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Trường đính kèm tệp
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tệp đính kèm:',
                  style: TextStyle(fontSize: 16),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Thêm logic chọn tệp
                  },
                  icon: Icon(Icons.attach_file),
                  label: Text('Chọn tệp'),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Nút gửi báo cáo
            ElevatedButton(
              onPressed: () {
                // Gửi báo cáo sự cố
              },
              child: Text('Gửi Báo cáo'),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------ Trang Theo dõi tiến trình xử lý sự cố ------------------
class TrackProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Theo dõi Tiến trình Xử lý')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 5, // Giả sử có 5 sự cố đã báo
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('Sự cố $index'),
              subtitle: Text('Trạng thái: Đang xử lý'),
              trailing: Icon(Icons.assignment, color: Colors.blue),
            ),
          );
        },
      ),
    );
  }
}

// ------------------ Trang Gửi phản hồi ------------------
class FeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phản hồi về chất lượng xử lý')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Đánh giá chất lượng xử lý sự cố của bạn:'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Icon(Icons.star_border, color: Colors.yellow);
              }),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Ghi chú (tùy chọn)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Gửi phản hồi
              },
              child: Text('Gửi Phản hồi'),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------ Trang Thông tin cơ sở hạ tầng giao thông ------------------
class TrafficInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(' Cơ sở hạ tầng Giao thông')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 5, // Giả sử có 5 cơ sở hạ tầng giao thông
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('Cơ sở hạ tầng $index'),
              subtitle: Text('Mô tả cơ sở hạ tầng $index'),
              trailing: Icon(Icons.info, color: Colors.blue),
            ),
          );
        },
      ),
    );
  }
}
