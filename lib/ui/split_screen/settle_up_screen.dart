import 'package:bill_splitter/bloc/split/split_cubit.dart';
import 'package:bill_splitter/models/group_member.dart';
import 'package:bill_splitter/models/group_model.dart';
import 'package:bill_splitter/styles/spacing.dart';
import 'package:bill_splitter/ui/split_screen/components/split_member_item.dart';
import 'package:bill_splitter/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../styles/theme.dart';
import '../../widgets/common_text_field.dart';
import '../../widgets/widgets.dart';

class SettleUpScreen extends StatelessWidget {
  static String routeName = "SettleUpScreen";
  final GroupModel? group;
  final GroupMember? member;

  const SettleUpScreen({Key? key, required this.group, required this.member})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = SplitCubit(group, settleMember: member);
    var controller =
        TextEditingController(text: cubit.totalSplitAmount.toString());
    return BlocConsumer<SplitCubit, SplitState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is SplitLoading) {
          ProgressDialogUtils.showProgressDialog(context);
        } else if (state is SplitSuccess) {
          ProgressDialogUtils.dismissProgressDialog();
          Navigator.pop(context, true);
          showMessageDialog(context, "Successfully added");
        } else if (state is SplitError) {
          showMessageDialog(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Settle Up",
                        style: h3().copyWith(fontSize: 20),
                      ),
                      addVerticalSpacing(30),
                      CommonTextField(
                        hint: "Amount",
                        controller: controller,
                        textInputType: TextInputType.number,
                        inputFormatter: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp('^\\d+\\.?\\d*'))
                        ],
                        onChanged: (value) {
                          cubit.changeTotalSplitAmount(value);
                        },
                      ),
                      addVerticalSpacing(20),
                      Flexible(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                return SplitMemberItem(
                                    member: member,
                                    splitAmount: cubit.splitAmount,
                                    isChecked:
                                        cubit.splitMembers.contains(member),
                                    onCheckedChange: (isChecked) {});
                              })),
                      addVerticalSpacing(20),
                      commonButton("Mark as Paid", context, () {
                        cubit.settleUp();
                      })
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}
