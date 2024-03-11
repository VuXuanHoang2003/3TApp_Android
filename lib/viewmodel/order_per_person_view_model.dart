import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:three_tapp_app/model/product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderPerPersonViewModel {
  final String address;
  late final StreamController<List<Product>> _ordersController =
      StreamController<List<Product>>();
  late Map<String, dynamic> _userData;

  OrderPerPersonViewModel({required this.address});

  Stream<List<Product>> get ordersStream => _ordersController.stream;
  Map<String, dynamic> get userData => _userData;

  void dispose() {
    _ordersController.close();
  }

  Future<void> loadData() async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('USERS')
          .where('address', isEqualTo: address)
          .get();
      _userData = userSnapshot.docs.first.data();

      final gmail = _userData['email'];
      final orderSnapshot = await FirebaseFirestore.instance
          .collection('PRODUCTS')
          .where('uploadBy', isEqualTo: gmail)
          .get();
      final orders = orderSnapshot.docs
          .map((doc) => Product(
                id: doc['id'],
                name: doc['name'],
                image: doc['image'],
                mass: doc['mass'],
                type: doc['type'],
                price: doc['price'],
                description: doc['description'],
                editDate: doc['editDate'],
                uploadBy: doc['uploadBy'],
                uploadDate: doc['uploadDate'],
              ))
          .toList();

      // Add orders to stream
      _ordersController.add(orders);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error fetching user data and orders: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
