import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../model/my_order.dart';
import '../../../utils/common_func.dart';
import 'order_repo.dart';

class OrderRepoImpl with OrderRepo {
  @override
  Future<bool> createOrder({required MyOrder order}) async {
    log("order quantity:${order.productQuantity}");
    try {
      Map<String, dynamic> orderMap = {
        "id": order.id,
        "product_image": order.productImage,
        "product_name": order.productName,
        "product_price": order.productPrice,
        "product_quantity": order.productQuantity,
        "customer_name": order.customerName,
        "customer_email": order.customerEmail,
        "phone_number": order.phoneNumber,
        "product_mass": order.productMass,
        "address": order.address,
        "status": order.status,
        "create_date": order.createDate,
        "type": order.type,
        "update_date": order.updateDate,
        "seller_email": order.sellerEmail
      };

      await FirebaseFirestore.instance
          .collection('ORDERS')
          .doc(order.id)
          .set(orderMap)
          .then((value) {})
          .catchError((error) {
        CommonFunc.showToast("Lỗi gửi yêu cầu.");
        print("error:${error.toString()}");
        return Future.value(false);
      });
      return Future.value(true);
    } on FirebaseException {
      CommonFunc.showToast("Đã có lỗi xảy ra.");
    } catch (e) {
      CommonFunc.showToast("Đã có lỗi xảy ra.");
    }
    return Future.value(false);
  }

  @override
  Future<List<MyOrder>> getAllOrder() async {
    List<MyOrder> orders = [];

    try {
      await FirebaseFirestore.instance
          .collection("ORDERS")
          .get()
          .then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          orders.add(MyOrder.fromJson(result.data()));
        }
        print("order length:${orders.length}");
      });
      return orders;
    } catch (error) {
      print("error:${error.toString()}");
    }

    return [];
  }

  @override
  // Future<List<MyOrder>> getOrderByUser() async {
  //   List<MyOrder> orders = [];

  //   try {
  //     await FirebaseFirestore.instance
  //         .collection("ORDERS")
  //         .get()
  //         .then((querySnapshot) {
  //       for (var result in querySnapshot.docs) {
  //         MyOrder myOrder = MyOrder.fromJson(result.data());
  //         if (myOrder.customerEmail ==
  //             FirebaseAuth.instance.currentUser?.email) {
  //           orders.add(MyOrder.fromJson(result.data()));
  //         }
  //       }
  //       print("order length:${orders.length}");
  //     });
  //     return orders;
  //   } catch (error) {
  //     print("error:${error.toString()}");
  //   }

  //   return [];
  // }
  Future<List<MyOrder>> getOrderByUser() async {
    List<MyOrder> orders = [];

    try {
      // Lấy danh sách đơn hàng từ Firestore
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("ORDERS").get();

      // Lặp qua từng document trong danh sách đơn hàng
      querySnapshot.docs.forEach((DocumentSnapshot document) {
        // Tạo đối tượng MyOrder từ dữ liệu của document
        MyOrder myOrder =
            MyOrder.fromJson(document.data() as Map<String, dynamic>);

        // Kiểm tra xem đơn hàng có phải của người dùng hiện tại không
        if (myOrder.customerEmail == FirebaseAuth.instance.currentUser?.email) {
          orders.add(
              myOrder); // Thêm đơn hàng vào danh sách nếu là của người dùng hiện tại
        }
      });

      print("Số lượng đơn hàng của người dùng: ${orders.length}");
    } catch (error) {
      print("Lỗi khi lấy đơn hàng: ${error.toString()}");
    }

    return orders; // Trả về danh sách đơn hàng đã lấy được
  }

  @override
  Future<bool> updateOrderStatus(
      {required String orderId, required String newStatus}) {
    try {
      //Update order status
      Map<String, dynamic> orderMap = {
        "status": newStatus,
      };

      FirebaseFirestore.instance
          .collection('ORDERS')
          .doc(orderId)
          .update(orderMap);
      return Future.value(true);
    } on FirebaseException {
      CommonFunc.showToast("Đã có lỗi xảy ra.");
    } catch (e) {
      CommonFunc.showToast("Đã có lỗi xảy ra.");
    }
    return Future.value(false);
  }

  @override
  Future<bool> updateOrderInfo({required MyOrder newOrder}) {
    try {
      //Update order data
      Map<String, dynamic> orderMap = {
        "id": newOrder.id,
        "product_quantity": newOrder.productQuantity,
        "customer_name": newOrder.customerName,
        "phone_number": newOrder.phoneNumber,
        "address": newOrder.address,
        "status": newOrder.status,
        "update_date": newOrder.updateDate,
        "product_mass": newOrder.productMass,
      };

      FirebaseFirestore.instance
          .collection('ORDERS')
          .doc(newOrder.id)
          .update(orderMap);
      return Future.value(true);
    } on FirebaseException {
      CommonFunc.showToast("Đã có lỗi xảy ra.");
    } catch (e) {
      CommonFunc.showToast("Đã có lỗi xảy ra.");
    }
    return Future.value(false);
  }

  Future<bool> isOrderDone(String orderId) async {
    try {
      // Tìm kiếm đơn hàng trong cơ sở dữ liệu
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('ORDERS')
          .doc(orderId)
          .get();

      // Kiểm tra nếu tìm thấy đơn hàng và trạng thái là "done"
      if (snapshot.exists) {
        MyOrder order =
            MyOrder.fromJson(snapshot.data() as Map<String, dynamic>);
        return order.status.toLowerCase() == 'done';
      } else {
        // Không tìm thấy đơn hàng
        return false;
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error checking order status: $e');
      return false;
    }
  }

  @override
  Future<List<MyOrder>> getAllOrderSignedIn(bool isSignedIn) async {
    List<MyOrder> orders = [];

    try {
      if (FirebaseAuth.instance.currentUser!.email != null) {
        await FirebaseFirestore.instance
            .collection("ORDERS")
            .where("seller_email",
                isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .get()
            .then((querySnapshot) {
          for (var result in querySnapshot.docs) {
            orders.add(MyOrder.fromJson(result.data()));
          }
          print("order length:${orders.length}");
        });
      }

      return orders;
    } catch (error) {
      print("error:${error.toString()}");
    }

    return [];
  }

  
}
