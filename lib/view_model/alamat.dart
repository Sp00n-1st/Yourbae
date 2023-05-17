import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../controller/alamat_controller.dart';

class Alamat extends GetView<AlamatController> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration:
          InputDecoration(label: Text('Alamat'), border: OutlineInputBorder()),
    );
  }
}
