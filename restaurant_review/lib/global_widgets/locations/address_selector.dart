import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:restaurant_review/global_widgets/input_fields/autocomplete_field.dart';

class AddressSelectorController extends GetxController {
  var provinces = <Map<String, dynamic>>[].obs;
  var districts = <Map<String, dynamic>>[].obs;
  var wards = <Map<String, dynamic>>[].obs;

  RxString selectedProvince = ''.obs;
  RxString selectedDistrict = ''.obs;
  RxString selectedWard = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProvinces();
  }

  void setDefaultAddress(
      {required String provinceCode,
      required String districtCode,
      required String wardCode}) {
    selectedProvince.value = provinceCode;
    selectedDistrict.value = districtCode;
    selectedWard.value = wardCode;
    final tempProvince = provinces.firstWhere((p) => p['Code'] == provinceCode);
    // Convert each district to Map<String, dynamic> explicitly
    districts.value = ((tempProvince['District'] as List)
        .map((d) => Map<String, dynamic>.from(d))
        .toList());

    final tempDistrict = districts.firstWhere((d) => d['Code'] == districtCode);
    // Convert each ward to Map<String, dynamic> explicitly
    wards.value = ((tempDistrict['Ward'] as List)
        .map((w) => Map<String, dynamic>.from(w))
        .toList());
  }

  Future<void> loadProvinces() async {
    final String response =
        await rootBundle.loadString('assets/addresses/vi.json');
    provinces.value = List<Map<String, dynamic>>.from(json.decode(response));
  }

  void selectProvince(String provinceCode) {
    selectedProvince.value = provinceCode;
    selectedDistrict.value = '';
    selectedWard.value = '';

    final temp = provinces.firstWhere((p) => p['Code'] == provinceCode);
    // Convert each district to Map<String, dynamic> explicitly
    districts.clear();
    districts.value = ((temp['District'] as List)
        .map((d) => Map<String, dynamic>.from(d))
        .toList());

    wards.clear();
  }

  void selectDistrict(String districtCode) {
    selectedDistrict.value = districtCode;
    selectedWard.value = '';

    final temp = districts.firstWhere((d) => d['Code'] == districtCode);
    // Convert each ward to Map<String, dynamic> explicitly
    wards.clear();
    wards.value = ((temp['Ward'] as List)
        .map((w) => Map<String, dynamic>.from(w))
        .toList());
  }

  void selectWard(String wardCode) {
    selectedWard.value = wardCode;
  }

  String getFormattedAddress() {
    final province = provinces.firstWhereOrNull(
        (p) => p['Code'] == selectedProvince.value)?['FullName'];
    final district = districts.firstWhereOrNull(
        (d) => d['Code'] == selectedDistrict.value)?['FullName'];
    final ward = wards
        .firstWhereOrNull((w) => w['Code'] == selectedWard.value)?['FullName'];

    // Create a list of non-null, non-empty components
    final addressComponents = [ward, district, province]
        .where((component) => component != null && component.isNotEmpty)
        .toList();

    // Join the components with ", " as a separator
    return addressComponents.join(', ');
  }
}

class AddressSelectorView extends StatelessWidget {
  final AddressSelectorController controller;

  const AddressSelectorView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () => _showAddressModal(context),
          child:
              Text(FlutterI18n.translate(context, "location.select_address")),
        ),
        const SizedBox(width: 10),
        Obx(() {
          return Expanded(
            child: Text(
              controller.getFormattedAddress(),
              style: const TextStyle(fontSize: 16),
            ),
          );
        }),
      ],
    );
  }

  void _showAddressModal(BuildContext context) {
    Get.defaultDialog(
      title: FlutterI18n.translate(context, "location.select_address"),
      content: SizedBox(
        width: Get.size.width * 0.9,
        child: Column(
          children: [
            Obx(() => _buildAutocompleteField(
                  context,
                  label: FlutterI18n.translate(context, "location.province"),
                  suggestions: controller.provinces
                      .map((p) => {
                            "name": p['FullName'].toString(),
                            "value": p['Code'].toString()
                          })
                      .toList(),
                  onSelected: (selected) {
                    if (selected == null) return;
                    controller.selectProvince(selected);
                  },
                  defaultValue: controller.selectedProvince.value.isEmpty
                      ? null
                      : controller.selectedProvince.value,
                )),
            Obx(() {
              if (controller.districts.isNotEmpty) {
                return _buildAutocompleteField(
                  context,
                  label: FlutterI18n.translate(context, "location.district"),
                  suggestions: controller.districts
                      .map((d) => {
                            "name": d['FullName'].toString(),
                            "value": d['Code'].toString()
                          })
                      .toList(),
                  onSelected: (selected) {
                    if (selected == null) return;
                    controller.selectDistrict(selected);
                  },
                  defaultValue: controller.selectedDistrict.value.isEmpty
                      ? null
                      : controller.selectedDistrict.value,
                );
              }
              return const SizedBox();
            }),
            Obx(() {
              if (controller.wards.isNotEmpty) {
                return _buildAutocompleteField(
                  context,
                  label: FlutterI18n.translate(context, "location.ward"),
                  suggestions: controller.wards
                      .map((w) => {
                            "name": w['FullName'].toString(),
                            "value": w['Code'].toString()
                          })
                      .toList(),
                  onSelected: (selected) {
                    if (selected == null) return;
                    controller.selectWard(selected);
                  },
                  defaultValue: controller.selectedWard.value.isEmpty
                      ? null
                      : controller.selectedWard.value,
                );
              }
              return const SizedBox();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAutocompleteField(BuildContext context,
      {required String label,
      required List<Map<String, String>> suggestions,
      required ValueChanged<String?> onSelected,
      String? defaultValue}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: MyAutocompleteField(
        key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
        label: label,
        suggestions: suggestions,
        onSelected: (selected) {
          onSelected(selected);
        },
        defaultValue: defaultValue,
      ),
    );
  }
}
