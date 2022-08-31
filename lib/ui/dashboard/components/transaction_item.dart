import 'package:bill_splitter/models/transaction_model.dart';
import 'package:bill_splitter/ui/dashboard/components/transaction_image.dart';
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
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MyColor.white_800, borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          addHorizontalSpacing(4),
          TransactionImage(transaction: transaction),
          addHorizontalSpacing(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.transactionBy.toString(),
                  style: h4Bold(),
                ),
                addVerticalSpacing(4),
                Text(
                  transaction.transactionName.toString(),
                  style: h5(),
                )
              ],
            ),
          ),
          addHorizontalSpacing(10),
          Text(transaction.transactionAmount.toString(), style: h4Bold()),
          addHorizontalSpacing(4),
        ],
      ),
    );
  }
}
