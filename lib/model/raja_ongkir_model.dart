class RajaOngkirModel {
  Rajaongkir? rajaongkir;
  RajaOngkirModel({this.rajaongkir});

  RajaOngkirModel.fromJson(Map<String, dynamic> json) {
    rajaongkir = json['rajaongkir'] != null
        ? Rajaongkir.fromJson(json['rajaongkir'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (rajaongkir != null) {
      data['rajaongkir'] = rajaongkir!.toJson();
    }
    return data;
  }
}

class Rajaongkir {
  List<Results>? results;
  Rajaongkir({this.results});

  Rajaongkir.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Query {
  String? origin;
  String? destination;
  int? weight;
  String? courier;
  Query({this.origin, this.destination, this.weight, this.courier});

  Query.fromJson(Map<String, dynamic> json) {
    origin = json['origin'];
    destination = json['destination'];
    weight = json['weight'];
    courier = json['courier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['origin'] = origin;
    data['destination'] = destination;
    data['weight'] = weight;
    data['courier'] = courier;
    return data;
  }
}

class Status {
  int? code;
  String? description;
  Status({this.code, this.description});

  Status.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['description'] = description;
    return data;
  }
}

class Results {
  String? code;
  String? name;
  List<Costs>? costs;
  Results({this.code, this.name, this.costs});

  Results.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    if (json['costs'] != null) {
      costs = <Costs>[];
      json['costs'].forEach((v) {
        costs!.add(Costs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    if (costs != null) {
      data['costs'] = costs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Costs {
  String? service;
  String? description;
  List<Cost>? cost;
  Costs({this.service, this.description, this.cost});

  Costs.fromJson(Map<String, dynamic> json) {
    service = json['service'];
    description = json['description'];
    if (json['cost'] != null) {
      cost = <Cost>[];
      json['cost'].forEach((v) {
        cost!.add(Cost.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service'] = service;
    data['description'] = description;
    if (cost != null) {
      data['cost'] = cost!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cost {
  int? value;
  String? etd;
  String? note;
  Cost({this.value, this.etd, this.note});

  Cost.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    etd = json['etd'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['etd'] = etd;
    data['note'] = note;
    return data;
  }
}
