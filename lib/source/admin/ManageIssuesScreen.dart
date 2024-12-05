import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageIssuesScreen extends StatefulWidget {
  const ManageIssuesScreen({super.key});
  @override
  _ManageIssuesState createState() => _ManageIssuesState();
  }

class _ManageIssuesState extends State<ManageIssuesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý Sự cố')),
      body: Column(
        children: [
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
    );
  }
}