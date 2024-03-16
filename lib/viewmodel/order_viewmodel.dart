import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:json_path/fun_extra.dart';
import 'package:rxdart/rxdart.dart';
import 'package:three_tapp_app/data/repositories/auth_repo/auth_repo_impl.dart';

import '../base/baseviewmodel/base_viewmodel.dart';
import '../data/repositories/order_repo/order_repo.dart';
import '../data/repositories/order_repo/order_repo_impl.dart';
import '../model/my_order.dart';
import '../model/order_status.dart';
import '../model/status.dart';
import '../utils/common_func.dart';
import 'notification_viewmodel.dart';

class OrderViewModel extends BaseViewModel {
  static final OrderViewModel _instance = OrderViewModel._internal();

  factory OrderViewModel() {
    return _instance;
  }

  OrderViewModel._internal();

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

  Future<void> getAllOrder() async {
    orders.clear();
    getOrderController.sink.add(Status.loading);
    EasyLoading.show();
    orderRepo.getAllOrder().then((value) {
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

  Future<void> getAllOrderSignedIn(bool isSignedIn) async {
    orders.clear();
    getOrderController.sink.add(Status.loading);
    EasyLoading.show();
    orderRepo.getAllOrderSignedIn(isSignedIn).then((value) {
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

  Future<void> createOrder({required MyOrder order}) async {
    orderRepo.createOrder(order: order).then((value) async {
      if (value == true) {
        CommonFunc.showToast("Tạo đơn thành công.");
        NotificationViewModel().newOrderNotification();
      }
    }).onError((error, stackTrace) {
      print("create order fail");
    });
  }

  // Future<void> updateOrderStatus(
  //     {required String orderId, required String newStatus}) async {
  //   await orderRepo
  //       .updateOrderStatus(orderId: orderId, newStatus: newStatus)
  //       .then((value) async {
  //     if (value == true) {
  //       CommonFunc.showToast("Cập nhật thành công.");
  //       await getAllOrder();
  //     }
  //   }).onError((error, stackTrace) {
  //     print("update fail");
  //   });
  // }
  Future<void> updateOrderStatus(
      {required String orderId, required String newStatus}) async {
    // Lưu trữ danh sách các trạng thái theo thứ tự tăng dần
    List<String> statusList = [
      OrderStatus.NEW.toShortString(),
      OrderStatus.PROCESSING.toShortString(),
      OrderStatus.DONE.toShortString(),
      OrderStatus.CANCEL.toShortString()
    ];

    // Xác định trạng thái hiện tại của đơn hàng
    String currentStatus = await getOrderStatus(orderId);

    // Xác định vị trí của newStatus trong danh sách
    int newIndex = statusList.indexOf(newStatus);

    // Xác định vị trí của trạng thái hiện tại trong danh sách
    int currentIndex = statusList.indexOf(currentStatus);

    if ((newStatus == OrderStatus.CANCEL.toShortString() &&
            currentStatus == OrderStatus.NEW.toShortString()) ||
        (newIndex > currentIndex &&
            currentStatus != OrderStatus.DONE.toShortString())) {
      await orderRepo
          .updateOrderStatus(orderId: orderId, newStatus: newStatus)
          .then((value) async {
        if (value == true) {
          CommonFunc.showToast("Cập nhật thành công.");
          await getAllOrder();
        }
      }).onError((error, stackTrace) {
        CommonFunc.showToast("Cập nhật thất bại.");
      });
    } else {
      CommonFunc.showToast("Không cập nhật được.");
    }
  }

  Future<String> getOrderStatus(String orderId) async {
    String currentStatus = ''; // Trạng thái hiện tại của đơn hàng

    try {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('ORDERS')
          .doc(orderId)
          .get();
      currentStatus = documentSnapshot.data()?['status'] ?? '';
    } catch (error) {
      print('Lỗi khi lấy trạng thái đơn hàng: $error');
    }

    return currentStatus; // Trả về trạng thái hiện tại của đơn hàng
  }

  Future<bool> isOrderDone(String orderId) async {
    try {
      // Gọi hàm từ productRepo để kiểm tra

      return await orderRepo.isOrderDone(orderId);
    } catch (error) {
      print("Lỗi khi kiểm tra tình trạng đơn hàng: $error");
      return false;
    }
  }

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

  Future<List<String>> getUserInfo(String email) {
    return AuthRepoImpl().getUserInfoWidget(email);
  }
}
