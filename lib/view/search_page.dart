import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Cari Sepatu',
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 30)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Center(
            child: SizedBox(
              width: 300.w,
              height: 50.h,
              child: TextField(
                cursorHeight: 20,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {}, icon: Icon(CupertinoIcons.search)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r))),
              ),
            ),
          )
        ],
      ),
    );
  }
}
