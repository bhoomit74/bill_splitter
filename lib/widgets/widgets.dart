import 'dart:ui';

import 'package:bill_splitter/styles/app_images.dart';
import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/spacing.dart';
import '../styles/theme.dart';

Widget button(String text, BuildContext context, String routeName) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, routeName);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      decoration: BoxDecoration(
          color: MyColor.purple, borderRadius: BorderRadius.circular(40)),
      child: Text(
        text,
        style: buttonTextStyle(),
      ),
    ),
  );
}

Widget buttonFrostedGlass(String text, BuildContext context, Function() onTap) {
  return GestureDetector(
    onTap: onTap,
    child: ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          decoration: BoxDecoration(
              color: MyColor.primaryColor,
              borderRadius: BorderRadius.circular(40)),
          child: Text(
            text,
            style: buttonTextStyle().copyWith(color: MyColor.white_800),
          ),
        ),
      ),
    ),
  );
}

Widget buttonSmall(String text, Function() onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          color: MyColor.black_800, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: h5().copyWith(fontSize: 12, color: MyColor.white_800),
          ),
          addHorizontalSpacing(10),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: MyColor.black_800,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.share,
                color: MyColor.white,
                size: 14,
              ))
        ],
      ),
    ),
  );
}

Widget commonButton(String text, BuildContext context, Function() onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(
          color: MyColor.primaryColor, borderRadius: BorderRadius.circular(10)),
      child: Center(
          child: Text(
        text,
        style: buttonTextStyle().copyWith(color: MyColor.white_800),
      )),
    ),
  );
}

Future showMessageDialog(BuildContext context, String message,
    {bool isError = true}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              isError ? AppImages.warning : AppImages.success,
              width: 120,
              height: 120,
            ),
            Text(isError ? "Error" : "Done!",
                style: h3Bold().copyWith(color: MyColor.black_800)),
            addVerticalSpacing(10),
            Text(message, style: h5()),
            addVerticalSpacing(10),
          ],
        ));
      });
}
