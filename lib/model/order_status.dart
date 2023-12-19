enum OrderStatus { NEW, PROCESSING, DONE, CANCEL}

extension ParseToString on OrderStatus {
  String toShortString() {
    return toString().split('.').last;
  }
}
