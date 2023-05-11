import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/controller.dart';

class TabButton extends StatelessWidget {
  const TabButton({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(Controller());
    return DefaultTabController(
      length: 7,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ButtonsTabBar(
              onTap: (position) {
                if (position == 0) {
                  controller.category.value = null;
                } else if (position == 1) {
                  controller.category.value = 'Adidas';
                } else if (position == 2) {
                  controller.category.value = 'Air Jordan';
                } else if (position == 3) {
                  controller.category.value = 'Nike';
                } else if (position == 4) {
                  controller.category.value = 'Puma';
                } else if (position == 5) {
                  controller.category.value = 'Reebok';
                } else if (position == 6) {
                  controller.category.value = 'Vans';
                }
              },
              buttonMargin: const EdgeInsets.only(right: 7.5, left: 7.5).r,
              height: 70.h,
              decoration: const BoxDecoration(color: Color(0xff93C6E7)),
              unselectedBackgroundColor: Colors.white,
              unselectedLabelStyle: const TextStyle(color: Colors.black),
              labelStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              tabs: [
                tabButton('all'),
                tabButton('adidas'),
                tabButton('airJordan'),
                tabButton('nike'),
                tabButton('puma'),
                tabButton('reebok'),
                tabButton('vans'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Tab tabButton(String image) {
    return Tab(
      child: ClipRRect(
          borderRadius: BorderRadius.circular(15).r,
          child: SizedBox(
              width: 50.w,
              height: 70.h,
              child: Image(image: AssetImage('assets/$image.png')))),
    );
  }
}
