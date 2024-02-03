import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:three_tapp_app/view/admin/product_management_screen.dart';
import 'package:three_tapp_app/view/admin/sales_management_screen.dart';
import 'package:three_tapp_app/view/admin/statistic_screen.dart';
import 'package:three_tapp_app/view/common_view/chat/chat_screen.dart';

import '../../utils/common_func.dart';
import '../customer/blogs/blogs_screen.dart';

class AdminRootScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AdminRootScreen();
}

class _AdminRootScreen extends State<AdminRootScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    ProductManagementScreen(),
    SalesManagementScreen(),
    BlogsScreen(),
    ChatScreen(),
    StatisticScreen(),
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
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(
              left: 0,
              top: MediaQuery.of(context).padding.top + 8,
              right: 0,
              bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        CommonFunc.goToProfileScreen();
                      },
                      icon: const Icon(
                        Icons.account_circle_rounded,
                        color: Colors.blue,
                      ))
                ],
              ),
              Expanded(child: _widgetOptions.elementAt(_selectedIndex)),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.production_quantity_limits,

                color: Colors.green,
                ),

              label: 'Sản phẩm',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.point_of_sale_rounded,

                color: Colors.green,
                ),
              label: 'Bán hàng',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.post_add_rounded,

                color: Colors.green,
                ),
              label: 'Bài viết',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.chat_rounded,
              
                color: Colors.green,
                ),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.book_rounded,
                  color: Colors.green,
                ),
                label: 'Thống kê')
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

