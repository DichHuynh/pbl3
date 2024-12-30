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
      appBar: AppBar(
        title: Text('Phân công công việc'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 40, 149, 238),
        foregroundColor: Colors.white,
      ),
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
                child: Column(
                  children: [
                    ListTile(
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
                          if (issue.createdAt != null)
                            Text("Ngày báo cáo: ${issue.createdAt!.toLocal()}"),
                        ],
                      ),
                      trailing: Text(
                        issue.status,
                        style: TextStyle(
                          color: issue.status == "Đang xử lý"
                              ? Colors.orange // Màu cam cho "Đang xử lý"
                              : Colors.red, // Màu đỏ cho "Chưa xử lý"
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _assignTask(context, issue);
                        },
                        child: const Text('Phân công nhân sự'),
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

void _assignTask(BuildContext context, Issue issue) async {
  final _controller = IssueController();
  final TextEditingController deadlineController = TextEditingController();

  try {
    final technicians = await _controller.getTechnicians();

    showDialog(
      context: context,
      builder: (context) {
        String? selectedTechnicianId;
        String? selectedTechnicianName;
        DateTime? selectedDeadline; // Thêm biến DateTime để lưu deadline

        return AlertDialog(
          title: const Text('Phân công kỹ thuật viên'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Hiển thị danh sách kỹ thuật viên
                ...technicians.map((technician) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(technician.avatar),
                      onBackgroundImageError: (_, __) =>
                          const Icon(Icons.person),
                    ),
                    title: Text(technician.name),
                    subtitle: Text(technician.expertise),
                    trailing: Text(technician.status),
                    onTap: () {
                      selectedTechnicianId = technician.id;
                      selectedTechnicianName = technician.name;
                    },
                  );
                }).toList(),
                // Chọn deadline
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextField(
                    controller: deadlineController,
                    readOnly: true, // Ngăn người dùng tự nhập
                    decoration: const InputDecoration(
                      labelText: 'Chọn Deadline',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now(), // Không cho chọn ngày trong quá khứ
                        lastDate: DateTime(2100), // Ngày cuối cùng có thể chọn
                      );
                      if (pickedDate != null) {
                        // Format và hiển thị ngày chọn trong TextField
                        deadlineController.text = pickedDate
                            .toLocal()
                            .toString()
                            .split(' ')[0]; // Format YYYY-MM-DD
                        selectedDeadline = pickedDate; // Lưu lại DateTime chọn
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
            TextButton(
              onPressed: () async {
                if (selectedTechnicianId == null ||
                    selectedTechnicianName == null ||
                    selectedDeadline == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Vui lòng chọn kỹ thuật viên và deadline')),
                  );
                  return;
                }
                try {
                  // Gọi phương thức phân công với DateTime
                  await _controller.assignTask(
                    technicianId: selectedTechnicianId!,
                    technicianName: selectedTechnicianName!,
                    issueId: issue.id,
                    deadline: selectedDeadline!, // Truyền DateTime vào đây
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Phân công thành công')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Phân công thất bại')),
                  );
                }
              },
              child: const Text('Phân công'),
            ),
          ],
        );
      },
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Không thể tải danh sách kỹ thuật viên')),
    );
  }
}
