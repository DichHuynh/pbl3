import 'package:flutter/material.dart';
import '../controllers/issues.dart';
import '../models/issues.dart';

class IssueHistoryScreen extends StatelessWidget {
  final String userId; // Truyền userId của người dùng hiện tại

  IssueHistoryScreen({required this.userId});

  final IssueService _issueService = IssueService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch Sử Báo Cáo Sự Cố'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Hiển thị cảnh báo trước khi xóa tất cả báo cáo
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Xóa tất cả báo cáo?'),
                  content: Text(
                      'Bạn có chắc chắn muốn xóa tất cả các báo cáo sự cố?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _deleteAllReports(context); // Xóa tất cả báo cáo
                      },
                      child: Text('Xóa'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Issue>>(
        stream: _issueService.getIssuesByUser(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Lỗi khi tải dữ liệu: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có báo cáo sự cố nào.'));
          }

          final issues = snapshot.data!;

          return ListView.builder(
            itemCount: issues.length,
            itemBuilder: (context, index) {
              final issue = issues[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(issue.description),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Vị trí: ${issue.location}'),
                      Text('Thời gian: ${issue.createdAt.toLocal()}'),
                      Text('Trạng thái: ${issue.status}'),
                      if (issue.imageUrl.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              // Khi nhấn vào chữ "Hình ảnh", mở màn hình xem hình ảnh
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImagePreviewScreen(
                                    imageUrl: issue.imageUrl,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Hình ảnh', // Chữ "Hình ảnh"
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  leading: Icon(Icons.report_problem, color: Colors.red),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Hiển thị cảnh báo trước khi xóa báo cáo
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Xóa báo cáo này?'),
                          content:
                              Text('Bạn có chắc chắn muốn xóa báo cáo này?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Hủy'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _deleteIssue(context, issue.id); // Xóa báo cáo
                              },
                              child: Text('Xóa'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Hàm xóa báo cáo sự cố và thông báo cho người dùng
  Future<void> _deleteIssue(BuildContext context, String issueId) async {
    try {
      await _issueService.deleteIssue(issueId); // Xóa báo cáo theo id
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xóa báo cáo sự cố.'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 50.0), // Tùy chỉnh vị trí
          duration: Duration(seconds: 2), // Thời gian hiển thị
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi xóa báo cáo: $e'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 50.0), // Tùy chỉnh vị trí
          duration: Duration(seconds: 2), // Thời gian hiển thị
        ),
      );
    }
  }

  // Hàm xóa tất cả báo cáo sự cố và thông báo cho người dùng
  Future<void> _deleteAllReports(BuildContext context) async {
    try {
      await _issueService.deleteAllIssues(userId); // Truyền userId vào đây
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xóa tất cả báo cáo sự cố.'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 50.0), // Tùy chỉnh vị trí
          duration: Duration(seconds: 2), // Thời gian hiển thị
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi xóa báo cáo: $e'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 50.0), // Tùy chỉnh vị trí
          duration: Duration(seconds: 2), // Thời gian hiển thị
        ),
      );
    }
  }
}

class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;

  ImagePreviewScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Màu nền trắng của AppBar
        elevation: 0, // Không có bóng dưới AppBar
        iconTheme:
            IconThemeData(color: Colors.black), // Màu biểu tượng là màu đen
      ),
      body: Container(
        color: Colors.white, // Màu nền trắng bên ngoài hình ảnh
        child: Center(
          child: InteractiveViewer(
            child:
                Image.network(imageUrl), // Hiển thị hình ảnh ở chế độ xem lớn
          ),
        ),
      ),
    );
  }
}
