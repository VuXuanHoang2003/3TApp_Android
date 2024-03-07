import 'package:flutter/material.dart';
import 'package:three_tapp_app/model/product.dart';
import 'package:three_tapp_app/viewmodel/order_per_person_view_model.dart';
import 'package:three_tapp_app/view/common_view/product_details_screen.dart';

class OrderPerPersonScreen extends StatefulWidget {
  final String address;

  const OrderPerPersonScreen({Key? key, required this.address}) : super(key: key);

  @override
  _OrderPerPersonScreenState createState() => _OrderPerPersonScreenState();
}

class _OrderPerPersonScreenState extends State<OrderPerPersonScreen> {
  late OrderPerPersonViewModel _viewModel;

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
        title: Text('Đơn hàng của ${widget.address}', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<List<Product>>(
        stream: _viewModel.ordersStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildContent(snapshot.data!);
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildContent(List<Product> orders) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thông tin người dùng:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          // Đưa thông tin người dùng vào đây nếu cần thiết
          SizedBox(height: 20),
          Text('Đơn hàng:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          _buildOrdersList(orders),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<Product> orders) {
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
                  //Text('Khối lượng: ${order.mass} kg', style: TextStyle(fontSize: 16)),
                  Text('Loại: ${order.type}', style: TextStyle(fontSize: 16)),
                  Text('Giá: ${order.price} vnd', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
