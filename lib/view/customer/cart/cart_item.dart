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
  //
  //   Widget doneButton = TextButton(
  //     child: const Text("Đã xong"),
  //     onPressed: () async {
  //       await orderViewModel.updateOrderStatus(
  //           orderId: widget.order.id,
  //           newStatus: OrderStatus.DONE.toShortString());
  //       Navigator.of(context).pop();
  //     },
  //   );
  //
  //   Widget cancelButton = TextButton(
  //     child: Text("Huỷ đơn"),
  //     onPressed: () async {
  //       await orderViewModel.updateOrderStatus(
  //           orderId: widget.order.id,
  //           newStatus: OrderStatus.CANCEL.toShortString());
  //       Navigator.of(context).pop();
  //     },
  //   );
  //
  //   AlertDialog alert = AlertDialog(
  //     actionsOverflowAlignment: OverflowBarAlignment.start,
  //     content: const Text("Chọn trạng thái?", textAlign: TextAlign.center),
  //     actions: [newButton, processButton, doneButton, cancelButton],
  //   );
  //
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
        margin: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 0),
        elevation: 16,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0x0D000000), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        shadowColor: const Color(0x33333333),
        child: Container(
          padding: const EdgeInsets.all(4),
          height: 110,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  flex: 2,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: productItemImage())),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.order.productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      Text(
                        formatCurrency.format(widget.order.productPrice),
                        style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        "Số lượng:${widget.order.productQuantity}",
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontStyle: FontStyle.normal),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Khách hàng:${widget.order.customerName}",
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        "Ngày tạo:${widget.order.createDate}",
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                      Row(
                        children: [
                          const Text(
                            "Trạng thái: ",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          ),
                          Text(
                            CommonFunc.getOrderStatusName(widget.order.status),
                            style: TextStyle(
                                color: CommonFunc.getOrderStatusColor(
                                    widget.order.status),
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible:
                      widget.order.status == OrderStatus.NEW.toShortString(),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextButton(
                            onPressed: () {
                              goToEditOrderScreen();
                            },
                            child: const Text(
                              "Chỉnh sửa",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.normal),
                            )),
                      ),
                    ],
                  )),
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
      return Image.network(
        widget.order.productImage,
        width: 48,
        height: 48,
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
      );
    } else {
      return Image.asset(
        ImagePath.imgImageUpload,
        width: 48,
        height: 48,
      );
    }
  }
}
