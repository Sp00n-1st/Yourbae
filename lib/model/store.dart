class Store {
  final String noRekening, rekeningName, noCustomerService;

  Store({
    required this.noRekening,
    required this.rekeningName,
    required this.noCustomerService,
  });

  Store.fromJson(Map<String, dynamic>? json)
      : this(
          noRekening: json!['noRekening'] as String,
          rekeningName: json['rekeningName'] as String,
          noCustomerService: json['noCustomerService'] as String,
        );

  Map<String, Object?> toJson() {
    return {
      'noRekening': noRekening,
      'rekeningName': rekeningName,
      'noCustomerService': noCustomerService,
    };
  }
}
