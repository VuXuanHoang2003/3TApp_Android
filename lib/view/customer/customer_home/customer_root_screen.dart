import 'package:flutter/material.dart';
import 'package:three_tapp_app/view/common_view/chat/chat_screen.dart';
import 'package:three_tapp_app/view/common_view/map/home_map_view.dart';
import '../blogs/blogs_screen.dart';
import 'customer_home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
    ChatScreen(),
    MapSample(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '${AppLocalizations.of(context)?.home}',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.note_rounded),
              label: '${AppLocalizations.of(context)?.postPage}',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_rounded),
              label: '${AppLocalizations.of(context)?.chat}',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_rounded),
              label: '${AppLocalizations.of(context)?.map}',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.black, // Màu của các phần chưa được chọn
          backgroundColor: Colors.white, // Màu nền của BottomNavigationBar
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
