import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/Issue.dart';
import 'dart:typed_data';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:http/http.dart' as http;
import 'dart:convert';

class IssueService {
  final CollectionReference issueCollection =
      FirebaseFirestore.instance.collection('issues');

  // Gửi báo cáo sự cố = viết dữ liệu vào Firestore
  Future<void> createIssue(Issue issue) async {
    try {
      await issueCollection.add(issue.toMap());
    } catch (e) {
      throw Exception('Failed to update Firebase: $e');
    }
  }

  Future<void> updateIssue(String documentId, Issue issue) async {
  try {
    // Dùng `documentId` để xác định tài liệu cần cập nhật
    await issueCollection.doc(documentId).update(issue.toMap());
  } catch (e) {
    throw Exception('Failed to update Firebase: $e');
  }
}


  // Lấy danh sách báo cáo sự cố theo techId từ Firestore
  Stream<List<Issue>> getIssuesByTech(String techId) {
    return issueCollection
        .where('techId', isEqualTo: techId) // Lọc theo userId
        .snapshots() // Lấy dữ liệu trực tiếp khi có thay đổi
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                Issue.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

//   // Tải ảnh lên Cloudinary và lấy URL ảnh
//     Future<String?> uploadImageToCloudinary(String imageBytes) async {
//     final cloudinaryUrl =
//         Uri.parse("https://api.cloudinary.com/v1_1/dy3gsgb0j/image/upload");
//     final request = http.MultipartRequest("POST", cloudinaryUrl);
//     request.fields['upload_preset'] = 'ml_default';

//     request.files.add(http.MultipartFile.fromBytes('file', imageBytes,
//         filename: 'image.jpg'));

//     final response = await request.send();

//     if (response.statusCode == 200) {
//       final responseData = await response.stream.bytesToString();
//       final jsonData = json.decode(responseData);
//       return jsonData['secure_url']; // Trả về URL của ảnh đã tải lên
//     } else {
//       print('Lỗi khi tải ảnh lên Cloudinary: ${response.statusCode}');
//       return null;
//     }
//   }
// }

Future<String?> uploadImageToCloudinary(String imagePath) async {
  final cloudinaryUrl =
      Uri.parse("https://api.cloudinary.com/v1_1/dy3gsgb0j/image/upload");
  final request = http.MultipartRequest("POST", cloudinaryUrl);

  // Include the upload preset
  request.fields['upload_preset'] = 'ml_default';

  try {
    // Attach the file from the provided image path
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      imagePath,
      filename: 'image.jpg',
    ));

    // Send the request
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);
      return jsonData['secure_url']; // Return the image URL from Cloudinary
    } else {
      print('Lỗi khi tải ảnh lên Cloudinary: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Lỗi khi tải ảnh lên: $e');
    return null;
  }
}
}


  // Lấy danh sách sự cố của người dùng và sắp xếp theo thời gian (từ mới nhất đến cũ nhất)
// tạo 1 list để lưu data lấy từ getIssue về r hiển thị
// List[Issue] 
// widget listview