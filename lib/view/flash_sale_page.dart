import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlashSalePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Flash Sale',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 30),
        ),
      ),
      body: Center(
        child: Image.asset('assets/nodata3.gif'),
      ),
    );
  }
}
