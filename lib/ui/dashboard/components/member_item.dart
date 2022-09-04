import 'package:bill_splitter/styles/colors.dart';
import 'package:bill_splitter/styles/theme.dart';
import 'package:bill_splitter/utils/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/group_member.dart';
import '../../../styles/spacing.dart';

class MemberBarItem extends StatefulWidget {
  final GroupMember groupMember;
  final double heightPercentage;
  const MemberBarItem(
      {Key? key, required this.groupMember, required this.heightPercentage})
      : super(key: key);

  @override
  State<MemberBarItem> createState() => _MemberBarItemState();
}

class _MemberBarItemState extends State<MemberBarItem> {
  var initialBarHeight = 50.0;
  var variableMaxBarHeight = 70.0;
  late double totalBarHeight;
  late double graphHeight;
  late double currentBarHeight;

  late bool haveNegativeAmount;

  @override
  void initState() {
    totalBarHeight = initialBarHeight + variableMaxBarHeight;
    graphHeight = (totalBarHeight * 2) - (initialBarHeight / 2);
    currentBarHeight = initialBarHeight;
    haveNegativeAmount = widget.groupMember.amount?.isNegative ?? false;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        currentBarHeight =
            initialBarHeight + (variableMaxBarHeight * widget.heightPercentage);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: graphHeight,
          padding: const EdgeInsets.all(10),
          alignment:
              haveNegativeAmount ? Alignment.bottomCenter : Alignment.topCenter,
          child: SizedBox(
            height: totalBarHeight,
            width: initialBarHeight,
            child: Container(
              alignment: haveNegativeAmount
                  ? Alignment.topCenter
                  : Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                height: currentBarHeight,
                alignment: haveNegativeAmount
                    ? Alignment.topCenter
                    : Alignment.bottomCenter,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: haveNegativeAmount
                        ? Colors.deepOrangeAccent
                        : MyColor.blue_700),
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyColor.white_800,
                  ),
                  child: Center(
                    child: Text(
                      widget.groupMember.name
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
                    "${widget.groupMember.name}",
                    style: h4Bold()
                        .copyWith(fontSize: 14, color: MyColor.black_800),
                  ),
                ),
                addVerticalSpacing(5),
                Center(
                  child: Text(
                    "${widget.groupMember.amount?.toRupee()}",
                    style: h5().copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: haveNegativeAmount
                            ? Colors.deepOrangeAccent
                            : MyColor.blue_700),
                  ),
                ),
                addVerticalSpacing(5),
                Visibility(
                  visible: FirebaseAuth.instance.currentUser?.uid !=
                      widget.groupMember.id,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Settle up",
                        style:
                            h5().copyWith(fontSize: 10, color: MyColor.white),
                      ),
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
