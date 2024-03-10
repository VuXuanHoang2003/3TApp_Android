import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:three_tapp_app/view/common_view/product_details_screen.dart';
import '../../main.dart';
import '../../model/product.dart';
import '../../utils/image_path.dart';
import '../../viewmodel/product_viewmodel.dart';
import '../admin/edit_product_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductItemAdminView extends StatefulWidget {
  final Product product;

  ProductItemAdminView({required this.product});

  @override
  State<StatefulWidget> createState() => _ProductItemAdminViewState();
}

class _ProductItemAdminViewState extends State<ProductItemAdminView> {
  ProductViewModel productViewModel = ProductViewModel();
  String? firstImageUrl; // Biến để lưu URL của ảnh đầu tiên

  @override
  void initState() {
    super.initState();
    // Gọi hàm để lấy URL của ảnh đầu tiên khi StatefulWidget được khởi tạo
    getFirstImageUrl();
  }

  void goToProductDetailsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(product: widget.product),
      ),
    );
  }

  void goToEditProductScreen() {
    Navigator.push(
      navigationKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(product: widget.product),
      ),
    );
  }

  void showDialogConfirmDeleteProduct() {
    Widget noButton = TextButton(
      child: Text("${AppLocalizations.of(context)?.no}"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = TextButton(
      child: Text("${AppLocalizations.of(context)?.yes}"),
      onPressed: () {
        productViewModel.deleteProduct(productId: widget.product.id);
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      content:  Text(
        "${AppLocalizations.of(context)?.deleteProductQues}",
        textAlign: TextAlign.center,
      ),
      actions: [
        noButton,
        yesButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // Hàm để lấy URL của ảnh đầu tiên từ thư mục trong Firebase Storage
  void getFirstImageUrl() async {
    try {
      // Lấy danh sách tệp tin trong thư mục
      ListResult result =
          await FirebaseStorage.instance.ref(widget.product.image).list();
      // Lấy URL của ảnh đầu tiên nếu danh sách không rỗng
      if (result.items.isNotEmpty) {
        String firstImageURL = await result.items[0].getDownloadURL();
        setState(() {
          firstImageUrl = firstImageURL;
        });
      }
    } catch (e) {
      print('Error getting first image URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
      elevation: 16,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0x0D000000), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: const Color(0x33333333),
      child: InkWell(
        onTap: goToProductDetailsScreen,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: productItemImage(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${formatCurrency.format(widget.product.price)}",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        "${AppLocalizations.of(context)?.postedBy}: ${widget.product.uploadBy}",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        "${AppLocalizations.of(context)?.editDate}: ${widget.product.uploadDate}",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 48,
                child: IconButton(
                  onPressed: goToEditProductScreen,
                  icon: Icon(Icons.edit, size: 18),
                ),
              ),
              SizedBox(
                width: 48,
                child: IconButton(
                  onPressed: showDialogConfirmDeleteProduct,
                  icon: Icon(Icons.delete, size: 18, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget productItemImage() {
    return firstImageUrl != null
        ? Image.network(
            firstImageUrl!,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
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
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                ImagePath.imgImageUpload,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              );
            },
          )
        : SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(),
          );
  }
}
