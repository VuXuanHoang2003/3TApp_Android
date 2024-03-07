import 'package:flutter/material.dart';
import 'package:three_tapp_app/model/product.dart';
import 'package:three_tapp_app/view/common_view/product_item_customer_view.dart';

class ProductListScreen extends StatelessWidget {
  final String category;
  final List<Product> products;

  ProductListScreen({required this.category, required this.products});

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        '$category - Danh sách sản phẩm',
        style: TextStyle(fontSize: 15.0),
      ),
    ),
    body: buildProductList(context),
  );
}


 Widget buildProductList(BuildContext context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.3,
    child: Row(
      children: [
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductItemCustomerView(product: products[index]);
            },
          ),
        ),
      ],
    ),
  );
}
}