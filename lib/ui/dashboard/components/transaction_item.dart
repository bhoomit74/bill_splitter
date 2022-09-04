import 'package:bill_splitter/models/transaction_model.dart';
import 'package:bill_splitter/ui/dashboard/components/transaction_image.dart';
import 'package:bill_splitter/utils/extensions.dart';
import 'package:flutter/material.dart';

import '../../../styles/colors.dart';
import '../../../styles/spacing.dart';
import '../../../styles/theme.dart';

class TransactionItem extends StatelessWidget {
  final SplitTransaction transaction;
  const TransactionItem({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
          color: transaction.isSettleUpTransaction ?? false
              ? Colors.green.withOpacity(0.7)
              : MyColor.blue_700,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //addHorizontalSpacing(4),
          TransactionImage(
            name: transaction.transactionBy ?? "A",
          ),
          addHorizontalSpacing(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.transactionBy.toString(),
                  style: h5().copyWith(
                      fontSize: 16,
                      color: MyColor.white_800,
                      fontWeight: FontWeight.w500),
                ),
                addVerticalSpacing(8),
                Text(
                  transaction.transactionName.toString(),
                  style: h5().copyWith(
                      fontSize: 12, color: MyColor.white_800.withOpacity(0.8)),
                )
              ],
            ),
          ),
          addHorizontalSpacing(10),
          Text(transaction.transactionAmount?.toRupee() ?? "",
              style: h5().copyWith(fontSize: 16, color: MyColor.white_800)),
          addHorizontalSpacing(4),
        ],
      ),
    );
  }
}
