// issue_model.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class IssueModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> uploadImage(Uint8List imageBytes) async {
    final cloudinaryUrl = Uri.parse("https://api.cloudinary.com/v1_1/dy3gsgb0j/image/upload");
    final request = http.MultipartRequest("POST", cloudinaryUrl);
    request.fields['upload_preset'] = 'ml_default';

    request.files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: 'image.jpg'));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);
      return jsonData['secure_url'];
    } else {
      print('Error uploading image: ${response.statusCode}');
      return null;
    }
  }

  Future<void> saveIssueData({
    required UserCredential userCredential,
    required String description,
    required String location,
    required String image,
    DateTime? resolutionDate, // nullable nếu chưa có
    String status = "Chưa xử lý" // Giá trị mặc định
  }) async {
    await _firestore.collection('issues').doc(userCredential.user!.uid).set({
      'description': description,
      'location': location,
      'reportDate': Timestamp.now(),
      'image': image,
      'resolutionDate': resolutionDate != null ? Timestamp.fromDate(resolutionDate) : null,
      'status': status,
    });
  }
}
