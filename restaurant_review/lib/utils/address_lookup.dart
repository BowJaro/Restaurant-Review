import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:restaurant_review/global_classes/address.dart';

Future<List<dynamic>> loadAddressData() async {
  final String response =
      await rootBundle.loadString('assets/addresses/vi.json');
  return json.decode(response);
}

Future<Address?> getAddressName(
    String provinceId, String districtId, String wardId) async {
  final data = await loadAddressData();

  // Find the province
  final province =
      data.firstWhere((prov) => prov['Code'] == provinceId, orElse: () => null);
  if (province == null) return null;

  final provinceName = province['FullName'];

  // Find the district
  final district = province['District']?.firstWhere(
    (dist) => dist['Code'] == districtId,
    orElse: () => null,
  );
  if (district == null) return provinceName;

  final districtName = district['FullName'];

  // Find the ward
  final ward = district['Ward']?.firstWhere(
    (w) => w['Code'] == wardId,
    orElse: () => null,
  );
  final wardName = ward?['FullName'] ?? '';

  return Address(
      province: provinceName, district: districtName, ward: wardName);
}
