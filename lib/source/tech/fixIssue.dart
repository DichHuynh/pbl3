import 'package:flutter/material.dart';
import 'package:pbl3/source/tech/techHome.dart';
import 'package:flutter/cupertino.dart';

class Page extends StatelessWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp( // ??? not yet understand this line but will comeback later
      title: 'Hệ thống thông tin cơ sở hạ tầng',
      home: TechHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class IssueListPage extends StatelessWidget {
  const IssueListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
      
  }

}

class ReportIssue extends StatelessWidget {
  const ReportIssue({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
      
  }

}

class TechInfo extends StatelessWidget {
  const TechInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
      
  }

}



class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
      
  }

}