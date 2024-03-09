import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../../model/product.dart';
import '../../utils/common_func.dart';
import '../../utils/image_path.dart';
import '../../viewmodel/auth_viewmodel.dart';
import '../flutter_flow/flutter_flow.dart';

class ProductDetailsScreen extends StatefulWidget {
  Product product;

  ProductDetailsScreen({required this.product});

  @override
  State<StatefulWidget> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  AuthViewModel authViewModel = AuthViewModel();
  List<String> imageUrls = [];
  late List<String> userInfo;

  @override
  void initState() {
    super.initState();
    userInfo = authViewModel.getUserInfoWidget();
    getAllImageUrls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Chi tiết sản phẩm",
          style: TextStyle(color: Colors.black, fontSize: 18),
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
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              productItemImage(),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Stack(
                  children: [
                    const Align(
                      alignment: AlignmentDirectional(-0.94, 0),
                      child: Text(
                        'Khối lượng: ',
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Text(
                        widget.product.name,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Stack(
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Text(
                        "${formatCurrency.format(widget.product.price)} ",
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              color: const Color(0xFF831B1B),
                            ),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(-0.94, 0),
                      child: Text(
                        'Giá tiền (1 kg): ',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              color: const Color(0xFF831B1B),
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              // Generated code for this Stack Widget...
              Padding(
                padding: const EdgeInsets.all(6),
                child: Stack(
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Text(
                        "${widget.product.mass} (kg)",
                        style: FlutterFlowTheme.of(context).bodyMedium,
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(-0.94, 0),
                      child: Text(
                        'Khối lượng: ',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
                color: Colors.green,
                height: 16,
              ),
              const Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Text('Mô tả sản phẩm'),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    widget.product.description,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          fontSize: 14,
                        ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  maxWidth: 430,
                ),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  boxShadow: [
                    const BoxShadow(
                      blurRadius: 4,
                      color: Color(0x33000000),
                      offset: Offset(0, 2),
                    )
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thông tin liên hệ',
                        style: FlutterFlowTheme.of(context).titleLarge,
                      ),
                      Divider(
                        height: 32,
                        thickness: 2,
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 12),
                        child: RichText(
                          textScaler: MediaQuery.of(context).textScaler,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Khách hàng: ',
                                style: FlutterFlowTheme.of(context).labelMedium,
                              ),
                              TextSpan(
                                text: userInfo.elementAt(0),
                                style: TextStyle(),
                              )
                            ],
                            style: FlutterFlowTheme.of(context).labelMedium,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 12),
                        child: RichText(
                          textScaler: MediaQuery.of(context).textScaler,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Email: ',
                                style: FlutterFlowTheme.of(context).labelMedium,
                              ),
                              TextSpan(
                                text: widget.product.uploadBy,
                                style: TextStyle(),
                              )
                            ],
                            style: FlutterFlowTheme.of(context).labelMedium,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 12),
                        child: RichText(
                          textScaler: MediaQuery.of(context).textScaler,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Số điện thoại: ',
                                style: FlutterFlowTheme.of(context).labelMedium,
                              ),
                              TextSpan(
                                text: userInfo.elementAt(2),
                                style: TextStyle(),
                              )
                            ],
                            style: FlutterFlowTheme.of(context).labelMedium,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 12),
                        child: RichText(
                          textScaler: MediaQuery.of(context).textScaler,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Địa chỉ: ',
                                style: FlutterFlowTheme.of(context).labelMedium,
                              ),
                              TextSpan(
                                text: userInfo.elementAt(1),
                                style: TextStyle(),
                              )
                            ],
                            style: FlutterFlowTheme.of(context).labelMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
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
      ListResult result =
          await FirebaseStorage.instance.ref(widget.product.image).listAll();
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
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
