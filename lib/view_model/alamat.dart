import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';

class Alamat extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration:
          InputDecoration(label: Text('Address'), border: OutlineInputBorder()),
    );
  }
}
