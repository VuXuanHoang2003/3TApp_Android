import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:three_tapp_app/model/order_status.dart';
import 'package:three_tapp_app/model/product.dart';
import 'package:three_tapp_app/viewmodel/cart_viewmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../main.dart';
import '../../../model/my_order.dart';
import '../../../utils/common_func.dart';
import '../../../utils/image_path.dart';
import '../../../viewmodel/order_viewmodel.dart';
import '../../common_view/custom_button.dart';

class EditOrderScreen extends StatefulWidget {
  MyOrder order;

  EditOrderScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  CartViewModel cartViewModel = CartViewModel();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  FocusNode customerNameFocusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  late MyOrder order;
  int orderQuantity = 1;
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    loadInitData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reloadView();
      getAllImageUrls();
    });
  }

  void loadInitData() {
    order = widget.order;
    orderQuantity = order.productQuantity;
    customerNameController.text = order.customerName;
    phoneNumberController.text = order.phoneNumber;
    addressController.text = order.address;
  }

  void reloadView() {
    setState(() {});
  }

  void incrementQuantity() {
    orderQuantity += 1;
    reloadView();
  }

  void decrementQuantity() {
    if (orderQuantity > 1) {
      orderQuantity -= 1;
      reloadView();
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
            title: Text(
              "${AppLocalizations.of(context)?.edit} ${AppLocalizations.of(context)?.product}}",
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
                )),
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
                  Text(
                    "${AppLocalizations.of(context)?.productInfo}",
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
                          child:
                              const Icon(Icons.remove_circle_outline_outlined)),
                      Text(
                        "$orderQuantity",
                        style: const TextStyle(fontSize: 16),
                      ),
                      TextButton(
                          onPressed: () {
                            incrementQuantity();
                          },
                          child: const Icon(Icons.add_circle_outline_outlined)),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 8)),
                  Text(
                    "${AppLocalizations.of(context)?.contactInfo}",
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
                          MyOrder newOrder = MyOrder(
                              id: order.id,
                              productImage: order.productImage,
                              productName: order.productName,
                              productPrice: order.productPrice,
                              productQuantity: orderQuantity,
                              customerName: customerName,
                              customerEmail: order.customerEmail,
                              phoneNumber: phoneNumber,
                              address: address,
                              type: order.type,
                              status: order.status,
                              createDate: order.createDate,
                              updateDate: DateTime.now().toString(),
                              productMass: order.productMass,
                              sellerEmail: order.sellerEmail);
                          cartViewModel.updateOrderInfo(
                            newOrder: newOrder,
                          );
                          Navigator.of(context).pop();
                        } else {
                          CommonFunc.showToast("Vui lòng nhập đủ thông tin.");
                        }
                      },
                      text:
                          "${AppLocalizations.of(context)?.edit} ${AppLocalizations.of(context)?.product}",
                      textColor: Colors.white,
                      bgColor: Colors.blue,
                    ),
                  )),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: CustomButton(
                        onPressed: () async {
                          await showDialogConfirmCancelOrder();
                        },
                        text:
                            "${AppLocalizations.of(context)?.cancel} ${AppLocalizations.of(context)?.product}", // Bổ sung văn bản cho nút nếu cần
                        textColor: Colors.white, // Màu văn bản của nút
                        bgColor: Colors.blue, // Màu nền của nút
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  showDialogConfirmCancelOrder() {
    Widget noButton = TextButton(
      child: Text("${AppLocalizations.of(context)?.no}"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = TextButton(
      child: Text("${AppLocalizations.of(context)?.yes}"),
      onPressed: () async {
        Navigator.of(context).maybePop();
        await cartViewModel.updateOrderStatus(
            orderId: order.id, newStatus: OrderStatus.CANCEL.toShortString());
        Navigator.of(context).maybePop();
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text("${AppLocalizations.of(context)?.cancelQues} ?",
          textAlign: TextAlign.center),
      actions: [
        noButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget orderDetail() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: productItemImage()),
        ),
        Text(
            "${AppLocalizations.of(context)?.productName}: ${widget.order.productName}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            )),
        Text(
          formatCurrency.format(widget.order.productPrice),
          style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 12,
              fontStyle: FontStyle.italic),
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
                return "${AppLocalizations.of(context)?.customerName} ${AppLocalizations.of(context)?.invalid}";
              }
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              labelText:
                  "${AppLocalizations.of(context)?.customerName} (${AppLocalizations.of(context)?.required})",
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.blueAccent, width: 2.0),
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
              labelText:
                  "${AppLocalizations.of(context)?.phoneNumber} (${AppLocalizations.of(context)?.required})",
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.blueAccent, width: 2.0),
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
              labelText:
                  "${AppLocalizations.of(context)?.address} (${AppLocalizations.of(context)?.required})",
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.blueAccent, width: 2.0),
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
      ListResult result = await FirebaseStorage.instance
          .ref(widget.order.productImage)
          .listAll();
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
