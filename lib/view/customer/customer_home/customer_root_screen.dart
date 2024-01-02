import 'package:flutter/material.dart';
import 'package:three_tapp_app/view/common_view/chat/chat_page.dart';
import 'package:three_tapp_app/view/common_view/chat/chat_screen.dart';

import '../blogs/blogs_screen.dart';
import 'customer_home_screen.dart';

class CustomerRootScreen extends StatefulWidget {
  const CustomerRootScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CustomerRootScreen();
}

class _CustomerRootScreen extends State<CustomerRootScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    CustomerHomeScreen(),
    BlogsScreen(),
    ChatScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void reloadView() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.note_rounded),
              label: 'Bài viết',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.note_rounded),
              label: 'Chats',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.lightBlue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
