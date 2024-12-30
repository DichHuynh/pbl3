import 'package:flutter/material.dart';
import 'package:pbl3/source/admin/controller/issue_controller.dart';
import 'package:pbl3/source/admin/model/issue_model.dart';

class OverdueTask extends StatelessWidget {
  final _controller = IssueController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Issue>>(
        future: _controller.getOverdueIssues(),
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

          // Sắp xếp sự cố chưa đánh giá lên đầu
          issues.sort((a, b) {
            if (a.evaluation == null && b.evaluation != null) {
              return -1; // `a` chưa đánh giá => lên đầu
            } else if (a.evaluation != null && b.evaluation == null) {
              return 1; // `b` chưa đánh giá => lên đầu
            }
            return 0; // Giữ nguyên vị trí nếu cả hai đều giống nhau về đánh giá
          });

          return ListView.builder(
            itemCount: issues.length,
            itemBuilder: (context, index) {
              final issue = issues[index];

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          if (issue.resolutionDate != null)
                            Text(
                              "Ngày xử lý: ${issue.resolutionDate!.toLocal()}",
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          Text("Người xử lý: ${issue.techName}"),
                        ],
                      ),
                      trailing: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          issue.imageUrlAfter ?? '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 50);
                          },
                        ),
                      ),
                    ),
                    // Phần đánh giá có thể sổ ra
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
                                        softWrap: true, // Cho phép ngắt dòng
                                        overflow: TextOverflow
                                            .visible, // Hiển thị đầy đủ nội dung, không cắt bớt
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _assignTask(context, issue);
                        },
                        child: const Text('Phân công lại'),
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
        return AlertDialog(
          title: const Text('Phân công kỹ thuật viên'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                        deadlineController.text = pickedDate
                            .toString()
                            .split(' ')[0]; // Format YYYY-MM-DD
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
                    deadlineController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Vui lòng chọn kỹ thuật viên và deadline')),
                  );
                  return;
                }
                try {
                  await _controller.assignTask(
                    technicianId: selectedTechnicianId!,
                    technicianName: selectedTechnicianName!,
                    issueId: issue.id,
                    deadline: deadlineController.text,
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