import 'package:flutter/material.dart';
import 'package:pbl3/source/admin/controller/issue_controller.dart';
import 'package:pbl3/source/admin/model/issue_model.dart';

class AssignTask extends StatefulWidget {
  const AssignTask({super.key});

  @override
  _AssignTaskState createState() => _AssignTaskState();
}

class _AssignTaskState extends State<AssignTask> {
  final IssueController _controller = IssueController();

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Gán Công việc cho Sự cố')),
    body: FutureBuilder<List<Issue>>(
      future: _controller.getIssues(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Có lỗi xảy ra'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có dữ liệu sự cố'));
        }

        final issues = snapshot.data!;

        return ListView.builder(
          itemCount: issues.length,
          itemBuilder: (context, index) {
            final issue = issues[index];

            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                isThreeLine: true,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    issue.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 50);
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
                    if (issue.reportDate != null)
                      Text("Ngày báo cáo: ${issue.reportDate!.toLocal()}"),
                    if (issue.resolutionDate != null)
                      Text("Ngày xử lý: ${issue.resolutionDate!.toLocal()}"),
                  ],
                ),
                trailing: Text(
                  issue.status,
                  style: TextStyle(
                    color: issue.status == "Đã xử lý" ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        );
      },
    ),
  );
}
}