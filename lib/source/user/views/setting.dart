import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pbl3/source/login%20signup/login.dart'; // Import màn hình đăng nhập

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false; // Để lưu trữ trạng thái chế độ tối/sáng
  bool notificationsEnabled = true; // Để lưu trữ trạng thái thông báo
  double fontSize = 16.0; // Kích thước font chữ
  String selectedLanguage = 'vi'; // Mặc định là tiếng Việt

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Hàm tải các cài đặt từ SharedPreferences
  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      fontSize = prefs.getDouble('fontSize') ?? 16.0;
      selectedLanguage = prefs.getString('selectedLanguage') ?? 'vi';
    });
  }

  // Hàm lưu cài đặt vào SharedPreferences
  void _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
    prefs.setBool('notificationsEnabled', notificationsEnabled);
    prefs.setDouble('fontSize', fontSize);
    prefs.setString('selectedLanguage', selectedLanguage);
  }

  // Hàm để đăng xuất
  void _logout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xác nhận đăng xuất'),
          content: Text('Bạn chắc chắn muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                // Đăng xuất khỏi Firebase
                FirebaseAuth.instance.signOut();
                // Chuyển hướng về màn hình đăng nhập
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }

  // Hàm thay đổi ngôn ngữ
  void _changeLanguage(String languageCode) {
    setState(() {
      selectedLanguage = languageCode;
    });
    // Lưu ngôn ngữ vào SharedPreferences
    _saveSettings();
    // Áp dụng ngôn ngữ cho ứng dụng (cần cài đặt localization)
    // Chỉ cần cập nhật trạng thái, Flutter sẽ tự động thay đổi ngôn ngữ nếu đã cấu hình localization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Cài đặt giao diện
            ListTile(
              title: Text('Chế độ giao diện'),
              subtitle: Text(isDarkMode ? 'Chế độ tối' : 'Chế độ sáng'),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                  _saveSettings();
                },
              ),
            ),

            // Cài đặt thông báo
            ListTile(
              title: Text('Nhận thông báo'),
              subtitle: Text(notificationsEnabled ? 'Bật' : 'Tắt'),
              trailing: Switch(
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                  _saveSettings();
                },
              ),
            ),

            // Cài đặt kích thước chữ
            ListTile(
              title: Text('Kích thước chữ'),
              subtitle:
                  Text('Kích thước hiện tại: ${fontSize.toStringAsFixed(1)}'),
              trailing: IconButton(
                icon: Icon(Icons.text_fields),
                onPressed: () {
                  // Mở dialog thay đổi kích thước chữ
                  _showFontSizeDialog();
                },
              ),
            ),

            // Cài đặt ngôn ngữ
            ListTile(
              title: Text('Ngôn ngữ'),
              subtitle:
                  Text(selectedLanguage == 'vi' ? 'Tiếng Việt' : 'English'),
              trailing: Icon(Icons.language),
              onTap: () {
                // Hiển thị lựa chọn ngôn ngữ
                _showLanguageDialog();
              },
            ),

            // Cài đặt đăng xuất
            ListTile(
              title: Text('Đăng xuất'),
              leading: Icon(Icons.exit_to_app),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }

  // Hàm để mở dialog thay đổi kích thước chữ
  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chọn kích thước chữ'),
          content: Slider(
            value: fontSize,
            min: 12.0,
            max: 24.0,
            divisions: 12,
            label: fontSize.toStringAsFixed(1),
            onChanged: (newSize) {
              setState(() {
                fontSize = newSize;
              });
            },
          ),
          actions: [
            TextButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Hàm để mở dialog lựa chọn ngôn ngữ
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chọn ngôn ngữ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Tiếng Việt'),
                onTap: () {
                  _changeLanguage('vi');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('English'),
                onTap: () {
                  _changeLanguage('en');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
