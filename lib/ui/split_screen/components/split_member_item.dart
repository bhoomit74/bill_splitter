import 'package:bill_splitter/models/group_member.dart';
import 'package:bill_splitter/styles/spacing.dart';
import 'package:bill_splitter/utils/extensions.dart';
import 'package:bill_splitter/widgets/common_check_box.dart';
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
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              MyCheckBox(
                  onChange: onCheckedChange, defaultValue: isChecked ?? true),
              addHorizontalSpacing(10),
              Text(member?.name ?? "", style: h3().copyWith(fontSize: 16)),
            ],
          ),
          Text(
              isChecked == true
                  ? splitAmount.toDouble().convertToRupee()
                  : (0.0).convertToRupee(),
              style: h3().copyWith(fontSize: 14))
        ],
      ),
    );
  }
}
