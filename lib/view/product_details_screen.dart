import 'package:flutter/material.dart';
import 'package:three_tapp_app/view/common_view/product_details_screen.dart';
import '../../../model/product.dart';
import 'product_details_screen.dart'; // Import the ProductDetailsScreen

class ProductListScreen extends StatelessWidget {
  final List<Product> products;

  ProductListScreen({required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách đơn hàng'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              products[index].name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price: ${products[index].price}',
                  style: const TextStyle(fontSize: 14, color: Colors.redAccent),
                ),
                Text(
                  'Type: ${getSenDaNameByType(products[index].type)}',
                  style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
                // Add more details as needed
              ],
            ),
            onTap: () {
              navigateToProductDetails(context, products[index]);
            },
          );
        },
      ),
    );
  }

  void navigateToProductDetails(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(product: product),
      ),
    );
  }

  String getSenDaNameByType(String type) {
    // Implement your logic to convert type to SenDa name
    return type; // Placeholder, replace with your implementation
  }
}
