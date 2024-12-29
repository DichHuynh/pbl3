import 'package:cloud_firestore/cloud_firestore.dart';

class Issue {
  final String id;
  final String description;
  final String location;
  final String status;
  final String imageUrl;
  final DateTime? createdAt;
  final DateTime? resolutionDate;
  final DateTime? deadline;

  Issue({
    required this.id,
    required this.description,
    required this.location,
    required this.status,
    required this.imageUrl,
    this.createdAt,
    this.resolutionDate,
    this.deadline,
  });

  // Chuyển từ Map sang Issue
  factory Issue.fromMap(Map<String, dynamic> map, String id) {
    return Issue(
      id: id,
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      status: map['status'] ?? 'Chưa xử lý',
      imageUrl: map['imageUrl'] ?? '', // Ánh xạ trường imageUrl
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null, // Chuyển đổi Timestamp thành DateTime
      resolutionDate: map['resolutionDate'] != null
          ? (map['resolutionDate'] as Timestamp).toDate()
          : null,
      deadline: map['deadline'] != null
          ? (map['deadline'] as Timestamp).toDate()
          : null,
    );
  }

  // Chuyển từ Issue sang Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'location': location,
      'status': status,
      'imageUrl': imageUrl,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'resolutionDate':
          resolutionDate != null ? Timestamp.fromDate(resolutionDate!) : null,
      'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
    };
  }
}
