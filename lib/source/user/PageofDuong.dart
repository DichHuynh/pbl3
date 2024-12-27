// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Hệ thống Báo cáo Sự cố Giao thông',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.grey[100],
//       ),
//       initialRoute: '/',
//       routes: {
//         '/trackProgress': (context) => const TrackProgressScreen(),
//         '/feedback': (context) => const FeedbackScreen(),
//         '/trafficInfo': (context) => const TrafficInfoScreen(),
//       },
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Hệ thống Báo cáo Sự cố Giao thông')),
//         body: const Center(child: Text('Trang chủ')),
//       ),
//     );
//   }
// }

// // ------------------ Trang Theo dõi tiến trình xử lý sự cố ------------------
// class TrackProgressScreen extends StatelessWidget {
//   const TrackProgressScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Theo dõi Tiến trình Xử lý')),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16.0),
//         itemCount: 5, // Giả sử có 5 sự cố đã báo
//         itemBuilder: (context, index) {
//           return Card(
//             child: ListTile(
//               title: Text('Sự cố $index'),
//               subtitle: const Text('Trạng thái: Đang xử lý'),
//               trailing: const Icon(Icons.assignment, color: Colors.blue),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // ------------------ Trang Gửi phản hồi ------------------
// class FeedbackScreen extends StatelessWidget {
//   const FeedbackScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Phản hồi về chất lượng xử lý')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const Text('Đánh giá chất lượng xử lý sự cố của bạn:'),
//             const SizedBox(height: 16),
//             StatefulBuilder(
//               builder: (context, setState) {
//                 int selectedStars = 0;
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(5, (index) {
//                     return IconButton(
//                       onPressed: () {
//                         setState(() {
//                           selectedStars = index + 1;
//                         });
//                       },
//                       icon: Icon(
//                         index < selectedStars
//                             ? Icons.star
//                             : Icons.star_border,
//                         color: Colors.yellow,
//                       ),
//                     );
//                   }),
//                 );
//               },
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               decoration: const InputDecoration(
//                 labelText: 'Ghi chú (tùy chọn)',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 3,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 // Gửi phản hồi
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Phản hồi của bạn đã được gửi.')),
//                 );
//               },
//               child: const Text('Gửi Phản hồi'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ------------------ Trang Thông tin cơ sở hạ tầng giao thông ------------------
// class TrafficInfoScreen extends StatelessWidget {
//   const TrafficInfoScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Cơ sở hạ tầng Giao thông')),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16.0),
//         itemCount: 5, // Giả sử có 5 cơ sở hạ tầng giao thông
//         itemBuilder: (context, index) {
//           return Card(
//             child: ListTile(
//               title: Text('Cơ sở hạ tầng $index'),
//               subtitle: Text('Mô tả cơ sở hạ tầng $index'),
//               trailing: const Icon(Icons.info, color: Colors.blue),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
