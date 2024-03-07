
enum ScrapType { giay, nhua, kim_loai, thuy_tinh, khac }

extension ParseToString on ScrapType {
  String toShortString() {
    return toString().split('.').last;
  }
}
