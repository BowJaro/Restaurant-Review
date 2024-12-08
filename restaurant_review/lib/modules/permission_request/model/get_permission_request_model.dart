class GetPermissionRequestModel {
  final int id;
  final String? name;
  final String? phone;
  final String street;
  final String provinceId;
  final String districtId;
  final String wardId;
  final List<String> imageList;
  final String permission;
  final DateTime createdAt;
  final String status;

  GetPermissionRequestModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.street,
    required this.provinceId,
    required this.districtId,
    required this.wardId,
    required this.imageList,
    required this.permission,
    required this.createdAt,
    required this.status,
  });

  factory GetPermissionRequestModel.fromMap(Map<String, dynamic> map) {
    return GetPermissionRequestModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      street: map['street'],
      provinceId: map['province_id'],
      districtId: map['district_id'],
      wardId: map['ward_id'],
      imageList: List<String>.from(map['image_list']),
      permission: map['permission'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      status: map['status'],
    );
  }
}
