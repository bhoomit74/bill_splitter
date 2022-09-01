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
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: MyColor.black_800.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          transaction.transactionBy.toString().characters.first.toUpperCase(),
          style: h3().copyWith(color: MyColor.blue_800, fontSize: 20),
        ),
      ),
    );
  }
}
