import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
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
  List<File> _images = [];
  List<File> _newImages = [];
  

  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _images = [];
    if (widget.product.image.isEmpty) {
      _images.add(File('assets/images/default_avatar.jpg'));
    } else {
      getAllImages();
    }
    loadProductData();
  }

  
  Future<void> getAllImages() async {
    try {
      List<String> imageUrls = await getAllImageUrls();
      List<File> images = [];
      for (String url in imageUrls) {
        final response = await http.get(Uri.parse(url));
        final Directory tempDir = await getTemporaryDirectory();
        final File imageFile = File('${tempDir.path}/temp_image.jpg');
        await imageFile.writeAsBytes(response.bodyBytes);
        images.add(imageFile);
      }
      // Thêm các ảnh mới từ _newImages vào danh sách ảnh
      images.addAll(_newImages);
      setState(() {
        _images = images;
      });
    } catch (e) {
      print('Error getting images: $e');
    }
  }

  void loadProductData() {
    productNameController.text = widget.product.name;
    descriptionController.text = widget.product.description;
    priceController.text = widget.product.price.toString();
    massController.text = widget.product.mass.toString();
    selectedType = CommonFunc.getScrapTypeByName(widget.product.type);
  }

  List<int> _selectedIndexes = [];

  // Hàm xóa các ảnh đã chọn
  void _deleteSelectedImages(List<int> selectedIndexes) {
    // Tạo danh sách tạm thời chứa các ảnh không bị chọn
    List<File> tempImages = [];

    // Lặp qua danh sách _images
    for (int i = 0; i < _images.length; i++) {
      // Nếu chỉ mục không nằm trong danh sách các chỉ mục đã chọn, thêm ảnh vào danh sách tạm thời
      if (!selectedIndexes.contains(i)) {
        tempImages.add(_images[i]);
      }
    }

    // Cập nhật lại danh sách _images với danh sách ảnh tạm thời đã cập nhật
    setState(() {
      _images = tempImages;
    });

    // Xóa tất cả các chỉ mục đã chọn
    setState(() {
      _selectedIndexes.clear();
    });
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

  // File? _image;
  //List<File> _editedImages = []; // Biến lưu trữ danh sách ảnh sau khi chỉnh sửa

  final ImagePicker _picker = ImagePicker();

  Future<void> getImage() async {
    List<XFile>? pickedFiles = await _picker.pickMultiImage(
      imageQuality: 50,
    );

    if (pickedFiles != null) {
      setState(() {
        for (var pickedFile in pickedFiles) {
          _images.add(File(pickedFile.path));
          // Thêm ảnh mới vào danh sách
          _newImages.add(File(pickedFile.path));
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: getImage,
                        icon: Icon(Icons.add_photo_alternate),
                        label: Text('${AppLocalizations.of(context)?.add} ${AppLocalizations.of(context)?.picture}'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Tạo bản sao của _images
                          List<File> tempImages = List.from(_images);

                          // Hiển thị hộp thoại chọn ảnh để xóa
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('${AppLocalizations.of(context)?.selectImageToDelete}'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(tempImages.length,
                                        (index) {
                                      return CheckboxListTile(
                                        title: Image.file(tempImages[index]),
                                        value: _selectedIndexes.contains(index),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (value != null && value) {
                                              _selectedIndexes.add(index);
                                            } else {
                                              _selectedIndexes.remove(index);
                                            }
                                          });
                                        },
                                      );
                                    }),
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Hủy'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Xóa các ảnh đã chọn
                                      _deleteSelectedImages(_selectedIndexes);
                                      // Đóng hộp 
                                      Navigator.pop(context);
                                    },
                                    child: Text('${AppLocalizations.of(context)?.delete}'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.delete),
                        label: Text('${AppLocalizations.of(context)?.delete} ${AppLocalizations.of(context)?.picture}'),
                      ),
                    ],
                  ),

                  SizedBox(height: 10), // Khoảng cách giữa nút và danh sách ảnh
                  // Danh sách các ảnh đã chọn
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        for (var image in _newImages)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 64, // Độ rộng ảnh
                              height: 64, // Chiều cao ảnh
                              child: Image.file(image, fit: BoxFit.cover),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  productImage(),

                  const Padding(padding: EdgeInsets.only(top: 32)),
                  TextFormField(
                    controller: productNameController,
                    focusNode: productFocusNode,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      labelText:
                          "${AppLocalizations.of(context)?.productName}(*)",
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
                      labelText:
                          "${AppLocalizations.of(context)?.productDescription}",
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
                      labelText:
                          "${AppLocalizations.of(context)?.productWeight} (kg)",
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
                            child: Text(CommonFunc.getSenDaNameByType(
                                context, value.toShortString())),
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
                                image: '',
                                description: description,
                                mass: mass,
                                price: price,
                                type: selectedType.toShortString(),
                                uploadBy: widget.product.uploadBy,
                                uploadDate: widget.product.uploadDate,
                                editDate: DateTime.now().toString());

                            await productViewModel.updateProduct(
                                product: product, imageFiles: _images);
                            print('Danh sách các file trong _images:');
                            for (var image in _images) {
                              print(image.path);
                            }

                            Navigator.of(context).pop();
                          } else {
                            Fluttertoast.showToast(
                                msg: "${AppLocalizations.of(context)?.infoMsg}",
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
    if (_images == null && widget.product.image.isEmpty) {
     
      return SizedBox(
        width: 64,
        height: 64,
        child: Placeholder(), // hoặc bất kỳ widget nào bạn muốn hiển thị ở đây
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
              child: Text('${AppLocalizations.of(context)?.close}'),
            ),
          ],
        );
      },
    );
  }

  Future<List<String>> getAllImageUrls() async {
    int count = 0;
    try {
      ListResult result =
          await FirebaseStorage.instance.ref(widget.product.image).list();
      List<String> urls = [];
      for (Reference ref in result.items) {
        String url = await ref.getDownloadURL();
        urls.add(url);
        ++count;
      }
     
      return urls;
    } catch (e) {
      print('Error getting image URLs: $e');
      return []; // Trả về danh sách rỗng nếu có lỗi xảy ra
    }
  }
}
