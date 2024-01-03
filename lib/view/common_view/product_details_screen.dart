import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../../model/product.dart';
import '../../utils/common_func.dart';
import '../../utils/image_path.dart';
import '../../viewmodel/auth_viewmodel.dart';

class ProductDetailsScreen extends StatefulWidget {
  Product product;

  ProductDetailsScreen({required this.product});

  @override
  State<StatefulWidget> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  AuthViewModel authViewModel = AuthViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Chi tiết sản phẩm",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
            size: 20,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: productItemImage(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  widget.product.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(
                thickness: 1,
                color: Colors.green,
                height: 16,
              ),
              Text(
                "${formatCurrency.format(widget.product.price)}",
                style: TextStyle(color: Colors.redAccent, fontSize: 22, fontStyle: FontStyle.italic),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "Thể loại: ${CommonFunc.getSenDaNameByType(widget.product.type)}",
                  style: TextStyle(color: Colors.black, fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
              const Divider(
                thickness: 1,
                color: Colors.green,
                height: 16,
              ),
              Text(
                "Mô tả",
                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Padding(padding: EdgeInsets.only(top: 8)),
              Text(
                widget.product.description,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget productItemImage() {
    if (widget.product.image.isNotEmpty) {
      return Image.network(
        widget.product.image,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
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
}
