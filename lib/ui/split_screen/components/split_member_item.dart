import 'package:bill_splitter/models/group_member.dart';
import 'package:bill_splitter/styles/colors.dart';
import 'package:bill_splitter/styles/spacing.dart';
import 'package:flutter/material.dart';

import '../../../styles/theme.dart';

class SplitMemberItem extends StatelessWidget {
  final double splitAmount;
  final GroupMember? member;
  final bool? isChecked;
  final Function(bool? isChecked) onCheckedChange;
  const SplitMemberItem(
      {Key? key,
      required this.member,
      required this.splitAmount,
      required this.isChecked,
      required this.onCheckedChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                  value: isChecked,
                  fillColor: MaterialStateProperty.all(MyColor.primaryColor),
                  onChanged: onCheckedChange),
              addHorizontalSpacing(5),
              Text(member?.name ?? "", style: h3().copyWith(fontSize: 14)),
            ],
          ),
          Text(isChecked == true ? splitAmount.toString() : "0",
              style: h3().copyWith(fontSize: 14))
        ],
      ),
    );
  }
}
