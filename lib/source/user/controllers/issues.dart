import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart'; // Thêm thư viện này để sử dụng ScaffoldMessenger
import '../models/issues.dart';

class IssueService {
  final CollectionReference issueCollection =
      FirebaseFirestore.instance.collection('issues');

  // Gửi báo cáo sự cố = viết dữ liệu vào Firestore
  Future<void> createIssue(Issue issue) async {
    try {
      await issueCollection.add(issue.toMap());
    } catch (e) {
      throw Exception('Failed to create issue: $e');
    }
  }


  // Tải ảnh lên Cloudinary và lấy URL ảnh
  Future<String?> uploadImageToCloudinary(Uint8List imageBytes) async {
    final cloudinaryUrl =
        Uri.parse("https://api.cloudinary.com/v1_1/dy3gsgb0j/image/upload");
    final request = http.MultipartRequest("POST", cloudinaryUrl);
    request.fields['upload_preset'] = 'ml_default';

    request.files.add(http.MultipartFile.fromBytes('file', imageBytes,
        filename: 'image.jpg'));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);
      return jsonData['secure_url']; // Trả về URL của ảnh đã tải lên
    } else {
      print('Lỗi khi tải ảnh lên Cloudinary: ${response.statusCode}');
      return null;
    }
  }

  // Lấy danh sách sự cố của người dùng và sắp xếp theo thời gian (từ mới nhất đến cũ nhất)


  // Lấy danh sách báo cáo sự cố theo userId từ Firestore

  Stream<List<Issue>> getIssuesByUser(String userId) {
    return issueCollection
        .where('userId', isEqualTo: userId) // Lọc theo userId
        .orderBy("createdAt", descending: true)
        .snapshots() // Lấy dữ liệu trực tiếp khi có thay đổi
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                Issue.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Phương thức xóa báo cáo sự cố
  Future<void> deleteIssue(String issueId) async {
    try {
      // Xóa báo cáo sự cố khỏi Firestore
      await issueCollection
          .doc(issueId)
          .delete(); // Sử dụng issueCollection thay vì _firestore
    } catch (e) {
      throw Exception('Lỗi khi xóa báo cáo: $e');
    }
  }

  // Hàm xóa tất cả báo cáo sự cố
  Future<void> deleteAllIssues(String userId) async {
    try {
      // Lấy danh sách các báo cáo sự cố của người dùng
      final querySnapshot =
          await issueCollection.where('userId', isEqualTo: userId).get();

      // Xóa tất cả báo cáo sự cố
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Không thể xóa các báo cáo sự cố: $e');
    }
  }

  // Hàm xóa tất cả báo cáo sự cố và thông báo cho người dùng
  Future<void> _deleteAllReports(BuildContext context, String userId) async {
    try {
      // Gọi phương thức deleteAllIssues để xóa tất cả báo cáo sự cố
      await deleteAllIssues(userId); // Truyền userId vào đây
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xóa tất cả báo cáo sự cố.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xóa báo cáo: $e')),
      );
    }
  }
}
