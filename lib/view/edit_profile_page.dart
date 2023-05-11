import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key, required this.firstName, required this.lastName});

  String firstName;
  String lastName;

  @override
  Widget build(BuildContext context) {
    TextEditingController firstNameC = TextEditingController(text: firstName);
    TextEditingController lastNameC = TextEditingController(text: lastName);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 30),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50.h,
            ),
            Center(
              child: CircleAvatar(
                  radius: 95, backgroundImage: AssetImage('assets/kanna.jpeg')),
            ),
            Container(
                margin: const EdgeInsets.only(left: 20, top: 30, bottom: 10),
                child: Text(
                  'First Name',
                  style: GoogleFonts.poppins(),
                )),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                style: GoogleFonts.poppins(),
                controller: firstNameC,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Colors.blue.shade900, width: 2)),
                  hintText: 'Input First Name',
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Can\'t Be Empty';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 20, top: 30, bottom: 10),
                child: Text(
                  'Last Name',
                  style: GoogleFonts.poppins(),
                )),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                style: GoogleFonts.poppins(),
                controller: lastNameC,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Colors.blue.shade900, width: 2)),
                  hintText: 'Input Last Name',
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Can\'t Be Empty';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Center(
              child: SizedBox(
                width: 100.w,
                height: 40.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                  onPressed: () {},
                  child: Text(
                    'Save',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
