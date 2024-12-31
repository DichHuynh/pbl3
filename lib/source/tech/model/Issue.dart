import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Evaluation {
  final double qualityRating;
  final double timeRating;
  final String comment;
  final DateTime? updatedAt;

  Evaluation({
    required this.qualityRating,
    required this.timeRating,
    required this.comment,
    this.updatedAt,
  });

  // Chuyển từ Map sang Evaluation
  factory Evaluation.fromMap(Map<String, dynamic> map) {
    return Evaluation(
      qualityRating: map['qualityRating']?.toDouble() ?? 0.0,
      timeRating: map['timeRating']?.toDouble() ?? 0.0,
      comment: map['comment'] ?? '',
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Chuyển từ Evaluation sang Map
  Map<String, dynamic> toMap() {
    return {
      'qualityRating': qualityRating,
      'timeRating': timeRating,
      'comment': comment,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}

class Issue{
  final String id;
  final DateTime createdAt;
  final String description;
  final String location;
  final String status;
  final String userId;
  final String techId;
  final String techNote; // ghi chú của kỹ thuật viên
  final String imageUrlAfter; // đường dẫn hình ảnhảnh
  final String? imageUrl; // đường dẫn hình ảnh
  final Evaluation? evaluation;

  Issue({
    required this.id,
    required this.createdAt,
    required this.description,
    required this.location,
    required this.status,
    required this.userId,
    required this.techId,
    required this.imageUrlAfter,
    required this.techNote,
    this.imageUrl,
    this.evaluation,
  });

  // factory variables into Issue object for storing in Firestore 
  factory Issue.fromMap(Map<String, dynamic> data, String documentId) {
    return Issue(
      id: documentId,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      status: data['status'] ?? '',
      userId: data['userId'] ?? '',
      techId: data['techId'] ?? '',
      imageUrlAfter: data['imageUrlAfter'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      techNote: data['techNote'] ?? '',
      evaluation: data['evaluation'] != null
          ? Evaluation.fromMap(data['evaluation'] as Map<String, dynamic>)
          : null,
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
      'imageUrlAfter': imageUrlAfter,
      'techNote': techNote,
    };
  }
}

