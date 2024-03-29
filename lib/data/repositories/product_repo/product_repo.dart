import 'dart:io';

import '../../../model/product.dart';


abstract class ProductRepo {
  Future<List<Product>> getAllProduct();
  Future<bool> addProduct({required Product product, required List<File> imageFiles});
  Future<bool> updateProduct({required Product product, required File? imageFile});
  Future<bool> deleteProduct({required String productId});
  Future<List<Product>> searchProducts(String searchTerm);



}