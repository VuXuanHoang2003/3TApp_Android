import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:three_tapp_app/model/scrap_type.dart';
import 'package:rxdart/rxdart.dart';

import '../base/baseviewmodel/base_viewmodel.dart';
import '../data/repositories/product_repo/product_repo.dart';
import '../data/repositories/product_repo/product_repo_impl.dart';
import '../model/product.dart';
import '../model/roles_type.dart';
import '../model/status.dart';
import '../utils/common_func.dart';
import 'notification_viewmodel.dart';

class ProductViewModel extends BaseViewModel {
  static final ProductViewModel _instance = ProductViewModel._internal();
  TextEditingController searchBarController = TextEditingController();

  factory ProductViewModel() {
    return _instance;
  }

  ProductViewModel._internal();

  ProductRepo productRepo = ProductRepoImpl();

  RolesType rolesType = RolesType.none;

  List<Product> products = [];
  List<Product> listGiay = [];
  List<Product> listNhua = [];
  List<Product> listKimLoai = [];
  List<Product> listThuytinh = [];
  List<Product> listGiayKhac = [];

  final StreamController<Status> getProductController =
      BehaviorSubject<Status>();

  Stream<Status> get getProductStream => getProductController.stream;

  @override
  FutureOr<void> init() {}

  onRolesChanged(RolesType rolesType) {
    this.rolesType = rolesType;
    notifyListeners();
  }

  Future<void> getAllProduct() async {
    products.clear();
    getProductController.sink.add(Status.loading);
    EasyLoading.show();
    productRepo.getAllProduct().then((value) {
      if (value.isNotEmpty) {
        products = value;
        //filter product by type
        filterProductByType();
        notifyListeners();
        getProductController.sink.add(Status.completed);
      }
      EasyLoading.dismiss();
    }).onError((error, stackTrace) {
      print("get senda error:${error.toString()}");
      getProductController.sink.add(Status.error);
      EasyLoading.dismiss();
    });
  }

  Future<void> addProduct(
      {required Product product, required File? imageFile}) async {
    await productRepo
        .addProduct(product: product, imageFile: imageFile)
        .then((value) async {
      if (value == true) {
        CommonFunc.showToast("Thêm thành công.");
        await getAllProduct();
        NotificationViewModel().newProductNotification();
      }
    }).onError((error, stackTrace) {
      print("add fail");
    });
  }

  Future<void> updateProduct(
      {required Product product, required File? imageFile}) async {
    await productRepo
        .updateProduct(product: product, imageFile: imageFile)
        .then((value) async {
      if (value == true) {
        CommonFunc.showToast("Cập nhật thành công.");
        await getAllProduct();
      }
    }).onError((error, stackTrace) {
      print("update fail");
    });
  }

  Future<List<Product>> searchProduct(BuildContext context) async {
  String searchTerm = searchBarController.text.trim();
  print("VM searchTerm: $searchTerm");

  if (searchTerm.isNotEmpty) {
    try {
      List<Product> searchResults = await productRepo.searchProducts(searchTerm);

      if (searchResults.isNotEmpty) {
        print('Products found: ${searchResults.length}');
        return searchResults;
      } else {
        print('No search results found.');
        CommonFunc.showToast("Không có kết quả tìm kiếm.");
        return [];
      }
    } catch (error) {
      print("searchProduct error: ${error.toString()}");
      CommonFunc.showToast("Đã có lỗi xảy ra khi tìm kiếm.");
      return [];
    }
  } else {
    print('Empty search term provided.');
    CommonFunc.showToast("Vui lòng nhập từ khóa tìm kiếm(vm)");
    return [];
  }
}


  void deleteProduct({required String productId}) {
    productRepo.deleteProduct(productId: productId).then((value) {
      if (value == true) {
        CommonFunc.showToast("Xóa thành công.");
        //reload product
        getAllProduct();
      }
    }).onError((error, stackTrace) {
      print("add fail");
    });
  }

  void clearAllList() {
    listGiay.clear();
    listNhua.clear();
    listKimLoai.clear();
    listThuytinh.clear();
    listGiayKhac.clear();
  }

  void filterProductByType() {
    //clear all list
    clearAllList();

    //filter
    for (var element in products) {
      if (element.type == ScrapType.giay.toShortString()) {
        listGiay.add(element);
      } else if (element.type == ScrapType.nhua.toShortString()) {
        listNhua.add(element);
      } else if (element.type == ScrapType.kim_loai.toShortString()) {
        listKimLoai.add(element);
      } else if (element.type == ScrapType.thuy_tinh.toShortString()) {
        listThuytinh.add(element);
      } else {
        listGiayKhac.add(element);
      }
    }
  }
}
