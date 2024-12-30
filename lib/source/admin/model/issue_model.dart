import 'package:cloud_firestore/cloud_firestore.dart';

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

class Issue {
  final String id;
  final String description;
  final String location;
  final String status;
  final String imageUrl;
  final DateTime? createdAt;
  final DateTime? resolutionDate;
  final DateTime? deadline;
  final String? imageUrlAfter;
  final Evaluation? evaluation; // Thêm trường evaluation
  final String? techName;

  Issue({
    required this.id,
    required this.description,
    required this.location,
    required this.status,
    required this.imageUrl,
    this.createdAt,
    this.resolutionDate,
    this.deadline,
    this.imageUrlAfter,
    this.evaluation,
    this.techName,
  });

  // Chuyển từ Map sang Issue
  factory Issue.fromMap(Map<String, dynamic> map, String id) {
    return Issue(
      id: id,
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      status: map['status'] ?? 'Chưa xử lý',
      techName: map['techName'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      resolutionDate: map['resolutionDate'] != null
          ? (map['resolutionDate'] as Timestamp).toDate()
          : null,
      deadline: map['deadline'] != null
          ? (map['deadline'] as Timestamp).toDate()
          : null,
      imageUrlAfter: map['imageUrlAfter'] ?? '',
      evaluation: map['evaluation'] != null
          ? Evaluation.fromMap(map['evaluation'] as Map<String, dynamic>)
          : null, // Chuyển đổi evaluation
    );
  }

  // Chuyển từ Issue sang Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'location': location,
      'status': status,
      'imageUrl': imageUrl,
      'techName': techName,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'resolutionDate':
          resolutionDate != null ? Timestamp.fromDate(resolutionDate!) : null,
      'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
      'imageUrlAfter': imageUrlAfter ?? '',
      'evaluation': evaluation?.toMap(), // Thêm evaluation
    };
  }
}
