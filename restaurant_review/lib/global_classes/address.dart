class Address {
  final String province;
  final String district;
  final String ward;

  Address({required this.province, required this.district, required this.ward});

  @override
  String toString() {
    String wardString = ward.isEmpty ? '' : '$ward, ';
    return '$wardString$district, $province';
  }
}
