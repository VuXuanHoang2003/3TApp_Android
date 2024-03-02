import 'order_status.dart';

class MyOrder {
  String id = '';
  String productImage = '';
  String productName = '';
  double productPrice = 0;
  int productQuantity = 1;
  String customerName = '';
  double productMass=0;
  String type='';
  ///Thuoc tinh nay de duoc gan theo user
  String customerEmail = '';
  String phoneNumber = '';
  String address = '';
  String status = OrderStatus.NEW.toShortString();
  String createDate = DateTime.now().toString();
  String updateDate = DateTime.now().toString();
  String sellerEmail = '';

  MyOrder(
      {required this.id,
      required this.productImage,
      required this.productName,
      required this.productPrice,
      required this.productQuantity,
      required this.type,
      required this.customerName,
      required this.customerEmail,
      required this.phoneNumber,
      required this.address,
      required this.status,
      required this.createDate,
      required this.productMass,
      required this.updateDate,
      required this.sellerEmail});

  MyOrder.empty() {
    id = '';
    productImage = '';
    productName = '';
    productPrice = 0;
    productQuantity = 1;
    customerName = '';
    customerEmail = '';
    phoneNumber = '';
    productMass=0;
    type='';
    address = '';
    status = OrderStatus.NEW.toShortString();
    createDate = DateTime.now().toString();
    updateDate = DateTime.now().toString();
    sellerEmail = '';
  }

  MyOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productImage = json['product_image'];
    productName = json['product_name'];
    productPrice = json['product_price'];
    productMass=json['product_mass'];
    type=json['type'];
    productQuantity = json['product_quantity'];
    customerName = json['customer_name'];
    customerEmail = json['customer_email'];
    phoneNumber = json['phone_number'];
    address = json['address'];
    status = json['status'];
    createDate = json['create_date'];
    updateDate = json['update_date'];
    sellerEmail = json['seller_email'];
  }
}
