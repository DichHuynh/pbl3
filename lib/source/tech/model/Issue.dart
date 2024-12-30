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
  final String imageUrl; // đường dẫn hình ảnhảnh

  Issue({
    required this.id,
    required this.createdAt,
    required this.description,
    required this.location,
    required this.status,
    required this.userId,
    required this.techId,
    required this.imageUrl,
    required this.techNote,
  });

  // factory variables into Issue object for storing in Firestore 
  factory Issue.fromMap(Map<String, dynamic> data, String documentId) {
    return Issue(
      id: documentId,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      status: data['status'] ?? '',
      userId: data['userId'] ?? '',
      techId: data['techId'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      techNote: data['techNote'] ?? '',
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
      'imageUrl': imageUrl,
      'techNote': techNote,
    };
  }
}

