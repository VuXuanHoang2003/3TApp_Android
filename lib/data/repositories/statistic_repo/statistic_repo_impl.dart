import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:three_tapp_app/data/repositories/statistic_repo/statistic_repo.dart';
import 'package:three_tapp_app/model/statistic.dart';

class StatisticRepoImpl extends StatisticRepo {
  static Statistic statistic =
      Statistic(numberOfPosts: 0, numberOfSuccessfulTrade: 0);
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
        print("Tổng số sản phẩm đang đăng: ${statistic.numberOfPosts}");
      });

      print("Tổng số sản phẩm đã đăng: ${statistic.numberOfPosts}");
      await FirebaseFirestore.instance
          .collection("ORDERS")
          .where("status", isEqualTo: "DONE")
          .get()
          .then((querySnapshot) {
        statistic.numberOfSuccessfulTrade = querySnapshot.size;
        print(
            "Tổng số lượng đơn hàng đã giao dịch thành công công: ${statistic.numberOfSuccessfulTrade}");
      });
    } catch (error) {
      print("error:${error.toString()}");
    }
    return statistic;
  }
}
