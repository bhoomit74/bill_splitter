import 'package:bill_splitter/styles/app_images.dart';
import 'package:bill_splitter/styles/app_strings.dart';
import 'package:flutter/material.dart';

import '../../styles/colors.dart';
import '../../styles/spacing.dart';
import '../../styles/theme.dart';

class Page2 extends StatelessWidget {

  static const String routeName = "page2";

  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    return SafeArea(
        child: Scaffold(
          body: Container(
            color: MyColor.white,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*Text(AppStrings.appTitle,style: h1().copyWith(color: MyColor.purple,fontSize: 24),),
                addVerticalSpacing(40),*/
                Image.asset(AppImages.onBoardingPage2),
                addVerticalSpacing(20),
                Text("Don't stress",
                    style: h2(),
                    textAlign: TextAlign.center
                ),
                addVerticalSpacing(10),
                Text("Always have clarity over your group expenses",
                    style: h4(),
                    textAlign: TextAlign.center
                ),
                addVerticalSpacing(30),
                //button("Let's starts", context,Dashboard.routeName)
              ],
            ),

          ),
        )
    );
  }
}
