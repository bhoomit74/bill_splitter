import 'package:bill_splitter/styles/colors.dart';
import 'package:flutter/material.dart';

class CustomBottomSheet {
  void showSheet(context, Widget body) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: BoxDecoration(
                color: MyColor.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: body,
            ),
          );
        });
  }
}
