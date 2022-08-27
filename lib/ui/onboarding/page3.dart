import 'package:bill_splitter/styles/app_images.dart';
import 'package:bill_splitter/ui/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

import '../../styles/app_strings.dart';
import '../../styles/colors.dart';
import '../../styles/spacing.dart';
import '../../styles/theme.dart';
import '../../widgets/widgets.dart';

class Page3 extends StatelessWidget {

  static const String routeName = "page3";

  const Page3({Key? key}) : super(key: key);

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
                Image.asset(AppImages.onBoardingPage3),
                addVerticalSpacing(20),
                Text("Let us do hard work",
                    style: h2(),
                    textAlign: TextAlign.center
                ),
                addVerticalSpacing(10),
                Text("Bills and other costs we splits for you in just a one tap",
                    style: h4(),
                    textAlign: TextAlign.center
                ),
                addVerticalSpacing(30),
                buttonFrostedGlass("Let's starts", context,(){
                  Navigator.pushNamed(context, Dashboard.routeName);
                })
              ],
            ),

          ),
        )
    );
  }
}
