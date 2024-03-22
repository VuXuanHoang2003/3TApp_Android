import 'package:flutter/material.dart';
import 'package:three_tapp_app/model/product.dart';
import 'package:three_tapp_app/utils/common_func.dart';
import 'package:three_tapp_app/view/common_view/product_details_screen.dart';
import 'package:three_tapp_app/view/customer/order/confirm_order_screen.dart';
import 'package:three_tapp_app/viewmodel/order_per_person_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderPerPersonScreen extends StatefulWidget {
  final String address;

  const OrderPerPersonScreen({Key? key, required this.address})
      : super(key: key);

  @override
  _OrderPerPersonScreenState createState() => _OrderPerPersonScreenState();
}

class _OrderPerPersonScreenState extends State<OrderPerPersonScreen> {
  late final OrderPerPersonViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = OrderPerPersonViewModel(address: widget.address);
    _viewModel.loadData();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${AppLocalizations.of(context)?.product} ${AppLocalizations.of(context)?.oF} ${widget.address}',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<List<Product>>(
        stream: _viewModel.ordersStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildContent(snapshot.data!, _viewModel.userData);
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.red)),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildContent(List<Product> orders, Map<String, dynamic> userData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              '${AppLocalizations.of(context)?.info} ${AppLocalizations.of(context)?.user}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          _buildUserInfoRow('${AppLocalizations.of(context)?.customerName}:',
              userData['username']),
          _buildUserInfoRow('Email:', userData['email']),
          _buildUserInfoRow('${AppLocalizations.of(context)?.phoneNumber}:',
              userData['phone']),
          _buildUserInfoRow(
              '${AppLocalizations.of(context)?.address}:', widget.address),
          SizedBox(height: 20),
          Text('${AppLocalizations.of(context)?.orders}:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          _buildOrdersList(orders),
        ],
      ),
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Row(
      children: [
        Text('$label ', style: TextStyle(fontSize: 18)),
        Expanded(
          child: Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }


Widget _buildOrdersList(List<Product> orders) {
  if (orders.isEmpty) {
    return Text('Người dùng này không có đơn hàng nào', style: TextStyle(fontSize: 18));
  }
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: orders.length,
    itemBuilder: (context, index) {
      final order = orders[index];
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: order)),
          );
        },
        child: Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sản phẩm: ${order.name}', style: TextStyle(fontSize: 18, color: Colors.red)),
                SizedBox(height: 4),
                Text('Khối lượng: ${order.mass} kg', style: TextStyle(fontSize: 16)),
                Text('Loại: ${CommonFunc.getSenDaNameByType(context,order.type)}', style: TextStyle(fontSize: 16)),
                Text('Giá: ${order.price} vnd', style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ConfirmOrderScreen(product: order)),
                    );
                  },
                  child: Text('Mua', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
}
