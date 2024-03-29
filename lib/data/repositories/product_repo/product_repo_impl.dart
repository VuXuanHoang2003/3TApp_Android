import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:three_tapp_app/data/repositories/product_repo/product_repo.dart';

import '../../../model/product.dart';
import '../../../utils/common_func.dart';

class ProductRepoImpl with ProductRepo {
  @override
  Future<List<Product>> getAllProduct() async {
    List<Product> products = [];

    try {
      await FirebaseFirestore.instance
          .collection("PRODUCTS")
          .get()
          .then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          products.add(Product.fromJson(result.data()));
        }
        print("product length:${products.length}");
      });
      return products;
    } catch (error) {
      print("error:${error.toString()}");
    }

    return [];
  }

  @override
  // Future<bool> addProduct(
  //     {required Product product, required File? imageFile}) async {
  //   //Add image storage
  //   if (imageFile != null) {
  //     // Create a storage reference from our app
  //     final storageRef = FirebaseStorage.instance.ref();

  //     try {
  //       var snapshot = await storageRef
  //           .child('images/${product.id}.jpg')
  //           .putFile(imageFile);
  //       var downloadUrl = await snapshot.ref.getDownloadURL();

  //       //Assign image path for product
  //       product.image = downloadUrl;

  //       //Add to firestore
  //       Map<String, dynamic> productMap = {
  //         "id": product.id,
  //         "name": product.name,
  //         "image": product.image,
  //         "description": product.description,
  //         "price": product.price,
  //         "type": product.type,
  //         "uploadBy": product.uploadBy,
  //         "uploadDate": product.uploadDate,
  //         "editDate": product.editDate
  //       };

  //       FirebaseFirestore.instance
  //           .collection('PRODUCTS')
  //           .doc(product.id)
  //           .set(productMap)
  //           .then((value) {
  //         return Future.value(true);
  //       });

  //       return Future.value(true);
  //     } on FirebaseException catch (e) {
  //       CommonFunc.showToast("Đã có lỗi xảy ra.");
  //     } catch (e) {
  //       CommonFunc.showToast("Đã có lỗi xảy ra.");
  //     }
  //   } else {
  //     try {
  //       //Add product without image
  //       Map<String, dynamic> productMap = {
  //         "id": product.id,
  //         "name": product.name,
  //         "image": product.image,
  //         "description": product.description,
  //         "price": product.price,
  //         "type": product.type,
  //         "uploadBy": product.uploadBy,
  //         "uploadDate": product.uploadDate,
  //         "editDate": product.editDate
  //       };

  //       FirebaseFirestore.instance
  //           .collection('PRODUCTS')
  //           .doc(product.id)
  //           .set(productMap)
  //         ..then((value) {
  //           return Future.value(true);
  //         }).catchError((error) {
  //           CommonFunc.showToast("Lỗi thêm sản phẩm.");
  //           print("error:${error.toString()}");
  //           return Future.value(false);
  //         });
  //       return Future.value(true);
  //     } on FirebaseException catch (e) {
  //       CommonFunc.showToast("Đã có lỗi xảy ra.");
  //     } catch (e) {
  //       CommonFunc.showToast("Đã có lỗi xảy ra.");
  //     }
  //   }
  //   return Future.value(false);
  // }
  
Future<bool> addProduct({required Product product, required List<File> imageFiles}) async {
  try {
    // Tạo một thư mục mới cho sản phẩm
    String productFolder = 'products/${product.id}';
    product.image= productFolder;

    // Tải lên các ảnh vào thư mục của sản phẩm
    await uploadImagesToFirebaseStorage(imageFiles: imageFiles, productFolder: productFolder);

    // Chuẩn bị dữ liệu sản phẩm để thêm vào Firestore
    Map<String, dynamic> productMap = {
      "id": product.id,
      "name": product.name,
      "image": product.image, // Lưu đường dẫn tới thư mục
      "description": product.description,
      "price": product.price,
      "type": product.type,
      "uploadBy": product.uploadBy,
      "uploadDate": product.uploadDate,
      "editDate": product.editDate,
    };

    // Thêm sản phẩm vào Firestore
    await FirebaseFirestore.instance.collection('PRODUCTS').doc(product.id).set(productMap);

    // Trả về true nếu việc thêm sản phẩm thành công
    return true;
  } catch (e) {
    // Xử lý lỗi
    print("Error adding product: $e");
    return false;
  }
}

Future<void> uploadImagesToFirebaseStorage({
  required List<File> imageFiles,
  required String productFolder,
}) async {
  try {
    // Tạo một tham chiếu tới thư mục của sản phẩm trên Firebase Storage
    Reference storageRef = FirebaseStorage.instance.ref().child(productFolder);

    for (int i = 0; i < imageFiles.length; i++) {
      File imageFile = imageFiles[i];
      
      // Tải ảnh lên Firebase Storage vào thư mục của sản phẩm
      await storageRef.child('$i.jpg').putFile(imageFile);
    }
  } catch (e) {
    print("Error uploading images: $e");
    throw e; // Ném lỗi để xử lý ở hàm gọi
  }
}


  @override
  Future<bool> updateProduct(
      {required Product product, required File? imageFile}) async {
    //Add image storage
    if (imageFile != null) {
      // Create a storage reference from our app
      final storageRef = FirebaseStorage.instance.ref();

      try {
        var snapshot = await storageRef
            .child('images/${product.id}.jpg')
            .putFile(imageFile);
        var downloadUrl = await snapshot.ref.getDownloadURL();

        //Assign image path for product
        product.image = downloadUrl;

        //Add to firestore
        Map<String, dynamic> productMap = {
          "id": product.id,
          "name": product.name,
          "image": product.image,
          "description": product.description,
          "price": product.price,
          "type": product.type,
          "uploadBy": product.uploadBy,
          "uploadDate": product.uploadDate,
          "editDate": product.editDate
        };

        FirebaseFirestore.instance
            .collection('PRODUCTS')
            .doc(product.id)
            .update(productMap);

        return Future.value(true);
      } on FirebaseException catch (e) {
        CommonFunc.showToast("Đã có lỗi xảy ra.");
      } catch (e) {
        CommonFunc.showToast("Đã có lỗi xảy ra.");
      }
    } else {
      try {
        //Update product without image
        Map<String, dynamic> productMap = {
          "id": product.id,
          "name": product.name,
          "image": product.image,
          "description": product.description,
          "price": product.price,
          "type": product.type,
          "uploadBy": product.uploadBy,
          "uploadDate": product.uploadDate,
          "editDate": product.editDate
        };

        FirebaseFirestore.instance
            .collection('PRODUCTS')
            .doc(product.id)
            .update(productMap);
        return Future.value(true);
      } on FirebaseException catch (e) {
        CommonFunc.showToast("Đã có lỗi xảy ra.");
      } catch (e) {
        CommonFunc.showToast("Đã có lỗi xảy ra.");
      }
    }
    return Future.value(false);
  }

  @override
  Future<bool> deleteProduct({required String productId}) async {
    try {
      try {
        //delete image
        final storageRef = FirebaseStorage.instance.ref();
        await storageRef.child('images/${productId}.jpg').delete();
      } on FirebaseException catch (e) {
        print("code:${e.code},data:${e.message}");
        if (e.code == "object-not-found") {
          //delete product
          FirebaseFirestore.instance
              .collection('PRODUCTS')
              .doc(productId)
              .delete();
          return Future.value(true);
        }
      }
      //delete product
      FirebaseFirestore.instance.collection('PRODUCTS').doc(productId).delete();
      return Future.value(true);
    } on FirebaseException catch (e) {
      CommonFunc.showToast("Đã có lỗi xảy ra.");
      print("error:${e.toString()}");
    } catch (e) {
      CommonFunc.showToast("Đã có lỗi xảy ra.");
    }
    return Future.value(false);
  }

  Future<List<Product>> searchProducts(String searchTerm) async {
    List<Product> searchResults = [];

    try {
      await FirebaseFirestore.instance
          .collection("PRODUCTS")
          .get()
          .then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          Product product = Product.fromJson(result.data());

          // Chuyển tên sản phẩm và từ khóa tìm kiếm về chữ thường để so sánh không phân biệt chữ hoa chữ thường
          String productNameLower = product.name.toLowerCase();
          String searchTermLower = searchTerm.toLowerCase();

          // Kiểm tra xem từ khóa có xuất hiện trong tên sản phẩm hay không
          if (productNameLower.contains(searchTermLower)) {
            searchResults.add(product);
          }
        }
      });
    } catch (error) {
      print("searchProducts error: ${error.toString()}");
    }

    return searchResults;
  }
}
