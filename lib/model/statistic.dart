class Statistic {
  int numberOfPosts = 0;
  int numberOfSuccessfulTrade = 0;

  double doanh_thu_kim_loai = 0;
  double doanh_thu_giay = 0;
  double doanh_thu_nhua = 0;
  double doanh_thu_thuy_tinh = 0;
  double doanh_thu_khac = 0;

  double doanh_thu = 0;

  Statistic(
      {required this.numberOfPosts,
      required this.numberOfSuccessfulTrade,
      required this.doanh_thu_kim_loai,
      required this.doanh_thu_giay,
      required this.doanh_thu_nhua,
      required this.doanh_thu_thuy_tinh,
      required this.doanh_thu_khac});

  valuateDoanhThu() {
    doanh_thu = doanh_thu_giay +
        doanh_thu_khac +
        doanh_thu_kim_loai +
        doanh_thu_nhua +
        doanh_thu_kim_loai;
  }

  Statistic.fromJson(Map<String, dynamic> json) {
    numberOfPosts = json['numberOfPosts'];
    numberOfSuccessfulTrade = json['numberOfSuccessfulTrade'];
    doanh_thu_kim_loai = json['doanh_thu_kim_loai'];
    doanh_thu_giay = json['doanh_thu_giay'];
    doanh_thu_nhua = json['doanh_thu_nhua'];
    doanh_thu_thuy_tinh = json['doanh_thu_thuy_tinh'];
    doanh_thu_khac = json['doanh_thu_khac'];
    doanh_thu = json['doanh_thu'];
  }
}
