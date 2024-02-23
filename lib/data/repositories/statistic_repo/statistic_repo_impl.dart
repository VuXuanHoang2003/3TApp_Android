import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:three_tapp_app/data/repositories/statistic_repo/statistic_repo.dart';
import 'package:three_tapp_app/model/statistic.dart';

class StatisticRepoImpl extends StatisticRepo {
  static Statistic statistic = Statistic(
      numberOfPosts: 0,
      numberOfSuccessfulTrade: 0,
      doanh_thu_giay: 0,
      doanh_thu_khac: 0,
      doanh_thu_kim_loai: 0,
      doanh_thu_nhua: 0,
      doanh_thu_thuy_tinh: 0);
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
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          // Thực hiện các thao tác với từng phần tử doc ở đây
          var data = doc.data();
          // Ví dụ: Lấy giá trị của trường "fieldName"
          var fieldValue = data['fieldName'];
          // Tiếp tục xử lý dữ liệu ở đây
        });
      });
    } catch (error) {
      print("error:${error.toString()}");
    }
    return statistic;
  }
}
