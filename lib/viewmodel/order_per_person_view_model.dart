import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:three_tapp_app/model/product.dart';

class OrderPerPersonViewModel {
  final String address;

  OrderPerPersonViewModel({required this.address});

  final _ordersController = BehaviorSubject<List<Product>>();

  Stream<List<Product>> get ordersStream => _ordersController.stream;

  void loadData() async {
    try {
      final userSnapshot = await FirebaseFirestore.instance.collection('USERS').where('address', isEqualTo: address).get();
      final userData = userSnapshot.docs.first.data();

      final gmail = userData['email'];
      final orderSnapshot = await FirebaseFirestore.instance.collection('PRODUCTS').where('uploadBy', isEqualTo: gmail).get();
      final orders = orderSnapshot.docs.map((doc) => Product(
        id: doc['id'],
        name: doc['name'],
        image: doc['image'],
        type: doc['type'],
        price: doc['price'],
        description: doc['description'],
        editDate: doc['editDate'],
        uploadBy: doc['uploadBy'],
        uploadDate: doc['uploadDate'],
      )).toList();

      _ordersController.add(orders);
    } catch (e) {
      _ordersController.addError(e);
    }
  }

  void dispose() {
    _ordersController.close();
  }
}
