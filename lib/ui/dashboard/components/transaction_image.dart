import 'package:bill_splitter/models/transaction_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../styles/colors.dart';
import '../../../styles/theme.dart';

class TransactionImage extends StatelessWidget {
  final SplitTransaction transaction;
  const TransactionImage({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MyColor.blue_600.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Text(
          transaction.transactionBy.toString().characters.first.toUpperCase(),
          style: h3().copyWith(color: MyColor.white_800, fontSize: 16),
        ),
      ),
    );
  }
}
