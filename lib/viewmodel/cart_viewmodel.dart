import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rxdart/rxdart.dart';

import '../base/baseviewmodel/base_viewmodel.dart';
import '../data/repositories/order_repo/order_repo.dart';
import '../data/repositories/order_repo/order_repo_impl.dart';
import '../model/my_order.dart';
import '../model/order_status.dart';
import '../model/status.dart';
import '../utils/common_func.dart';
import 'notification_viewmodel.dart';

class CartViewModel extends BaseViewModel {
  static final CartViewModel _instance = CartViewModel._internal();

  factory CartViewModel() {
    return _instance;
  }

  CartViewModel._internal();

  OrderRepo orderRepo = OrderRepoImpl();

  List<MyOrder> orders = [];
  List<MyOrder> newOrders = [];
  List<MyOrder> processingOrders = [];
  List<MyOrder> doneOrders = [];
  List<MyOrder> cancelOrders = [];

  final StreamController<Status> getOrderController = BehaviorSubject<Status>();

  Stream<Status> get getOrderStream => getOrderController.stream;

  @override
  FutureOr<void> init() {}

  Future<void> getOrderByUser() async {
    orders.clear();
    getOrderController.sink.add(Status.loading);
    EasyLoading.show();
    orderRepo.getOrderByUser().then((value) {
      if (value.isNotEmpty) {
        orders = value;
        //filter product by type
        filterOrderByType();
        notifyListeners();
        getOrderController.sink.add(Status.completed);
      }
      EasyLoading.dismiss();
    }).onError((error, stackTrace) {
      getOrderController.sink.add(Status.error);
      EasyLoading.dismiss();
    });
  }

  Future<void> updateOrderInfo({required MyOrder newOrder}) async {
    await orderRepo.updateOrderInfo(newOrder: newOrder).then((value) async {
      if (value == true) {
        CommonFunc.showToast("Cập nhật thành công.");
        await getOrderByUser();
        NotificationViewModel().updateOrderNotification();
      }
    }).onError((error, stackTrace) {
      print("update fail");
    });
  }

  Future<void> updateOrderStatus(
      {required String orderId, required String newStatus}) async {
    await orderRepo
        .updateOrderStatus(orderId: orderId, newStatus: newStatus)
        .then((value) async {
      if (value == true) {
        CommonFunc.showToast("Cập nhật thành công.");
        await getOrderByUser();
        NotificationViewModel().updateOrderNotification();
      }
    }).onError((error, stackTrace) {
      print("update fail");
    });
  }

  //
  // void deleteProduct({required String productId}) {
  //   orderRepo.deleteProduct(productId: productId).then((value) {
  //     if (value == true) {
  //       print("add success");
  //       CommonFunc.showToast("Xóa thành công.");
  //       //reload product
  //       getAllProduct();
  //     }
  //   }).onError((error, stackTrace) {
  //     print("add fail");
  //   });
  // }

  void clearAllList() {
    newOrders.clear();
    processingOrders.clear();
    doneOrders.clear();
    cancelOrders.clear();
  }

  void filterOrderByType() {
    //clear all list
    clearAllList();

    //filter
    for (var element in orders) {
      if (element.status == OrderStatus.NEW.toShortString()) {
        newOrders.add(element);
      } else if (element.status == OrderStatus.PROCESSING.toShortString()) {
        processingOrders.add(element);
      } else if (element.status == OrderStatus.DONE.toShortString()) {
        doneOrders.add(element);
      } else if (element.status == OrderStatus.CANCEL.toShortString()) {
        cancelOrders.add(element);
      }
    }
  }
}
