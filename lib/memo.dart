import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pbl3/source/user/report.dart';

void main() async {
  runApp(const Page());
}

class Page extends StatelessWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          'Các sự cố hạ tầng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Column(
        children: [
          // Nút hành động
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CupertinoButton(
                    color: CupertinoColors.activeBlue,
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(CupertinoIcons.check_mark, size: 18),
                        SizedBox(width: 8),
                        Text("Xác minh thông tin"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CupertinoButton(
                    color: CupertinoColors.systemRed,
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(CupertinoIcons.bolt_horizontal_circle, size: 18),
                        SizedBox(width: 8),
                        Text("Ứng cứu khẩn cấp"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Nút tìm kiếm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  color: CupertinoColors.systemYellow,
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
                CupertinoButton(
                  child: const Text("Tiêu biểu"),
                  onPressed: () {},
                ),
                CupertinoButton(
                  child: const Text("Đã xử lý"),
                  onPressed: () {},
                ),
                CupertinoButton(
                  child: const Text("Đang xử lý"),
                  onPressed: () {},
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
                  return const Center(child: CupertinoActivityIndicator());
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

                    final description =
                        report['description'] ?? 'Không có mô tả';
                    final imageUrl = report['imageUrl'] ??
                        "https://via.placeholder.com/150";
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
                              return const Icon(CupertinoIcons.xmark, size: 50);
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
                                ? CupertinoColors.activeGreen
                                : CupertinoColors.destructiveRed,
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
    );
  }
}
