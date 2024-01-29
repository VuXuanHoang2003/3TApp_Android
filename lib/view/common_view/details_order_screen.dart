import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../../utils/common_func.dart';
import '../../../utils/image_path.dart';
import '../../main.dart';
import '../../model/my_order.dart';
import '../../viewmodel/order_viewmodel.dart';

class DetailsOrderScreen extends StatefulWidget {
  MyOrder order;

  DetailsOrderScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<DetailsOrderScreen> createState() => _DetailsOrderScreenState();
}

class _DetailsOrderScreenState extends State<DetailsOrderScreen> {
  OrderViewModel orderViewModel = OrderViewModel();
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    getAllImageUrls();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reloadView();
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Chi tiết hoá đơn",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
            size: 20,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Thông tin đơn hàng",
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Divider(
              thickness: 1.0,
              color: Colors.grey[300],
              height: 24,
            ),
            orderDetail(),
            SizedBox(height: 32),
            Text(
              "Thông tin liên hệ",
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Divider(
              thickness: 1.0,
              color: Colors.grey[300],
              height: 24,
            ),
            contactInfo(),
          ],
        ),
      ),
    ),
  );
}

Widget orderDetail() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: productItemImage(),
        ),
      ),
      SizedBox(height: 16),
      Text("Tên sản phẩm: ${widget.order.productName}",
        style: TextStyle(color: Colors.black, fontSize: 14),
      ),
      Text(
        formatCurrency.format(widget.order.productPrice),
        style: TextStyle(color: Colors.redAccent, fontSize: 14, fontStyle: FontStyle.italic),
      ),
      Text(
        "Số lượng: ${widget.order.productQuantity}",
        style: TextStyle(color: Colors.blue, fontSize: 14, fontStyle: FontStyle.italic),
      ),
      Text(
        "Trạng thái: ${CommonFunc.getOrderStatusName(widget.order.status)}",
        style: TextStyle(color: Colors.black, fontSize: 14, fontStyle: FontStyle.italic),
      ),
    ],
  );
}

Widget contactInfo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildContactInfoRow("Khách hàng:", widget.order.customerName),
      buildContactInfoRow("Email:", widget.order.customerEmail),
      buildContactInfoRow("Số điện thoại:", widget.order.phoneNumber),
      buildContactInfoRow("Địa chỉ:", widget.order.address),
      SizedBox(height: 32),
    ],
  );
}

Widget buildContactInfoRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.black, fontSize: 14, fontStyle: FontStyle.italic),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.blueAccent, fontSize: 14, fontStyle: FontStyle.italic),
          ),
        ),
      ],
    ),
  );
}

  void showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Image.network(imageUrl),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
   Widget productItemImage() {
    if (imageUrls.isNotEmpty) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: imageUrls.map((imageUrl) {
            return GestureDetector(
              onTap: () {
                showImageDialog(context, imageUrl);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
        ),
      );
    } else {
      return Image.asset(
        ImagePath.imgImageUpload,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    }
  }

  void getAllImageUrls() async {
    try {
      ListResult result = await FirebaseStorage.instance.ref(widget.order.productImage).listAll();
      List<String> urls = [];
      for (Reference ref in result.items) {
        String url = await ref.getDownloadURL();
        urls.add(url);
      }
      setState(() {
        imageUrls = urls;
      });
    } catch (e) {
      print('Error getting image URLs: $e');
    }
  }

}
