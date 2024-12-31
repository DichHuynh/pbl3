import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Để format ngày tháng
import 'package:pbl3/source/tech/model/Issue.dart';
import 'package:pbl3/source/tech/controller/controller.dart';

class HistoryScreen extends StatefulWidget {
  final String techId; // Truyền userId của kỹ thuật viên hiện tại

  HistoryScreen({required this.techId});
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final IssueService _issueService = IssueService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử công việc'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 40, 149, 238),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Issue>>(
        stream: _issueService.getIssuesHistory(widget.techId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Có lỗi xảy ra!'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có dữ liệu sự cố!'));
          }

          final issues = snapshot.data!;

          return ListView.builder(
            itemCount: issues.length,
            itemBuilder: (context, index) {
              final issue = issues[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 4,
                shadowColor: Colors.grey.withOpacity(0.2),
                child: Column(
                  children: [
                    ListTile(
                      isThreeLine: true,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          issue.imageUrl ?? '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.broken_image, size: 24),
                              ),
                            );
                          },
                        ),
                      ),
                      title: Text(
                        issue.description,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Vị trí: ${issue.location}"),
                          Text("Trạng thái: ${issue.status}"),
                          if (issue.techNote.isNotEmpty)
                            Text("Ghi chú: ${issue.techNote}"),
                          Text(
                              "Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(issue.createdAt)}"),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: issue.status == "Đang xử lý"
                              ? Colors.orange[100]
                              : Colors.green[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          issue.status,
                          style: TextStyle(
                            color: issue.status == "Đang xử lý"
                                ? Colors.orange
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    ExpansionTile(
                      title: const Text(
                        'Đánh giá công việc',
                        style: TextStyle(color: Colors.blue),
                      ),
                      leading: const Icon(Icons.star, color: Colors.amber),
                      children: [
                        if (issue.evaluation != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber),
                                    const SizedBox(width: 8),
                                    Text(
                                        'Chất lượng: ${issue.evaluation!.qualityRating}/5'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time,
                                        color: Colors.green),
                                    const SizedBox(width: 8),
                                    Text(
                                        'Thời gian: ${issue.evaluation!.timeRating}/5'),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.comment,
                                        color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Nhận xét: ${issue.evaluation!.comment}',
                                        style: const TextStyle(fontSize: 14),
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Cập nhật lúc: ${issue.evaluation!.updatedAt ?? 'Không xác định'}',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        if (issue.evaluation == null)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Chưa có đánh giá cho sự cố này.',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                    if (issue.imageUrlAfter.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            issue.imageUrlAfter,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height:50,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.broken_image, size: 50),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
