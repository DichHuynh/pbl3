import 'package:cloud_firestore/cloud_firestore.dart';

class Issue {
  final String id;
  final String description;
  final String location;
  final String status;
  final String imageUrl;
  final DateTime? reportDate;
  final DateTime? resolutionDate;

  Issue({
    required this.id,
    required this.description,
    required this.location,
    required this.status,
    required this.imageUrl,
    this.reportDate,
    this.resolutionDate,
  });

  // Chuyển từ Map sang Issue
  factory Issue.fromMap(Map<String, dynamic> map, String id) {
    return Issue(
      id: id,
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      status: map['status'] ?? 'Chưa xử lý',
      imageUrl: map['imageUrl'] ?? '', // Ánh xạ trường imageUrl
      reportDate: map['reportDate'] != null
          ? (map['reportDate'] as Timestamp).toDate()
          : null, // Chuyển đổi Timestamp thành DateTime
      resolutionDate: map['resolutionDate'] != null
          ? (map['resolutionDate'] as Timestamp).toDate()
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
      'reportDate': reportDate != null ? Timestamp.fromDate(reportDate!) : null,
      'resolutionDate':
          resolutionDate != null ? Timestamp.fromDate(resolutionDate!) : null,
    };
  }
}
