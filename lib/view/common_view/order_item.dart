import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../main.dart';
import '../../model/my_order.dart';
import '../../model/order_status.dart';
import '../../utils/common_func.dart';
import '../../utils/image_path.dart';
import '../../viewmodel/order_viewmodel.dart';
import 'details_order_screen.dart';

class OrderItem extends StatefulWidget {
  MyOrder order;

  OrderItem({required this.order});

  @override
  State<StatefulWidget> createState() => _OrderItem();
}

class _OrderItem extends State<OrderItem> {
  OrderViewModel orderViewModel = OrderViewModel();

  void goToOrderDetailsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailsOrderScreen(order: widget.order)),
    );
  }

  showDialogChangeOrderStatus() {
    Widget newButton = TextButton(
      child: Text("${AppLocalizations.of(context)?.newOrder}"),
      onPressed: () async {
        await orderViewModel.updateOrderStatus(
            orderId: widget.order.id,
            newStatus: OrderStatus.NEW.toShortString());
        Navigator.of(context).pop();
      },
    );
    Widget processButton = TextButton(
      child: Text("${AppLocalizations.of(context)?.inProcess}"),
      onPressed: () async {
        await orderViewModel.updateOrderStatus(
            orderId: widget.order.id,
            newStatus: OrderStatus.PROCESSING.toShortString());
        Navigator.of(context).pop();
      },
    );

    Widget doneButton = TextButton(
      child: Text("${AppLocalizations.of(context)?.done}"),
      onPressed: () async {
        await orderViewModel.updateOrderStatus(
            orderId: widget.order.id,
            newStatus: OrderStatus.DONE.toShortString());
        Navigator.of(context).pop();
      },
    );

    Widget cancelButton = TextButton(
      child: Text("${AppLocalizations.of(context)?.cancel}"),
      onPressed: () async {
        await orderViewModel.updateOrderStatus(
            orderId: widget.order.id,
            newStatus: OrderStatus.CANCEL.toShortString());
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      actionsOverflowAlignment: OverflowBarAlignment.start,
      content: Text("${AppLocalizations.of(context)?.chooseAva}",
          textAlign: TextAlign.center),
      actions: [newButton, processButton, doneButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

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
          height: 106,
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
                  child: productItemImage(),
                ),
              ),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.order.productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formatCurrency.format(widget.order.productPrice),
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          "${AppLocalizations.of(context)?.quantity}:${widget.order.productQuantity}",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 10,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        Text(
                          "${AppLocalizations.of(context)?.customer}:${widget.order.customerName}",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          "${AppLocalizations.of(context)?.created_date}:${widget.order.createDate}",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "${AppLocalizations.of(context)?.status} :",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 10,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              CommonFunc.getOrderStatusName(
                                  context, widget.order.status),
                              style: TextStyle(
                                color: CommonFunc.getOrderStatusColor(
                                  widget.order.status,
                                ),
                                fontSize: 10,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: TextButton(
                  onPressed: () {
                    showDialogChangeOrderStatus();
                  },
                  child: Text(
                    "${AppLocalizations.of(context)?.changeStatus}",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.normal,
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
        width: 150,
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
