enum RolesType { none, customer, seller }

extension ParseToString on RolesType {
  String toShortString() {
    return toString().split('.').last;
  }
}
