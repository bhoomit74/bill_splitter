import 'package:bill_splitter/models/transaction_model.dart';
import 'package:bill_splitter/ui/dashboard/components/transaction_image.dart';
import 'package:bill_splitter/utils/extensions.dart';
import 'package:flutter/cupertino.dart';

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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MyColor.white_800, borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //addHorizontalSpacing(4),
          TransactionImage(transaction: transaction),
          addHorizontalSpacing(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.transactionBy.toString(),
                  style: h5().copyWith(
                      fontSize: 16,
                      color: MyColor.primaryColor,
                      fontWeight: FontWeight.w400),
                ),
                addVerticalSpacing(4),
                Text(
                  transaction.transactionName.toString(),
                  style: h5().copyWith(fontSize: 12),
                )
              ],
            ),
          ),
          addHorizontalSpacing(10),
          Text(transaction.transactionAmount?.convertToRupee() ?? "",
              style: h5().copyWith(fontSize: 16, color: MyColor.primaryColor)),
          addHorizontalSpacing(4),
        ],
      ),
    );
  }
}
