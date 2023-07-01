import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
            width: 200, height: 200, child: Image.asset('assets/logo.png')),
        const SizedBox(
          height: 40,
        ),
        AnimatedTextKit(animatedTexts: [
          WavyAnimatedText('Yourbae Project',
              speed: const Duration(milliseconds: 250),
              textStyle: GoogleFonts.lemon(
                  fontSize: 30, color: const Color(0xff404258)))
        ])
      ]),
    ));
  }
}
