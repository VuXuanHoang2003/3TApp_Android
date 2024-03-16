import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:three_tapp_app/data/repositories/auth_repo/auth_repo.dart';
import 'package:three_tapp_app/data/repositories/auth_repo/auth_repo_impl.dart';
import 'package:three_tapp_app/data/repositories/order_repo/order_repo.dart';
import 'package:three_tapp_app/data/repositories/product_repo/product_repo.dart';
import 'package:three_tapp_app/data/repositories/product_repo/product_repo_impl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  final OrderViewModel _orderViewModel = OrderViewModel();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _massController = TextEditingController();
  User? user;

  final FocusNode _customerNameFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _massFocusNode = FocusNode();
  ProductRepo productRepo = ProductRepoImpl();
  AuthRepo authRepo = AuthRepoImpl();
  int _orderQuantity = 1;
  bool _imageLoaded = false;
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    loadInitData();
    _loadImageUrls();
  }

  void loadInitData() async {
    Map<String, dynamic>? userInfo =
        await CommonFunc.getUserInfoFromFirebase(user?.uid ?? "");
    _customerNameController.text = userInfo?['username'] ?? "Unknown username";
    _addressController.text = userInfo?['address'] ?? "Unknown address";
    _phoneNumberController.text = userInfo?['phone'] ?? "Unknown phone";
  }

  Future<void> _loadImageUrls() async {
    try {
      ListResult result =
          await FirebaseStorage.instance.ref(widget.product.image).list();
      List<String> urls = [];
      for (Reference ref in result.items) {
        String url = await ref.getDownloadURL();
        urls.add(url);
      }
      setState(() {
        _imageUrls = urls;
        _imageLoaded = true;
      });
    } catch (e) {
      print('Error getting image URLs: $e');
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
            "${AppLocalizations.of(context)?.orderConfirmed}",
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
                Text(
                  "${AppLocalizations.of(context)?.productInfo}",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                const Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                  height: 16,
                ),
                _imageLoaded
                    ? orderDetail()
                    : Center(child: CircularProgressIndicator()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        _decrementQuantity();
                      },
                      child: const Icon(Icons.remove_circle_outline_outlined),
                    ),
                    Text(
                      "$_orderQuantity",
                      style: const TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        _incrementQuantity();
                      },
                      child: const Icon(Icons.add_circle_outline_outlined),
                    ),
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
                      onPressed: _createOrder,
                      text:
                          "${AppLocalizations.of(context)?.createTransaction}",
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
          "${AppLocalizations.of(context)?.productName}: ${widget.product.name}",
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
          "${AppLocalizations.of(context)?.type}: ${CommonFunc.getSenDaNameByType(context, widget.product.type)}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
        TextFormField(
          controller: _massController,
          focusNode: _massFocusNode,
          keyboardType: TextInputType.number,
          validator: (input) {
            if (input!.isNotEmpty) {
              return null;
            } else {
              return "Vui lòng nhập khối lượng";
            }
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(8),
            labelText: "${AppLocalizations.of(context)?.productWeight}",
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
            controller: _customerNameController,
            focusNode: _customerNameFocusNode,
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
              // labelText: "Tên khách hàng (Bắt buộc)",
              labelText:
                  "${AppLocalizations.of(context)?.customerName} ${AppLocalizations.of(context)?.required}}",
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
            controller: _phoneNumberController,
            focusNode: _phoneNumberFocusNode,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              labelText:
                  "${AppLocalizations.of(context)?.phoneNumber} ${AppLocalizations.of(context)?.required}}",
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
            controller: _addressController,
            focusNode: _addressFocusNode,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              labelText:
                  "${AppLocalizations.of(context)?.address} ${AppLocalizations.of(context)?.required}}",
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

  Widget productItemImage() {
    if (_imageUrls.isNotEmpty) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: 8.0, // Khoảng cách giữa các ảnh
          runSpacing: 8.0, // Khoảng cách giữa các dòng
          children: _imageUrls.map((imageUrl) {
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
    } else {
      return Image.asset(
        ImagePath.imgImageUpload,
        height: 120,
        width: 120,
      );
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

  void _incrementQuantity() {
    setState(() {
      _orderQuantity += 1;
    });
  }

  void _decrementQuantity() {
    if (_orderQuantity > 1) {
      setState(() {
        _orderQuantity -= 1;
      });
    }
  }

  void _createOrder() {
    String customerName = _customerNameController.text.trim();
    String phoneNumber = _phoneNumberController.text.trim();
    String address = _addressController.text.trim();
    String mass = _massController.text.trim();
    double massDouble = double.tryParse(mass) ?? 0.0;

    double productMass = widget.product.mass;

    if (customerName.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        address.isNotEmpty &&
        mass.isNotEmpty) {
      if (massDouble <= productMass) {
        // Tính khối lượng mới của sản phẩm sau khi tạo đơn hàng
        double newProductMass = productMass - massDouble;
        newProductMass = double.parse(newProductMass.toStringAsFixed(2));

        // Tạo đối tượng đơn hàng
        MyOrder order = MyOrder(
          id: UniqueKey().toString(),
          productImage: widget.product.image,
          productName: widget.product.name,
          productPrice: widget.product.price,
          productQuantity: _orderQuantity,
          customerName: customerName,
          productMass: massDouble,
          type: widget.product.type,
          customerEmail: FirebaseAuth.instance.currentUser?.email ?? '',
          phoneNumber: phoneNumber,
          address: address,
          status: OrderStatus.NEW.toShortString(),
          createDate: DateTime.now().toString(),
          updateDate: DateTime.now().toString(),
          sellerEmail: widget.product.uploadBy,
        );
        // Tạo thể hiện của lớp ProductRepo
        productRepo
            .updateProductMass(
                productId: widget.product.id, newMass: newProductMass)
            .then((success) {
          if (success) {
            // Nếu cập nhật thành công, tạo đơn hàng và đóng màn hình
            _orderViewModel.createOrder(order: order);
            Navigator.of(context).pop();
          } else {
            // Xử lý trường hợp cập nhật không thành công
            CommonFunc.showToast("Cập nhật khối lượng sản phẩm thất bại.");
          }
        }).catchError((error) {
          // Xử lý lỗi nếu có
          CommonFunc.showToast(
              "Đã có lỗi xảy ra khi cập nhật khối lượng sản phẩm.");
        });
      } else {
        CommonFunc.showToast(
            "Khối lượng nhập phải nhỏ hơn khối lượng sản phẩm.");
      }
    } else {
      CommonFunc.showToast("Vui lòng nhập đủ thông tin.");
    }
  }
}
