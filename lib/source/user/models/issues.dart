import 'package:cloud_firestore/cloud_firestore.dart';

// model của Dương
class Issue {
  final String id; // ID tự động
  final String userId; // ID người dùng báo cáo
  final String description; // Mô tả sự cố
  final String location; // Vị trí sự cố
  final DateTime createdAt; // Thời gian báo cáo
  final String status; // Trạng thái sự cố (pending, resolved, etc.)
  final String imageUrl; // URL của hình ảnh sự cố

  Issue({
    required this.id,
    required this.userId,
    required this.description,
    required this.location,
    required this.createdAt,
    required this.status,
    required this.imageUrl,
  });

  factory Issue.fromMap(Map<String, dynamic> data, String documentId) {
    return Issue(
      id: documentId,
      userId: data['userId'],
      description: data['description'],
      location: data['location'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      status: data['status'] ?? 'chưa xử lý',
      imageUrl: data['imageUrl'] ?? '', // Đảm bảo trường imageUrl không null
    );
  }

  // Chuyển từ Issue sang Map để lưu vào Firebase
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'description': description,
      'location': location,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
      'imageUrl': imageUrl, // Thêm trường imageUrl vào Map
    };
  }
}
