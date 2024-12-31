import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../model/Issue.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IssueService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference issueCollection =
      FirebaseFirestore.instance.collection('issues');

  // Cập nhật báo cáo sự cố
  Future<void> updateIssue({
    required String issueId,
    required String notes,
    Uint8List? imageBytes,
  }) async {
    try {
      // Upload ảnh nếu có
      String? imageUrlAfter;
      if (imageBytes != null) {
        imageUrlAfter = await _uploadToCloudinary(imageBytes);
      }

      // Tạo bản đồ dữ liệu cần cập nhật
      Map<String, dynamic> updateData = {
        'notes': notes,
        'resolutionDate': DateTime.now().toUtc(),
        'imageUrlAfter': imageUrlAfter,
        'status': 'Đã xử lý',
      };

      // Cập nhật tài liệu trong Firestore
      await issueCollection.doc(issueId).update(updateData);
    } catch (e) {
      throw Exception('Failed to update issue: $e');
    }
  }

  // Lấy danh sách sự cố theo techId
  Stream<List<Issue>> getIssuesByTech(String techId) {
    return issueCollection
        .where('techId', isEqualTo: techId) // Lọc theo techId
        .where('status', isEqualTo: 'Đang xử lý') // Lọc theo status
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                Issue.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Stream<List<Issue>> getIssuesHistory(String techId) {
    try {
      return _firestore
          .collection('issues')
          .where('techId', isEqualTo: techId)// Lọc theo techId
          .where('status', isEqualTo: 'Đã xử lý') // Lọc theo status
          .snapshots() // Sử dụng snapshots để nhận dữ liệu theo thời gian thực
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return Issue.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      });
    } catch (e) {
      print("Error fetching issues: $e");
      return Stream.error(e); // Trả về stream lỗi nếu có vấn đề
    }
  }

  // Chọn ảnh từ thư viện
  Future<Uint8List?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return await image.readAsBytes();
    }
    return null;
  }

  // Upload ảnh lên Cloudinary
  Future<String?> _uploadToCloudinary(Uint8List imageBytes) async {
    try {
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
        return jsonData['secure_url'];
      } else {
        print("Cloudinary upload failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error uploading to Cloudinary: $e");
      return null;
    }
  }
}

  // Lấy danh sách sự cố của người dùng và sắp xếp theo thời gian (từ mới nhất đến cũ nhất)
// tạo 1 list để lưu data lấy từ getIssue về r hiển thị
// List[Issue] 
// widget listview