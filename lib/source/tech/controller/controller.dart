import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/issue.dart';

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


  // Lấy danh sách báo cáo sự cố theo userId từ Firestore
  Stream<List<Issue>> getIssuesByUser(String userId) {
    return issueCollection
        .where('userId', isEqualTo: userId) // Lọc theo userId
        .snapshots() // Lấy dữ liệu trực tiếp khi có thay đổi
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                Issue.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }
}
