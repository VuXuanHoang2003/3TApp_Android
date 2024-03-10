import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../model/product.dart';
import '../../model/scrap_type.dart';
import '../../utils/common_func.dart';
import '../../utils/image_path.dart';
import '../../viewmodel/product_viewmodel.dart';
import '../common_view/custom_button.dart';

class EditProductScreen extends StatefulWidget {
  Product product;

  EditProductScreen({required this.product});

  @override
  State<StatefulWidget> createState() => _EditProductScreen();
}

class _EditProductScreen extends State<EditProductScreen> {
  ProductViewModel productViewModel = ProductViewModel();
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController massController = TextEditingController();

  FocusNode productFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode priceFocusNode = FocusNode();
  FocusNode massFocusNode = FocusNode();

  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    loadProductData();
  }

  void loadProductData() {
    productNameController.text = widget.product.name;
    descriptionController.text = widget.product.description;
    priceController.text = widget.product.price.toString();
    massController.text = widget.product.mass.toString();
    selectedType = CommonFunc.getScrapTypeByName(widget.product.type);
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

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    var pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
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
        
          title: Text(
            "${AppLocalizations.of(context)?.edit} ${AppLocalizations.of(context)?.product}",
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
          child: Padding(
            padding: EdgeInsets.only(
                left: 16,
                top: 08,
                right: 16,
                bottom: MediaQuery.of(context).padding.bottom + 16),
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: GestureDetector(
                          onTap: () async {
                            print("pick image");
                            getImage();
                          },
                          child: productImage())),
                  const Padding(padding: EdgeInsets.only(top: 32)),
                  TextFormField(
                    controller: productNameController,
                    focusNode: productFocusNode,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      labelText: "${AppLocalizations.of(context)?.productName}(*)",
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
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  TextFormField(
                    controller: priceController,
                    focusNode: priceFocusNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      labelText: "${AppLocalizations.of(context)?.price}(*)",
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
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  TextFormField(
                    maxLines: null,
                    controller: descriptionController,
                    focusNode: descriptionFocusNode,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      labelText: "${AppLocalizations.of(context)?.productDescription}",
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
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  TextFormField(
                    controller: massController,
                    focusNode: massFocusNode,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      labelText: "${AppLocalizations.of(context)?.productWeight} (kg)",
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
                  const Padding(padding: EdgeInsets.only(top: 8)),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text("${AppLocalizations.of(context)?.type}:"),
                      ),
                      Spacer(),
                      DropdownButton<ScrapType>(
                        items: productType.map((ScrapType value) {
                          return DropdownMenuItem<ScrapType>(
                            value: value,
                            child: Text(CommonFunc.getSenDaNameByType(context,
                                value.toShortString())),
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
                  const Padding(padding: EdgeInsets.only(top: 32)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: CustomButton(
                        onPressed: () async {
                          if (productNameController.text
                                  .toString()
                                  .trim()
                                  .isNotEmpty &&
                              priceController.text
                                  .toString()
                                  .trim()
                                  .isNotEmpty) {
                            String name =
                                productNameController.text.toString().trim();
                            double price = double.parse(
                                priceController.text.toString().trim());
                            String description =
                                descriptionController.text.toString().trim();
                            double mass = double.parse(
                                massController.text.toString().trim());

                            Product product = Product(
                                id: widget.product.id,
                                name: name,
                                image: widget.product.image,
                                description: description,
                                mass: mass,
                                price: price,
                                type: selectedType.toShortString(),
                                uploadBy: widget.product.uploadBy,
                                uploadDate: widget.product.uploadDate,
                                editDate: DateTime.now().toString());

                            await productViewModel.updateProduct(
                                product: product, imageFile: _image);

                            Navigator.of(context).pop();
                          } else {
                            Fluttertoast.showToast(
                                msg: "Vui lòng nhập đủ thông tin.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black45,
                                textColor: Colors.white,
                                fontSize: 12.0);
                          }
                        },
                        text: "${AppLocalizations.of(context)?.edit}",
                        textColor: Colors.white,
                        bgColor: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget productImage() {
    if (_image == null && widget.product.image.isEmpty) {
      return Image.asset(
        ImagePath.imgImageUpload,
        width: 64,
        height: 64,
      );
    } else {
      return FutureBuilder<List<String>>(
        future: getAllImageUrls(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<String>? imageUrls = snapshot.data;
            if (imageUrls != null && imageUrls.isNotEmpty) {
              return SizedBox(
                height: 64,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Image.network(
                        imageUrls[index],
                        width: 64,
                        height: 64,
                      ),
                    );
                  },
                ),
              );
            } else {
              return Text('No image found');
            }
          }
        },
      );
    }
  }

  Future<List<String>> getAllImageUrls() async {
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
      return []; // Trả về danh sách rỗng nếu có lỗi xảy ra
    }
  }
}
