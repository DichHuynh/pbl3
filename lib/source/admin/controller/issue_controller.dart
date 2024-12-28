// controllers/issue_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pbl3/source/admin/model/issue_model.dart';

class IssueController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy danh sách sự cố từ Firestore
  Future<List<Issue>> getIssues() async {
    try {
      final snapshot = await _firestore.collection('issues').get();
      return snapshot.docs.map((doc) {
        return Issue.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      rethrow; // Xử lý lỗi nếu cần
    }
  }
}

