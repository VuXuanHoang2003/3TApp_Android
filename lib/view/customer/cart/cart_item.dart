import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:three_tapp_app/main.dart';
import 'package:three_tapp_app/model/my_order.dart';
import 'package:three_tapp_app/model/order_status.dart';
import 'package:three_tapp_app/utils/common_func.dart';
import 'package:three_tapp_app/utils/image_path.dart';
import 'package:three_tapp_app/view/common_view/details_order_screen.dart';
import 'package:three_tapp_app/view/customer/order/edit_order_screen.dart';
import 'package:three_tapp_app/viewmodel/order_viewmodel.dart';

class CartItem extends StatefulWidget {
  MyOrder order;

  CartItem({required this.order});

  @override
  State<StatefulWidget> createState() => _OrderItem();
}

class _OrderItem extends State<CartItem> {
  OrderViewModel orderViewModel = OrderViewModel();

  void goToOrderDetailsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailsOrderScreen(order: widget.order)),
    );
  }

  // showDialogChangeOrderStatus() {
  //   Widget newButton = TextButton(
  //     child: const Text("Mới tạo"),
  //     onPressed: () async {
  //       await orderViewModel.updateOrderStatus(
  //           orderId: widget.order.id,
  //           newStatus: OrderStatus.NEW.toShortString());
  //       Navigator.of(context).pop();
  //     },
  //   );
  //   Widget processButton = TextButton(
  //     child: const Text("Đang xử lý"),
  //     onPressed: () async {
  //       await orderViewModel.updateOrderStatus(
  //           orderId: widget.order.id,
  //           newStatus: OrderStatus.PROCESSING.toShortString());
  //       Navigator.of(context).pop();
  //     },
  //   );
  
  //   Widget doneButton = TextButton(
  //     child: const Text("Đã xong"),
  //     onPressed: () async {
  //       await orderViewModel.updateOrderStatus(
  //           orderId: widget.order.id,
  //           newStatus: OrderStatus.DONE.toShortString());
  //       Navigator.of(context).pop();
  //     },
  //   );
  
  //   Widget cancelButton = TextButton(
  //     child: Text("Huỷ đơn"),
  //     onPressed: () async {
  //       await orderViewModel.updateOrderStatus(
  //           orderId: widget.order.id,
  //           newStatus: OrderStatus.CANCEL.toShortString());
  //       Navigator.of(context).pop();
  //     },
  //   );
  
  //   AlertDialog alert = AlertDialog(
  //     actionsOverflowAlignment: OverflowBarAlignment.start,
  //     content: const Text("Chọn trạng thái?", textAlign: TextAlign.center),
  //     actions: [newButton, processButton, doneButton, cancelButton],
  //   );
  
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        goToOrderDetailsScreen();
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
        elevation: 16,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0x0D000000), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        shadowColor: const Color(0x33333333),
        child: Container(
          padding: const EdgeInsets.all(8),
          height: 140, // Đã thay đổi chiều cao của container
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.white10,
                spreadRadius: 0,
                blurRadius: 12.0,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: productItemImage(),
                ),
              ),
              const SizedBox(width: 8), // Thêm khoảng cách giữa hình ảnh và nội dung
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.order.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formatCurrency.format(widget.order.productPrice),
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      "Số lượng: ${widget.order.productQuantity}",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Khách hàng: ${widget.order.customerName}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      "Ngày tạo: ${widget.order.createDate}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          "Trạng thái: ",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          CommonFunc.getOrderStatusName(widget.order.status),
                          style: TextStyle(
                            color: CommonFunc.getOrderStatusColor(widget.order.status),
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: widget.order.status == OrderStatus.NEW.toShortString(),
                child: SizedBox(
                  width: 100,
                  child: TextButton(
                    onPressed: goToEditOrderScreen,
                    child: const Text(
                      "Chỉnh sửa",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void goToEditOrderScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditOrderScreen(order: widget.order)),
    );
  }

  Widget productItemImage() {
    if (widget.order.productImage.isNotEmpty) {
      return FutureBuilder<String>(
        future: getFirstImageUrl(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Container(
              width: 120, // Định nghĩa chiều rộng của container
              height: 120, // Định nghĩa chiều cao của container
              child: Image.network(
                snapshot.data ?? '', // Use imageUrl here
                fit: BoxFit
                    .cover, // Đảm bảo hình ảnh phù hợp với kích thước của container
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
            );
          }
        },
      );
    } else {
      return Image.asset(
        ImagePath.imgImageUpload,
        width: 120,
        height: 120,
      );
    }
  }

  Future<String> getFirstImageUrl() async {
    try {
      ListResult result =
          await FirebaseStorage.instance.ref(widget.order.productImage).list();
      if (result.items.isNotEmpty) {
        return await result.items[0].getDownloadURL();
      }
    } catch (e) {
      print('Error getting first image URL: $e');
    }
    return ''; // Trả về chuỗi rỗng nếu không tìm thấy ảnh
  }
}
