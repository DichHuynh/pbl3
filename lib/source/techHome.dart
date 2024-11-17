import 'package:flutter/material.dart';

class TechHomePage extends StatefulWidget {
  const TechHomePage({super.key});

  @override
  _TechHomePageState createState() => _TechHomePageState();
}

class _TechHomePageState extends State<TechHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ Tech'),
        backgroundColor: Colors.blue, // Màu nền cho AppBar (có thể thay đổi)
      ),
      body: Center(
        child: const Text(
          'Trang chủ',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}