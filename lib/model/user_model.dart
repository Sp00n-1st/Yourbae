class UserModel {
  final String name, email, mobileNumberPhone, countryCode, countryNumberCode;
  final String? imageProfile, token;
  final bool isDisable;

  UserModel({
    required this.token,
    required this.email,
    required this.name,
    required this.countryCode,
    required this.countryNumberCode,
    required this.mobileNumberPhone,
    required this.imageProfile,
    required this.isDisable,
  });

  UserModel.fromJson(Map<String, dynamic>? json)
      : this(
          email: json!['email'] as String,
          token: json['token'] as String?,
          name: json['name'] as String,
          countryCode: json['country_code'] as String,
          countryNumberCode: json['country_number_code'] as String,
          mobileNumberPhone: json['mobile_number_phone'] as String,
          isDisable: json['is_disable'] as bool,
          imageProfile: json['image_profile'] as String?,
        );

  Map<String, Object?> toJson() {
    return {
      'token': token,
      'email': email,
      'name': name,
      'isDisable': isDisable,
      'imageProfile': imageProfile,
      'countryCode': countryCode,
      'countryNumberCode': countryNumberCode,
      'mobileNumberPhone': mobileNumberPhone,
    };
  }
}
