import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../model/my_order.dart';
import '../../../model/order_status.dart';
import '../../../model/product.dart';
import '../../../utils/common_func.dart';
import '../../../utils/image_path.dart';
import '../../../viewmodel/order_viewmodel.dart';
import '../../common_view/custom_button.dart';

class ConfirmOrderScreen extends StatefulWidget {
  final Product product;

  ConfirmOrderScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  OrderViewModel orderViewModel = OrderViewModel();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  FocusNode customerNameFocusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  int orderQuantity = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      reloadView();
    });
  }

  void reloadView() {
    setState(() {});
  }

  void incrementQuantity() {
    setState(() {
      orderQuantity += 1;
    });
  }

  void decrementQuantity() {
    if (orderQuantity > 1) {
      setState(() {
        orderQuantity -= 1;
      });
    }
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
          title: const Text(
            "Xác nhận yêu cầu",
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
              size: 20,
            ),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Thông tin đơn hàng",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                const Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                  height: 16,
                ),
                orderDetail(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        decrementQuantity();
                      },
                      child: const Icon(Icons.remove_circle_outline_outlined),
                    ),
                    Text(
                      "$orderQuantity",
                      style: const TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        incrementQuantity();
                      },
                      child: const Icon(Icons.add_circle_outline_outlined),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 8)),
                const Text(
                  "Thông tin liên hệ",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                const Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                  height: 16,
                ),
                contactInfo(),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: CustomButton(
                      onPressed: () {
                        String customerName =
                            customerNameController.text.toString().trim();
                        String phoneNumber =
                            phoneNumberController.text.toString().trim();
                        String address =
                            addressController.text.toString().trim();

                        if (customerName.isNotEmpty &&
                            phoneNumber.isNotEmpty &&
                            address.isNotEmpty) {
                          MyOrder order = MyOrder(
                            id: UniqueKey().toString(),
                            productImage: widget.product.image,
                            productName: widget.product.name,
                            productPrice: widget.product.price,
                            productQuantity: orderQuantity,
                            customerName: customerName,
                            customerEmail: FirebaseAuth
                                    .instance.currentUser?.email ??
                                '',
                            phoneNumber: phoneNumber,
                            address: address,
                            status: OrderStatus.NEW.toShortString(),
                            createDate: DateTime.now().toString(),
                            updateDate: DateTime.now().toString(),
                          );
                          orderViewModel.createOrder(order: order);
                          Navigator.of(context).pop();
                        } else {
                          CommonFunc.showToast("Vui lòng nhập đủ thông tin.");
                        }
                      },
                      text: 'Tạo giao dịch',
                      textColor: Colors.white,
                      bgColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget orderDetail() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: productItemImage(),
          ),
        ),
        const SizedBox(height: 20), // Khoảng cách giữa ảnh và tên sản phẩm
        Text(
          "Tên sản phẩm: ${widget.product.name}",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4), // Khoảng cách giữa tên sản phẩm và giá
        Text(
          formatCurrency.format(widget.product.price),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.redAccent,
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 4), // Khoảng cách giữa giá và thể loại
        Text(
          "Thể loại: ${CommonFunc.getSenDaNameByType(widget.product.type)}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget contactInfo() {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 16)),
          TextFormField(
            controller: customerNameController,
            focusNode: customerNameFocusNode,
            keyboardType: TextInputType.text,
            validator: (input) {
              if (input!.isNotEmpty) {
                return null;
              } else {
                return "Tên khách hàng không hợp lệ";
              }
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              labelText: "Tên khách hàng (Bắt buộc)",
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.redAccent, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.redAccent, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 16)),
          TextFormField(
            controller: phoneNumberController,
            focusNode: phoneNumberFocusNode,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              labelText: "Số điện thoại (Bắt buộc)",
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 16)),
          TextFormField(
            controller: addressController,
            focusNode: addressFocusNode,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              labelText: "Địa chỉ (Bắt buộc)",
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 32)),
        ],
      ),
    );
  }

  Widget productItemImage() {
    if (widget.product.image.isNotEmpty) {
      return FutureBuilder<List<String>>(
        future: getImageUrls(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<String> imageUrls = snapshot.data ?? [];
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 8.0, // Khoảng cách giữa các ảnh
                runSpacing: 8.0, // Khoảng cách giữa các dòng
                children: imageUrls.map((imageUrl) {
                  return GestureDetector(
                    onTap: () {
                      showImageDialog(context, imageUrl);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Image.network(
                        imageUrl,
                        height: 120,
                        width: 120,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }
        },
      );
    } else {
      return Image.asset(
        ImagePath.imgImageUpload,
        height: 120,
        width: 120,
      );
    }
  }

  Future<List<String>> getImageUrls() async {
    try {
      ListResult result =
          await FirebaseStorage.instance.ref(widget.product.image).list();
      List<String> urls = [];
      for (Reference ref in result.items) {
        String url = await ref.getDownloadURL();
        urls.add(url);
      }
      return urls;
    } catch (e) {
      print('Error getting image URLs: $e');
      return [];
    }
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
}
