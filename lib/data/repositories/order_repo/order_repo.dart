import '../../../model/my_order.dart';

abstract class OrderRepo {
  Future<List<MyOrder>> getAllOrder();

  Future<List<MyOrder>> getOrderByUser();

  Future<bool> createOrder({required MyOrder order});

  Future<bool> updateOrderStatus(
      {required String orderId, required String newStatus});

  Future<bool> updateOrderInfo({required MyOrder newOrder});
// Future<bool> deleteOrder({required String productId});
}
