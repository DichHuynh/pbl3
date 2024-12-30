import 'package:flutter/material.dart';
import 'package:pbl3/source/admin/controller/issue_controller.dart';
import 'package:pbl3/source/admin/model/issue_model.dart';

class CompletedTask extends StatelessWidget {
  final _controller = IssueController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Issue>>(
        future: _controller.getCompletedIssues(),
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
                          _evaluated(context, issue);
                        },
                        child: const Text('Đánh giá'),
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

  Widget evaluationHighlight({required Evaluation evaluation}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4), // Shadow position
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Đánh giá công việc',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.star, color: Colors.orangeAccent, size: 20),
              const SizedBox(width: 8),
              Text(
                'Chất lượng: ${evaluation.qualityRating.toStringAsFixed(1)}/5',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.timer, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Text(
                'Thời gian: ${evaluation.timeRating.toStringAsFixed(1)}/5',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.comment, color: Colors.blueAccent, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Nhận xét: ${evaluation.comment}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Cập nhật lúc: ${evaluation.updatedAt != null ? evaluation.updatedAt!.toLocal().toString().substring(0, 19) : 'Không xác định'}',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _evaluated(BuildContext context, Issue issue) async {
    final _qualityRatingController = ValueNotifier<double>(0);
    final _timeRatingController = ValueNotifier<double>(0);
    final _commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Đánh giá công việc'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Đánh giá chất lượng'),
              ValueListenableBuilder<double>(
                valueListenable: _qualityRatingController,
                builder: (context, value, child) {
                  return Slider(
                    value: value,
                    min: 0,
                    max: 5,
                    divisions: 5,
                    label: value.toStringAsFixed(1),
                    onChanged: (newValue) {
                      _qualityRatingController.value = newValue;
                    },
                  );
                },
              ),
              const Text('Đánh giá thời gian'),
              ValueListenableBuilder<double>(
                valueListenable: _timeRatingController,
                builder: (context, value, child) {
                  return Slider(
                    value: value,
                    min: 0,
                    max: 5,
                    divisions: 5,
                    label: value.toStringAsFixed(1),
                    onChanged: (newValue) {
                      _timeRatingController.value = newValue;
                    },
                  );
                },
              ),
              const Text('Nhận xét'),
              TextField(
                controller: _commentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nhập nhận xét của bạn...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final qualityRating = _qualityRatingController.value;
                final timeRating = _timeRatingController.value;
                final comment = _commentController.text;

                try {
                  final controller = IssueController();
                  await controller.updateIssueEvaluation(
                    issueId: issue.id,
                    qualityRating: qualityRating,
                    timeRating: timeRating,
                    comment: comment,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đánh giá thành công!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: ${e.toString()}')),
                  );
                }

                Navigator.of(context).pop();
              },
              child: const Text('Gửi'),
            ),
          ],
        );
      },
    );
  }
}
