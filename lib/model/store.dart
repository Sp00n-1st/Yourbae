class Store {
  final String noRekening, rekeningName, noCustomerService;

  Store({
    required this.noRekening,
    required this.rekeningName,
    required this.noCustomerService,
  });

  Store.fromJson(Map<String, dynamic>? json)
      : this(
          noRekening: json!['account_number'] as String,
          rekeningName: json['account_name'] as String,
          noCustomerService: json['no_customer_service'] as String,
        );

  Map<String, Object?> toJson() {
    return {
      'noRekening': noRekening,
      'rekeningName': rekeningName,
      'noCustomerService': noCustomerService,
    };
  }
}
