// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:pbl3/source/user/report.dart';
// import 'package:flutter/cupertino.dart';

// void main() async {
//   runApp(const Page());
// }

// class Page extends StatelessWidget {
//   const Page({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Hệ thống thông tin cơ sở hạ tầng',
//       home: IssuePage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class IssuePage extends StatefulWidget {
//   const IssuePage({super.key});
//   @override
//   _IssueState createState() => _IssueState();
// }

// class _IssueState extends State<IssuePage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Các sự cố hạ tầng',
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.blue,
//         elevation: 1.0,
//       ),
//       body: Column(
//         children: [
//           // Nút hành động
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment:
//                   MainAxisAlignment.spaceBetween, // Để khoảng cách giữa các nút
//               children: [
//                 Expanded(
//                   // Sử dụng Expanded để các nút chạy hết chiều ngang của màn hình
//                   child: CupertinoButton(
//                     padding: EdgeInsets.zero,
//                     color: Color(0xFFF3EFFF),
//                     borderRadius: BorderRadius.circular(20),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: const [
//                         Icon(
//                           CupertinoIcons
//                               .checkmark_seal_fill, // Biểu tượng check
//                           size: 18,
//                           color: Color(0xFF7C4DFF), // Màu tím đậm
//                         ),
//                         SizedBox(width: 8),
//                         Text(
//                           'Xác minh thông tin',
//                           style: TextStyle(
//                             color: Color(0xFF7C4DFF), // Màu tím đậm
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                     onPressed: () {},
//                   ),
//                 ),
//                 SizedBox(width: 10), // Khoảng cách giữa các nút
//                 Expanded(
//                   // Sử dụng Expanded để các nút chạy hết chiều ngang của màn hình
//                   child: CupertinoButton(
//                     padding: EdgeInsets.zero,
//                     color: Color(0xFFF3EFFF),
//                     borderRadius: BorderRadius.circular(20),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: const [
//                         Icon(
//                           CupertinoIcons
//                               .bolt_horizontal_circle_fill, // Verified
//                           size: 18,
//                           color: Color(0xFF7C4DFF), // Màu tím đậm
//                         ),
//                         SizedBox(width: 8),
//                         Text(
//                           'Ứng cứu khẩn cấp',
//                           style: TextStyle(
//                             color: Color(0xFF7C4DFF), // Màu tím đậm
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                     onPressed: () {},
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Tìm kiếm và danh mục
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 CupertinoButton(
//                   color: const Color.fromARGB(255, 245, 240, 197),
//                   borderRadius: BorderRadius.circular(8.0), 
//                   padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
//                   onPressed: () {},
//                   child: const Text(
//                     "Tìm kiếm",
//                     style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Các tab "Tiêu biểu", "Đã xử lý", "Đang xử lý"
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 10.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 CupertinoButton(
//                   onPressed: () {},
//                   child: const Text("Tiêu biểu"),
//                 ),
//                 CupertinoButton(
//                   onPressed: () {},
//                   child: const Text("Đã xử lý"),
//                 ),
//                 CupertinoButton(
//                   onPressed: () {},
//                   child: const Text("Đang xử lý"),
//                 ),
//               ],
//             ),
//           ),
//           // Danh sách phản ánh
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _firestore.collection('issues').snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return const Center(child: Text('Có lỗi xảy ra'));
//                 }
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text('Không có dữ liệu sự cố'));
//                 }

//                 final reports = snapshot.data!.docs;

//                 return ListView.builder(
//                   itemCount: reports.length,
//                   itemBuilder: (context, index) {
//                     final report =
//                         reports[index].data() as Map<String, dynamic>;

//                     // Lấy các trường từ Firestore
//                     final description =
//                         report['description'] ?? 'Không có mô tả';
//                     final imageUrl = report['imageUrl'] ??
//                         "https://via.placeholder.com/150"; // Ảnh mặc định nếu không có
//                     final location = report['location'] ?? 'Không có vị trí';
//                     final reportDate = report['reportDate'] != null
//                         ? (report['reportDate'] as Timestamp).toDate()
//                         : null;
//                     final resolutionDate = report['resolutionDate'] != null
//                         ? (report['resolutionDate'] as Timestamp).toDate()
//                         : null;
//                     final status = report['status'] ?? 'Không có trạng thái';

//                     return Card(
//                       margin: const EdgeInsets.all(8.0),
//                       child: ListTile(
//                         isThreeLine: true,
//                         leading: ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.network(
//                             imageUrl,
//                             width: 50,
//                             height: 50,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return const Icon(Icons.broken_image, size: 50);
//                             },
//                           ),
//                         ),
//                         title: Text(
//                           description,
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Vị trí: $location"),
//                             if (reportDate != null)
//                               Text("Ngày báo cáo: ${reportDate.toLocal()}"),
//                             if (resolutionDate != null)
//                               Text("Ngày xử lý: ${resolutionDate.toLocal()}"),
//                           ],
//                         ),
//                         trailing: Text(
//                           status,
//                           style: TextStyle(
//                             color: status == "Đã xử lý"
//                                 ? Colors.green
//                                 : Colors.red,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: Container(
//         margin: const EdgeInsets.only(
//             bottom: 16.0), // Để căn chỉnh nút với mép dưới
//         // Đoạn này để căn chỉnh kích thước cho tối đa 60 pixels
//         child: SizedBox(
//           width: 100, // Đặt chiều rộng tùy chỉnh cho nút
//           height: 40, // Đặt chiều cao tùy chỉnh cho nút
//           child: CupertinoButton(
//             color: Colors.yellow, // Màu nền của nút
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             borderRadius: BorderRadius.circular(20.0), // Bo góc tương tự FAB
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const ReportIssuePage()),
//               );
//             },
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center, // Căn giữa nội dung
//               children: const [
//                 Icon(
//                   CupertinoIcons.add, 
//                   size: 18,
//                   color: Colors.black, 
//                 ),
//                 SizedBox(width: 2), // Khoảng cách giữa biểu tượng và văn bản
//                 Text(
//                   "Báo cáo",
//                   style: TextStyle(fontSize: 14, color: Colors.black,
//                                     fontWeight: FontWeight.bold,),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       floatingActionButtonLocation:
//           FloatingActionButtonLocation.endFloat, // Đặt nút ở phía dưới bên phải
//       // Đặt nút ở phía dưới bên phải
//       // Đặt nút ở phía dưới bên phải
//     );
//   }
// }
