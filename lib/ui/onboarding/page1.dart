import 'package:bill_splitter/styles/app_images.dart';
import 'package:bill_splitter/styles/app_strings.dart';
import 'package:flutter/material.dart';

import '../../styles/colors.dart';
import '../../styles/spacing.dart';
import '../../styles/theme.dart';

class Page1 extends StatelessWidget {

  static const String routeName = "page1";

  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Container(
            padding: const EdgeInsets.all(10),
            color: MyColor.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*Text(AppStrings.appTitle,style: h1().copyWith(color: MyColor.purple,fontSize: 24),),
                addVerticalSpacing(40),*/
                Image.asset(AppImages.onBoardingPage1),
                addVerticalSpacing(20),
                Text("Welcome",
                    style: h2(),
                    textAlign: TextAlign.center
                ),
                addVerticalSpacing(10),
                Text("By using our app, you can split, manage and track your bills with your groups",
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
