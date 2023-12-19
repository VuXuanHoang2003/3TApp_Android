import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:three_tapp_app/view/common_view/order_item.dart';
import 'package:three_tapp_app/view/customer/cart/cart_item.dart';
import 'package:three_tapp_app/viewmodel/cart_viewmodel.dart';
import 'package:three_tapp_app/viewmodel/order_viewmodel.dart';

import '../../../model/status.dart';

class CartScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SalesManagementScreen();
}

class _SalesManagementScreen extends State<CartScreen> {
  // OrderViewModel orderViewModel = OrderViewModel();

  CartViewModel cartViewModel = CartViewModel();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await cartViewModel.getOrderByUser();
      cartViewModel.getOrderStream.listen((status) {
        if (status == Status.loading) {
        } else if (status == Status.completed) {
          if (mounted) {
            reloadView();
          }
        } else {}
      });
    });
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          leadingWidth: 24,
          leading: SizedBox(
            width: 32,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
          title: const Text(
            "Trở về trang chủ",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            top: 8,
          ),
          child: ContainedTabBarView(
            tabBarProperties: const TabBarProperties(
                height: 24,
                indicatorColor: Colors.blueAccent,
                labelStyle: TextStyle(color: Colors.black, fontSize: 12)),
            tabs: const [
              Text('Mới tạo', style: TextStyle(color: Colors.black)),
              Text('Chờ giao hàng', style: TextStyle(color: Colors.black)),
              Text('Đã giao', style: TextStyle(color: Colors.black)),
              Text('Đã huỷ', style: TextStyle(color: Colors.black))
            ],
            views: [
              newOrderTab(),
              processingOrderTab(),
              doneOrderTab(),
              cancelOrderTab()
            ],
            onChange: (index) => print(index),
          ),
        ),
      ),
    );
  }

  Widget newOrderTab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cartViewModel.newOrders.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: cartViewModel.newOrders.length,
                  itemBuilder: (context, index) {
                    return CartItem(order: cartViewModel.newOrders[index]);
                  },
                ),
              )
            : const Center(child: Text('Không có đơn hàng nào')),
      ],
    );
  }

  Widget processingOrderTab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cartViewModel.processingOrders.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: cartViewModel.processingOrders.length,
                  itemBuilder: (context, index) {
                    return CartItem(
                        order: cartViewModel.processingOrders[index]);
                  },
                ),
              )
            : const Center(child: Text('Không có đơn hàng nào')),
      ],
    );
  }

  Widget doneOrderTab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cartViewModel.doneOrders.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: cartViewModel.doneOrders.length,
                  itemBuilder: (context, index) {
                    return CartItem(order: cartViewModel.doneOrders[index]);
                  },
                ),
              )
            : const Center(child: Text('Không có đơn hàng nào')),
      ],
    );
  }

  Widget cancelOrderTab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cartViewModel.cancelOrders.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: cartViewModel.cancelOrders.length,
                  itemBuilder: (context, index) {
                    return CartItem(order: cartViewModel.cancelOrders[index]);
                  },
                ),
              )
            : const Center(child: Text('Không có đơn hàng nào')),
      ],
    );
  }
}
