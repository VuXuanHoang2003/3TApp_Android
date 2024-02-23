import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:three_tapp_app/data/repositories/statistic_repo/statistic_repo.dart';
import 'package:three_tapp_app/model/statistic.dart';

class StatisticRepoImpl extends StatisticRepo {
  static Statistic statistic = Statistic(
      numberOfPosts: 0,
      numberOfSuccessfulTrade: 0,
      glassRevenue: 0,
      metalRevenue: 0,
      otherRevenue: 0,
      paperRevenue: 0,
      plasticRevenue: 0);
  @override
  Future<Statistic> getStatistic(String? email) async {
    print(email);
    // TODO: implement getStatistic
    try {
      await FirebaseFirestore.instance
          .collection("PRODUCTS")
          .where("uploadBy", isEqualTo: email)
          .get()
          .then((querySnapshot) {
        statistic.numberOfPosts = querySnapshot.docs.length;
        print("Tổng số sản phẩm đã đăng: ${statistic.numberOfPosts}");
      });

      await FirebaseFirestore.instance
          .collection("ORDERS")
          .where("status", isEqualTo: "DONE")
          .where("seller_email", isEqualTo: email)
          .get()
          .then((querySnapshot) {
        statistic.numberOfSuccessfulTrade = querySnapshot.size;
        print(
            "Tổng số lượng đơn hàng đã giao dịch thành công công: ${statistic.numberOfSuccessfulTrade}");
      });

      await FirebaseFirestore.instance
          .collection("ORDERS")
          .where("status", isEqualTo: "DONE")
          .where("seller_email", isEqualTo: email)
          .where("type", isEqualTo: "kim_loai")
          .get()
          .then((querySnapshot) {
        statistic.metalRevenue = 0;
        querySnapshot.docs.forEach((doc) {
          // Thực hiện các thao tác với từng phần tử doc ở đây
          var data = doc.data();
          // Ví dụ: Lấy giá trị của trường "fieldName"
          print(data['product_mass']);
          print(data['product_price']);
          var product_mass = double.parse(data['product_mass'].toString());
          var product_price = double.parse(data['product_price'].toString());

          statistic.metalRevenue += (product_mass * product_price);
          // Tiếp tục xử lý dữ liệu ở đây
        });
      });

      await FirebaseFirestore.instance
          .collection("ORDERS")
          .where("status", isEqualTo: "DONE")
          .where("seller_email", isEqualTo: email)
          .where("type", isEqualTo: "nhua")
          .get()
          .then((querySnapshot) {
        statistic.plasticRevenue = 0;
        querySnapshot.docs.forEach((doc) {
          // Thực hiện các thao tác với từng phần tử doc ở đây
          var data = doc.data();
          // Ví dụ: Lấy giá trị của trường "fieldName"
          print(data['product_mass']);
          print(data['product_price']);
          var product_mass = double.parse(data['product_mass'].toString());
          var product_price = double.parse(data['product_price'].toString());

          statistic.plasticRevenue += (product_mass * product_price);
          // Tiếp tục xử lý dữ liệu ở đây
        });
      });

      await FirebaseFirestore.instance
          .collection("ORDERS")
          .where("status", isEqualTo: "DONE")
          .where("seller_email", isEqualTo: email)
          .where("type", isEqualTo: "giay")
          .get()
          .then((querySnapshot) {
        statistic.paperRevenue = 0;
        querySnapshot.docs.forEach((doc) {
          // Thực hiện các thao tác với từng phần tử doc ở đây
          var data = doc.data();
          // Ví dụ: Lấy giá trị của trường "fieldName"
          print(data['product_mass']);
          print(data['product_price']);
          var product_mass = double.parse(data['product_mass'].toString());
          var product_price = double.parse(data['product_price'].toString());

          statistic.paperRevenue += (product_mass * product_price);
          // Tiếp tục xử lý dữ liệu ở đây
        });
      });

      await FirebaseFirestore.instance
          .collection("ORDERS")
          .where("status", isEqualTo: "DONE")
          .where("seller_email", isEqualTo: email)
          .where("type", isEqualTo: "thuy_tinh")
          .get()
          .then((querySnapshot) {
        statistic.glassRevenue = 0;
        querySnapshot.docs.forEach((doc) {
          // Thực hiện các thao tác với từng phần tử doc ở đây
          var data = doc.data();
          // Ví dụ: Lấy giá trị của trường "fieldName"
          print(data['product_mass']);
          print(data['product_price']);
          var product_mass = double.parse(data['product_mass'].toString());
          var product_price = double.parse(data['product_price'].toString());

          statistic.glassRevenue += (product_mass * product_price);
          // Tiếp tục xử lý dữ liệu ở đây
        });
      });

      await FirebaseFirestore.instance
          .collection("ORDERS")
          .where("status", isEqualTo: "DONE")
          .where("seller_email", isEqualTo: email)
          .where("type", isEqualTo: "khac")
          .get()
          .then((querySnapshot) {
        statistic.otherRevenue = 0;
        querySnapshot.docs.forEach((doc) {
          // Thực hiện các thao tác với từng phần tử doc ở đây
          var data = doc.data();
          // Ví dụ: Lấy giá trị của trường "fieldName"
          print(data['product_mass']);
          print(data['product_price']);
          var product_mass = double.parse(data['product_mass'].toString());
          var product_price = double.parse(data['product_price'].toString());

          statistic.otherRevenue += (product_mass * product_price);
          // Tiếp tục xử lý dữ liệu ở đây
        });
      });

      statistic.valuateRevenues();
    } catch (error) {
      print("error:${error.toString()}");
    }
    return statistic;
  }
}
