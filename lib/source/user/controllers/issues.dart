import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/issues.dart';

class IssueService {
  final CollectionReference issueCollection =
      FirebaseFirestore.instance.collection('issues');

  // Gửi báo cáo sự cố
  Future<void> createIssue(Issue issue) async {
    try {
      await issueCollection.add(issue.toMap());
    } catch (e) {
      throw Exception('Failed to create issue: $e');
    }
  }

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
