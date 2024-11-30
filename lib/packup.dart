import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pbl3/source/user/report.dart';
import 'package:flutter/cupertino.dart';

void main() async {
  runApp(const Page());
}

class Page extends StatelessWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Hệ thống thông tin cơ sở hạ tầng',
      home: IssuePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class IssuePage extends StatefulWidget {
  const IssuePage({super.key});
  @override
  _IssueState createState() => _IssueState();
}

class _IssueState extends State<IssuePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Các sự cố hạ tầng',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        elevation: 1.0,
      ),
      body: Column(
        children: [
          // Nút hành động
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Để khoảng cách giữa các nút
              children: [
                Expanded(
                  // Sử dụng Expanded để các nút chạy hết chiều ngang của màn hình
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.verified, size: 12),
                    label: const Text("Xác minh thông tin"),
                    onPressed: () {},
                  ),
                ),
                SizedBox(width: 10), // Khoảng cách giữa các nút
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.sos, size: 12),
                    label: const Text("Ứng cứu khẩn cấp"),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          // Tìm kiếm và danh mục
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 245, 240, 197),
                  ),
                  onPressed: () {},
                  child: const Text("Tìm kiếm"),
                ),
              ],
            ),
          ),
          // Các tab "Tiêu biểu", "Đã xử lý", "Đang xử lý"
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text("Tiêu biểu"),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Đã xử lý"),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Đang xử lý"),
                ),
              ],
            ),
          ),
          // Danh sách phản ánh
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('issues').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Có lỗi xảy ra'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Không có dữ liệu sự cố'));
                }

                final reports = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report =
                        reports[index].data() as Map<String, dynamic>;

                    // Lấy các trường từ Firestore
                    final description =
                        report['description'] ?? 'Không có mô tả';
                    final imageUrl = report['imageUrl'] ??
                        "https://via.placeholder.com/150"; // Ảnh mặc định nếu không có
                    final location = report['location'] ?? 'Không có vị trí';
                    final reportDate = report['reportDate'] != null
                        ? (report['reportDate'] as Timestamp).toDate()
                        : null;
                    final resolutionDate = report['resolutionDate'] != null
                        ? (report['resolutionDate'] as Timestamp).toDate()
                        : null;
                    final status = report['status'] ?? 'Không có trạng thái';

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        isThreeLine: true,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 50);
                            },
                          ),
                        ),
                        title: Text(
                          description,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Vị trí: $location"),
                            if (reportDate != null)
                              Text("Ngày báo cáo: ${reportDate.toLocal()}"),
                            if (resolutionDate != null)
                              Text("Ngày xử lý: ${resolutionDate.toLocal()}"),
                          ],
                        ),
                        trailing: Text(
                          status,
                          style: TextStyle(
                            color: status == "Đã xử lý"
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(
            bottom: 16.0), // Để căn chỉnh nút với mép dưới
        // Đoạn này để căn chỉnh kích thước cho tối đa 60 pixels
        child: SizedBox(
          width: 100, // Đặt chiều rộng tùy chỉnh cho nút
          height: 40, // Đặt chiều cao tùy chỉnh cho nút
          child: FloatingActionButton(
            backgroundColor: Colors.yellow, // Màu nền của nút nổi
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ReportIssuePage()),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.max, // Chiều rộng cố định
              mainAxisAlignment:
                  MainAxisAlignment.center, // Căn giữa các phần tử trong hàng
              children: const [
                Icon(Icons.add), // Biểu tượng cho nút
                SizedBox(width: 8), // Khoảng cách giữa biểu tượng và văn bản
                Text("Báo cáo",
                    style: TextStyle(fontSize: 16)), // Văn bản cho nút
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // Đặt nút ở phía dưới bên phải
      // Đặt nút ở phía dưới bên phải
      // Đặt nút ở phía dưới bên phải
    );
  }
}
