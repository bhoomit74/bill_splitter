import 'package:bill_splitter/models/group_member.dart';
import 'package:bill_splitter/styles/spacing.dart';
import 'package:bill_splitter/styles/theme.dart';
import 'package:bill_splitter/utils/extensions.dart';
import 'package:bill_splitter/widgets/common_check_box.dart';
import 'package:flutter/material.dart';

import '../../../utils/global_data.dart';

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
              Text(currentUserId == member?.id ? "You" : member?.name ?? "",
                  style: h3_16()),
            ],
          ),
          Text(
              isChecked == true
                  ? splitAmount.toDouble().toRupee()
                  : (0.0).toRupee(),
              style: h3_16())
        ],
      ),
    );
  }
}
