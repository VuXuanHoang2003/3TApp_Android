//Trang để thay đổi ngôn ngữ được chuyển hướng từ file profile_screen_root.dart
import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ngôn ngữ'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tiếng Việt'),
                Icon(Icons.check),
              ],
            ),
            onTap: () {
              // Add your onTap logic here
              
            },
          ),
        ],
      ),
    );
  }
}
              