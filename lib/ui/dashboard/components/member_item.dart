import 'package:bill_splitter/styles/colors.dart';
import 'package:bill_splitter/styles/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/group_member.dart';
import '../../../styles/spacing.dart';

class MemberItem extends StatelessWidget {
  final GroupMember groupMember;
  final double length;
  const MemberItem({Key? key, required this.groupMember, required this.length})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 215,
          padding: const EdgeInsets.all(10),
          alignment: groupMember.amount?.isNegative ?? false
              ? Alignment.bottomCenter
              : Alignment.topCenter,
          child: SizedBox(
            height: 120,
            width: 50,
            child: Container(
              alignment: groupMember.amount?.isNegative ?? false
                  ? Alignment.topCenter
                  : Alignment.bottomCenter,
              child: Container(
                height: 50 + 50 * length,
                width: 50,
                alignment: groupMember.amount?.isNegative ?? false
                    ? Alignment.topCenter
                    : Alignment.bottomCenter,
                padding: groupMember.amount?.isNegative ?? false
                    ? const EdgeInsets.only(
                        top: 2, bottom: 2, left: 2, right: 2)
                    : const EdgeInsets.only(
                        top: 2, bottom: 2, left: 2, right: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: groupMember.amount?.toInt().isNegative ?? false
                        ? MyColor.orange
                        : MyColor.blue_600),
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyColor.white_800,
                  ),
                  child: Center(
                    child: Text(
                      groupMember.name
                          .toString()
                          .characters
                          .first
                          .toUpperCase(),
                      style: h3Bold()
                          .copyWith(fontSize: 20, color: MyColor.primaryColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
            top: 220,
            width: 70,
            left: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    "${groupMember.name}",
                    style: h3Bold().copyWith(fontSize: 14),
                  ),
                ),
                addVerticalSpacing(5),
                Center(
                  child: Text(
                    "${groupMember.amount}",
                    style: h3Bold().copyWith(
                        fontSize: 14,
                        color: groupMember.amount?.isNegative == true
                            ? MyColor.orange
                            : MyColor.blue_600),
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
