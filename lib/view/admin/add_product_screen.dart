import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/product.dart';
import '../../model/scrap_type.dart';
import '../../utils/common_func.dart';
import '../../utils/image_path.dart';
import '../../viewmodel/product_viewmodel.dart';
import '../common_view/custom_button.dart';

class AddProductScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  ProductViewModel productViewModel = ProductViewModel();
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  FocusNode productFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode priceFocusNode = FocusNode();
  User? user;
  List<File> _images = []; // Khởi tạo danh sách ảnh

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  List<ScrapType> productType = [
    ScrapType.giay,
    ScrapType.nhua,
    ScrapType.kim_loai,
    ScrapType.thuy_tinh,
    ScrapType.khac
  ];

  ScrapType selectedType = ScrapType.khac;

  void reloadView() {
    setState(() {});
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> getImage() async {
    List<XFile>? pickedFiles = await _picker.pickMultiImage(
      imageQuality: 50,
    );

    if (pickedFiles != null) {
      setState(() {
        _images.clear(); // Xóa danh sách ảnh hiện tại
        for (var pickedFile in pickedFiles) {
          _images.add(File(pickedFile.path)); // Thêm ảnh mới vào danh sách
        }
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Thêm sản phẩm",
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
        body: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(

            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: getImage,
                    child: _images.isEmpty
                        ? Image.asset(
                            ImagePath.imgImageUpload,
                            width: 64,
                            height: 64,
                          )
                        : SizedBox(
                            height: 64,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _images.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Image.file(
                                    _images[index],
                                    width: 64,
                                    height: 64,
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: productNameController,
                  focusNode: productFocusNode,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Tên sản phẩm (*)",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.redAccent, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.redAccent, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: priceController,
                  focusNode: priceFocusNode,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Giá bán (*)",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.redAccent, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.redAccent, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  maxLines: null,
                  controller: descriptionController,
                  focusNode: descriptionFocusNode,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Mô tả",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.redAccent, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.redAccent, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text("Loại:"),
                    ),
                    Spacer(),
                    DropdownButton<ScrapType>(
                      items: productType.map((type) {
                        return DropdownMenuItem<ScrapType>(
                          value: type,
                          child: Text(CommonFunc.getSenDaNameByType(
                              type.toShortString())),
                        );
                      }).toList(),
                      value: selectedType,
                      onChanged: (value) {
                        if (value != null) {
                          selectedType = value;
                        } else {
                          selectedType = ScrapType.khac;
                        }
                        reloadView();
                      },
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CustomButton(
                    onPressed: () async {
                      if (productNameController.text.isNotEmpty &&
                          priceController.text.isNotEmpty &&
                          _images.isNotEmpty) {
                        String name = productNameController.text.trim();
                        double price =
                            double.parse(priceController.text.trim());
                        String description = descriptionController.text.trim();

                        Product product = Product(
                          id: UniqueKey().toString(),
                          name: name,
                          image: '', // Cập nhật sau khi tải ảnh lên
                          description: description,
                          price: price,
                          type: selectedType.toShortString(),
                          uploadBy: user?.email ?? "Unknown user",
                          uploadDate: DateTime.now().toString(),
                          editDate: DateTime.now().toString(),
                        );

                        await productViewModel.addProduct(
                          product: product,
                          imageFiles: _images,
                        );
                        Navigator.of(context).pop();
                      } else {
                        Fluttertoast.showToast(
                          msg: "Vui lòng nhập đủ thông tin.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black45,
                          textColor: Colors.white,
                          fontSize: 12.0,
                        );
                      }
                    },
                    text: "Thêm",
                    textColor: Colors.white,
                    bgColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
