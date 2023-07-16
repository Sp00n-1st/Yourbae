class UserModel {
  final String name, email, nomorHP, kodeNegara, kodeNomorNegara;
  final String? imageProfile, token;
  final bool isDisable;

  UserModel({
    required this.token,
    required this.email,
    required this.name,
    required this.kodeNegara,
    required this.kodeNomorNegara,
    required this.nomorHP,
    required this.imageProfile,
    required this.isDisable,
  });

  UserModel.fromJson(Map<String, dynamic>? json)
      : this(
          email: json!['email'] as String,
          token: json['token'] as String?,
          name: json['name'] as String,
          kodeNegara: json['kodeNegara'] as String,
          kodeNomorNegara: json['kodeNomorNegara'] as String,
          nomorHP: json['nomorHP'] as String,
          isDisable: json['isDisable'] as bool,
          imageProfile: json['imageProfile'] as String?,
        );

  Map<String, Object?> toJson() {
    return {
      'token': token,
      'email': email,
      'name': name,
      'isDisable': isDisable,
      'imageProfile': imageProfile,
      'kodeNegara': kodeNegara,
      'kodeNomorNegara': kodeNomorNegara,
      'nomorHP': nomorHP,
    };
  }
}
