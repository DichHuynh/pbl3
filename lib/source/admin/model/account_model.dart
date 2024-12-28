
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountModel {
  final String id;
  final String name;
  final String email;
  final String address;
  final String avatar;
  final String status;
  final DateTime? createdAt;

  AccountModel({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.avatar,
    required this.status,
    this.createdAt,
  });

  // Ánh xạ từ Map sang AccountModel
  factory AccountModel.fromMap(Map<String, dynamic> map, String id) {
    return AccountModel(
      id: id,
      name: map['name'] ?? 'Nguyễn Văn A',
      email: map['email'] ?? 'nguyenvana@example.com',
      address: map['address'] ?? 'Địa chỉ của bạn',
      avatar: map['avatar'] ?? '',
      status: map['status'] ?? 'hoạt động',
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] as Timestamp).toDate() // Chuyển đổi Timestamp thành DateTime
          : DateTime.now(), // Sử dụng thời gian hiện tại nếu không có
    );
  }

  // Chuyển từ AccountModel sang Map để lưu Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'address': address,
      'avatar': avatar,
      'status': status,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}

