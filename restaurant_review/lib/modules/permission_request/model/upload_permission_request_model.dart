class UploadPermissionRequestModel {
  final String name;
  final String province;
  final String district;
  final String ward;
  final String street;
  final String phone;
  final String permission;
  final List<dynamic> imageList;
  final String profileId;

  UploadPermissionRequestModel({
    required this.name,
    required this.province,
    required this.district,
    required this.ward,
    required this.street,
    required this.phone,
    required this.permission,
    required this.imageList,
    required this.profileId,
  });
}
