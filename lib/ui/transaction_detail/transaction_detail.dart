import 'package:bill_splitter/models/transaction_model.dart';
import 'package:bill_splitter/styles/app_images.dart';
import 'package:bill_splitter/styles/app_strings.dart';
import 'package:bill_splitter/styles/colors.dart';
import 'package:bill_splitter/styles/spacing.dart';
import 'package:bill_splitter/ui/dashboard/components/transaction_image.dart';
import 'package:bill_splitter/utils/extensions.dart';
import 'package:bill_splitter/widgets/header.dart';
import 'package:flutter/material.dart';

import '../../styles/theme.dart';

class TransactionDetail extends StatelessWidget {
  static String routeName = "transactionDetail";
  final SplitTransaction transaction;
  const TransactionDetail({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var members = transaction.members ?? [];
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(title: AppStrings.labelTransactionDetail),
              addVerticalSpacing(30),
              Container(
                decoration: BoxDecoration(
                    color: MyColor.black_800,
                    gradient: LinearGradient(
                        colors: [MyColor.black, MyColor.black_800]),
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(20),
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${transaction.transactionBy} spent",
                              style: h5().copyWith(
                                  color: MyColor.white, fontSize: 16)),
                          addVerticalSpacing(4),
                          Text("${transaction.transactionAmount?.toRupee()}",
                              style: h2().copyWith(color: MyColor.white_800)),
                          addVerticalSpacing(2),
                          Text(
                            "on ${transaction.time?.toDate()}",
                            style: h5().copyWith(
                                fontSize: 16, color: MyColor.white_800),
                          ),
                          addVerticalSpacing(20),
                          Text(
                            "for ${transaction.transactionName}",
                            style: h4().copyWith(
                                fontSize: 14, color: MyColor.white_800),
                          ),
                          addVerticalSpacing(5),
                          Text("${transaction.transactionDescription}",
                              style: h5().copyWith(
                                  fontSize: 14, color: MyColor.grey_800)),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.asset(
                        AppImages.receipt,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    )
                  ],
                ),
              ),
              addVerticalSpacing(30),
              Text(
                  "${AppStrings.labelAmountSplitBetween} ${members.length} ${AppStrings.labelMember}",
                  style: h4Bold().copyWith(fontSize: 16)),
              addVerticalSpacing(10),
              Flexible(
                  child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      decoration: BoxDecoration(
                        color: MyColor.blue_700,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              TransactionImage(
                                  name: members[index].name ?? "A"),
                              addHorizontalSpacing(10),
                              Text("${members[index].name}",
                                  style: h4Bold().copyWith(
                                    fontSize: 16,
                                    color: MyColor.white_800,
                                  )),
                            ],
                          ),
                          Text("${members[index].amount?.toRupee()}",
                              style: h5().copyWith(
                                  fontSize: 16, color: MyColor.white_800)),
                        ],
                      ));
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
