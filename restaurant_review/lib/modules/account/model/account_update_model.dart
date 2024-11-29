class AccountUpdateModel {
  String userId;
  String? userName;
  String? fullName;
  String? phone;
  dynamic imageUrl;

  AccountUpdateModel({
    required this.userId,
    required this.userName,
    required this.fullName,
    required this.phone,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'username': userName,
      'full_name': fullName,
      'phone': phone,
      'image_url': imageUrl,
    };
  }
}
