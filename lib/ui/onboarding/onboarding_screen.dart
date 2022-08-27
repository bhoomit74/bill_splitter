import 'package:bill_splitter/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import 'page1.dart';
import 'page2.dart';
import 'page3.dart';

class OnBoardingScreen extends StatelessWidget {
  static const String routeName = "onBoardingScreen";
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: LiquidSwipe(
        ignoreUserGestureWhileAnimating: true,
        enableLoop: false,
        waveType: WaveType.circularReveal,
        positionSlideIcon: 0.9,
        pages: const [
          Page1(),
          Page2(),
          Page3()
        ]
      ),
    );
  }
}
