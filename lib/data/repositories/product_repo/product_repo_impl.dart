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
      "mass":product.mass,
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
Future<bool> isMassLessThanOrEqualProductMass(double mass,String productId) async {
  try {
    // Lấy thông tin sản phẩm từ Firestore
    DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
        .collection("PRODUCTS")
        .doc(productId)
        .get();

    // Lấy khối lượng sản phẩm từ dữ liệu Firestore
    double productMass = productSnapshot.get('mass');

    // Kiểm tra xem khối lượng có nhỏ hơn hoặc bằng khối lượng sản phẩm không
    return mass <= productMass;
  } catch (error) {
    print("Lỗi khi kiểm tra khối lượng: $error");
    return false; // Trả về false nếu có lỗi xảy ra
  }
}
Future<bool> updateProductMass({required String productId, required double newMass}) async {
    try {
      // Lấy tham chiếu tới tài liệu của sản phẩm cần cập nhật khối lượng
      DocumentReference productRef = FirebaseFirestore.instance.collection('PRODUCTS').doc(productId);

      // Tạo map chứa dữ liệu mới của sản phẩm (bao gồm khối lượng mới)
      Map<String, dynamic> newData = {
        'mass': newMass,
      };

      // Cập nhật dữ liệu của sản phẩm trong Firestore
      await productRef.update(newData);

      return true; // Trả về true nếu cập nhật thành công
    } catch (error) {
      print('Error updating product mass: $error');
      return false; // Trả về false nếu có lỗi xảy ra
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
    {required Product product, required List<File> imageFiles}) async {
  //Add image storage
  if (imageFiles != null) {
    String productFolder = 'products/${product.id}';
    product.image = productFolder;

    // Xóa tất cả các ảnh trong thư mục `product/product.id`
    await deleteImagesInFirebaseStorage(productFolder);

    // Tải lên các hình ảnh mới
    await uploadImagesToFirebaseStorage(
        imageFiles: imageFiles, productFolder: productFolder);

    try {
      // Cập nhật thông tin sản phẩm trong Firestore
      Map<String, dynamic> productMap = {
        "id": product.id,
        "name": product.name,
        "image": product.image,
        "description": product.description,
        "price": product.price,
        "type": product.type,
        "mass": product.mass,
        "uploadBy": product.uploadBy,
        "uploadDate": product.uploadDate,
        "editDate": product.editDate
      };

      await FirebaseFirestore.instance
          .collection('PRODUCTS')
          .doc(product.id)
          .update(productMap);

      return true;
    } on FirebaseException catch (e) {
      CommonFunc.showToast("Đã có lỗi xảy ra.");
    } catch (e) {
      CommonFunc.showToast("Đã có lỗi xảy ra.");
    }
  } else {
    // Cập nhật thông tin sản phẩm khi không có hình ảnh mới
    try {
      Map<String, dynamic> productMap = {
        "id": product.id,
        "name": product.name,
        "image": product.image,
        "description": product.description,
        "price": product.price,
        "type": product.type,
        "uploadBy": product.uploadBy,
        "mass": product.mass,
        "uploadDate": product.uploadDate,
        "editDate": product.editDate
      };

      await FirebaseFirestore.instance
          .collection('PRODUCTS')
          .doc(product.id)
          .update(productMap);
      return true;
    } on FirebaseException catch (e) {
      CommonFunc.showToast("Đã có lỗi xảy ra.");
    } catch (e) {
      CommonFunc.showToast("Đã có lỗi xảy ra.");
    }
  }
  return false;
}

// Hàm xóa tất cả các ảnh trong thư mục `product/product.id`
Future<void> deleteImagesInFirebaseStorage(String productFolder) async {
  try {
    final storageRef = FirebaseStorage.instance.ref().child(productFolder);
    await storageRef.listAll().then((result) {
      result.items.forEach((imageRef) async {
        await imageRef.delete();
      });
    });
  } on FirebaseException catch (e) {
    print("Firebase Storage Error: ${e.toString()}");
    throw e;
  }
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

        // Tách tên sản phẩm thành các từ riêng biệt
        List<String> productNameWords =
            product.name.toLowerCase().split(' ');

        // Chuyển từ khóa tìm kiếm về chữ thường để so sánh không phân biệt chữ hoa chữ thường
        String searchTermLower = searchTerm.toLowerCase();

        // Kiểm tra xem từ khóa có xuất hiện trong danh sách từ của tên sản phẩm hay không
        if (productNameWords.contains(searchTermLower)) {
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
