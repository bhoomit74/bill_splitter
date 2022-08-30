import 'package:bill_splitter/bloc/split/split_cubit.dart';
import 'package:bill_splitter/models/group_member.dart';
import 'package:bill_splitter/models/group_model.dart';
import 'package:bill_splitter/styles/spacing.dart';
import 'package:bill_splitter/ui/split_screen/components/split_member_item.dart';
import 'package:bill_splitter/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../styles/theme.dart';
import '../../widgets/common_text_field.dart';
import '../../widgets/widgets.dart';

class SplitScreen extends StatelessWidget {
  static String splitScreenRoute = "SplitScreen";
  final GroupModel? group;

  const SplitScreen({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = SplitCubit(group);
    var titleController = TextEditingController();
    var descriptionController = TextEditingController();
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
            child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Split",
                      style: h3().copyWith(fontSize: 20),
                    ),
                    addVerticalSpacing(30),
                    CommonTextField(
                      hint: "Spent on",
                      controller: titleController,
                    ),
                    addVerticalSpacing(20),
                    CommonTextField(
                      hint: "Description",
                      controller: descriptionController,
                    ),
                    addVerticalSpacing(20),
                    CommonTextField(
                      hint: "Amount",
                      onChanged: (value) {
                        cubit.changeTotalSplitAmount(value);
                      },
                    ),
                    addVerticalSpacing(20),
                    Flexible(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: group?.members?.length ?? 0,
                            itemBuilder: (context, index) {
                              GroupMember? member = group?.members![index];
                              return SplitMemberItem(
                                  member: member,
                                  splitAmount: cubit.splitAmount,
                                  isChecked:
                                      cubit.splitMembers.contains(member),
                                  onCheckedChange: (isChecked) {
                                    if (isChecked == true) {
                                      cubit.addMemberFromSplit(member!);
                                    } else {
                                      cubit.removeMemberFromSplit(member!);
                                    }
                                  });
                            })),
                    addVerticalSpacing(20),
                    commonButton("Add split", context, () {
                      cubit.addSplit(
                          titleController.text, descriptionController.text);
                    })
                  ],
                )),
          ),
        );
      },
    );
  }
}
