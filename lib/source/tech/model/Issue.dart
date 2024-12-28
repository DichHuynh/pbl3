import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


class Issue{
  final String id;
  final DateTime createdAt;
  final String description;
  final String location;
  final String status;
  final String userId;
  final String techId;
  final String techNote; // ghi chú của kỹ thuật viên
  final String? imageUrl; // đường dẫn hình ảnhảnh

  Issue({
    this.id = '',
    this.userId = '', // id của người báo cáo sự cố
    this.techId = '', // id của kỹ thuật viên xử lý sự cố
    required this.createdAt, // thời gian báo cáo sự cố
    this.description = '', // mô tả sự cố
    this.location = '', // vị trí sự cố
    required this.status, // cập nhật trạng thái sự cố
    required this.imageUrl, // hình ảnh sau khi xử lý sự cố
    required this.techNote, // ghi chú của kỹ thuật viên viên
  });

  // factory variables into Issue object for storing in Firestore 
  factory Issue.fromMap(Map<String, dynamic> data, String documentId) {
    return Issue(
      id: documentId,
      createdAt: data['createdAt'],
      status: data['status'],
      imageUrl: data['imageUrl'],
      techNote: data['techNote'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': Timestamp.fromDate(createdAt),
      'description': description,
      'location': location,
      'status': status,
      'userId': userId,
      'techId': techId,
    };
  }
}

