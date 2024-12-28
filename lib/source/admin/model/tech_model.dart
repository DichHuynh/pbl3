
import 'package:cloud_firestore/cloud_firestore.dart';

class Technician {
  final String id;
  final String name;
  final String email;
  final String address;
  final String phone;
  final String expertise;
  final String avatar;
  final String status;
  final DateTime? createdAt;
  final String? password;
  final String role;

  Technician({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    required this.expertise,
    required this.avatar,
    required this.status,
    this.createdAt,
    this.password,
    this.role = 'Tech',
  });

  // Ánh xạ từ Map sang Technician
  factory Technician.fromMap(Map<String, dynamic> map, String id) {
    return Technician(
      id: id,
      name: map['name'] ?? 'Nguyễn Văn A',
      email: map['email'] ?? 'nguyenvana@example.com',
      address: map['address'] ?? 'Địa chỉ của bạn',
      phone: map['phone'] ?? '',
      expertise: map['expertise'] ?? '',
      avatar: map['avatar'] ?? '',
      status: map['status'] ?? 'hoạt động',
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] as Timestamp).toDate() // Chuyển đổi Timestamp thành DateTime
          : DateTime.now(), // Sử dụng thời gian hiện tại nếu không có
    );
  }

  // Chuyển từ Technician sang Map để lưu Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'address': address,
      'phone': phone,
      'expertise': expertise,
      'avatar': avatar,
      'status': status,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}
