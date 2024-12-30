import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/issues.dart';
import './map.dart'; // Đảm bảo bạn import đúng màn hình bản đồ

class HomeScreen extends StatelessWidget {
  final CollectionReference issuesCollection =
      FirebaseFirestore.instance.collection('issues');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Trang Chủ',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.map, color: Colors.black),
            onPressed: () {
              // Điều hướng tới màn hình bản đồ
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(), // Mở màn hình bản đồ
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream:
            issuesCollection.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi khi tải dữ liệu'));
          }

          final data = snapshot.requireData;

          if (data.size == 0) {
            return Center(child: Text('Không có sự cố nào'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: data.size,
            itemBuilder: (context, index) {
              final issue = Issue.fromMap(
                  data.docs[index].data() as Map<String, dynamic>,
                  data.docs[index].id);

              return Card(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: ListTile(
                  leading: issue.imageUrl.isNotEmpty
                      ? Image.network(issue.imageUrl,
                          width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.report, color: Colors.redAccent, size: 50),
                  title: Text(issue.description),
                  subtitle: Text(
                      'Vị trí: ${issue.location}\nTrạng thái: ${issue.status}'),
                  onTap: () {
                    // Xử lý khi nhấn vào một sự cố
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
