import 'package:cloud_firestore/cloud_firestore.dart';

class Issue {
  final String id; // ID tự động
  final String userId; // ID người dùng báo cáo
  final String description; // Mô tả sự cố
  final String location; // Vị trí sự cố
  final DateTime createdAt; // Thời gian báo cáo
  final String status; // Trạng thái sự cố (pending, resolved, etc.)

  Issue({
    required this.id,
    required this.userId,
    required this.description,
    required this.location,
    required this.createdAt,
    required this.status,
  });

  factory Issue.fromMap(Map<String, dynamic> data, String documentId) {
    return Issue(
      id: documentId,
      userId: data['userId'],
      description: data['description'],
      location: data['location'],
      createdAt: (data['createdAt'] as Timestamp)
          .toDate(), // Chuyển Timestamp thành DateTime
      status: data['status'],
    );
  }

  // Chuyển từ Issue sang Map để lưu vào Firebase
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'description': description,
      'location': location,
      'createdAt':
          Timestamp.fromDate(createdAt), // Chuyển từ DateTime sang Timestamp
      'status': status,
    };
  }
}
