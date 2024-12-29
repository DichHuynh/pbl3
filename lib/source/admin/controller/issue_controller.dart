import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pbl3/source/admin/model/issue_model.dart';
import 'package:pbl3/source/admin/model/tech_model.dart';

class IssueController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy danh sách sự cố từ Firestore
  Future<List<Issue>> getIssues() async {
    try {
      final snapshot = await _firestore.collection('issues').get();
      return snapshot.docs.map((doc) {
        return Issue.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e, stackTrace) {
      print("Error fetching issues: $e");
      print(stackTrace);
      rethrow; // Xử lý lỗi nếu cần
    }
  }

  Future<List<Technician>> getTechnicians() async {
    try {
      // Truy vấn chỉ lấy các user có role là 'tech'
      final snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'Tech')
          .get();

      // Chuyển đổi dữ liệu từ Firestore thành danh sách Technician
      return snapshot.docs.map((doc) {
        return Technician.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy danh sách kỹ thuật viên: $e');
      rethrow; // Ném lại lỗi nếu cần xử lý ở cấp cao hơn
    }
  }

  // Phân công nhân sự xử lý sự cố
  Future<void> assignTask({
    required String issueId,
    required String technicianId,
    required String technicianName,
    required String deadline,
  }) async {
    try {
      final issueRef = _firestore.collection('issues').doc(issueId);

      await issueRef.update({
        'techId': technicianId,
        'techName': technicianName,
        'deadline': deadline,
        'status': 'Đang xử lý',
      });
    } catch (e) {
      rethrow; // Xử lý lỗi nếu cần
    }
  }
}
