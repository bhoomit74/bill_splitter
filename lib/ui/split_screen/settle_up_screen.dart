import 'package:bill_splitter/bloc/split/split_cubit.dart';
import 'package:bill_splitter/models/group_member.dart';
import 'package:bill_splitter/models/group_model.dart';
import 'package:bill_splitter/styles/app_strings.dart';
import 'package:bill_splitter/styles/colors.dart';
import 'package:bill_splitter/styles/spacing.dart';
import 'package:bill_splitter/ui/split_screen/components/split_member_item.dart';
import 'package:bill_splitter/utils/extensions.dart';
import 'package:bill_splitter/widgets/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../styles/theme.dart';
import '../../widgets/bottom_sheet.dart';
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
          showMessageDialog(
              context, "You have successfully settle up the amount",
              isError: false);
        } else if (state is SplitError) {
          showMessageDialog(context, state.errorMessage);
        } else if (state is UpiAppUpdated) {
          showUPIAppSheet(cubit, context);
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
                      Row(
                        children: [
                          Icon(
                            Icons.keyboard_backspace,
                            color: MyColor.black_800,
                          ).onClick(() {
                            Navigator.pop(context);
                          }),
                          addHorizontalSpacing(10),
                          Text(
                            "Settle Up",
                            style: h3().copyWith(fontSize: 20),
                          ),
                        ],
                      ),
                      addVerticalSpacing(30),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: MyColor.white_800,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pay via UPI",
                              style: h4Bold(),
                            ),
                            IconButton(
                                onPressed: () {
                                  if (cubit.payViaUPI == true) {
                                    cubit.changePaymentMethod(
                                        PaymentMethod.cash);
                                  } else {
                                    cubit
                                        .changePaymentMethod(PaymentMethod.upi);
                                  }
                                },
                                icon: Icon(
                                    cubit.payViaUPI
                                        ? CupertinoIcons.chevron_up_circle_fill
                                        : CupertinoIcons
                                            .chevron_down_circle_fill,
                                    color: MyColor.grey_800.withOpacity(0.7)))
                          ],
                        ),
                      ),
                      Visibility(
                          visible: cubit.payViaUPI,
                          child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child:
                                  payViaUPIView(controller, cubit, context))),
                      addVerticalSpacing(20),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: MyColor.white_800,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pay via cash",
                              style: h4Bold(),
                            ),
                            IconButton(
                                onPressed: () {
                                  if (cubit.payViaUPI == true) {
                                    cubit.changePaymentMethod(
                                        PaymentMethod.cash);
                                  } else {
                                    cubit
                                        .changePaymentMethod(PaymentMethod.upi);
                                  }
                                },
                                icon: Icon(
                                    cubit.payViaUPI
                                        ? CupertinoIcons
                                            .chevron_down_circle_fill
                                        : CupertinoIcons.chevron_up_circle_fill,
                                    color: MyColor.grey_800.withOpacity(0.7)))
                          ],
                        ),
                      ),
                      Visibility(
                          visible: !cubit.payViaUPI,
                          child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child:
                                  payViaCashView(controller, cubit, context))),
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }

  showUPIAppSheet(SplitCubit cubit, context) {
    var apps = cubit.upiApps;
    CustomBottomSheet().showSheet(
        context,
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addVerticalSpacing(10),
              Text(
                "Select UPI app",
                style: h3Bold().copyWith(fontSize: 20),
              ),
              addVerticalSpacing(20),
              Flexible(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  shrinkWrap: true,
                  itemCount: apps.length,
                  itemBuilder: (context, index) {
                    var app = apps[index];
                    return SizedBox(
                        height: 60,
                        width: 60,
                        child: Image.memory(
                          app.icon,
                          scale: 3,
                        )).onClick(() {
                      Navigator.pop(context);
                      cubit.initiateTransaction(app);
                    });
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Widget payViaCashView(amountController, SplitCubit cubit, context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        addVerticalSpacing(30),
        CommonTextField(
          hint: "Amount",
          controller: amountController,
          textInputType: TextInputType.number,
          inputFormatter: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp('^\\d+\\.?\\d*'))
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
                      isChecked: cubit.splitMembers.contains(member),
                      onCheckedChange: (isChecked) {});
                })),
        addVerticalSpacing(20),
        commonButton("Mark as Paid", context, () {
          cubit.settleUp();
        })
      ],
    );
  }

  Widget payViaUPIView(amountController, SplitCubit cubit, context) {
    TextEditingController upiIdController =
        TextEditingController(text: cubit.upiId);
    TextEditingController noteController =
        TextEditingController(text: cubit.note);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        addVerticalSpacing(20),
        CommonTextField(
          hint: "Amount",
          controller: amountController,
          textInputType: TextInputType.number,
          inputFormatter: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp('^\\d+\\.?\\d*'))
          ],
          onChanged: (value) {
            cubit.changeTotalSplitAmount(value);
          },
        ),
        addVerticalSpacing(10),
        CommonTextField(
          hint: "Receiver UPI Id",
          controller: upiIdController,
          textInputType: TextInputType.text,
        ),
        addVerticalSpacing(10),
        CommonTextField(
          hint: "Note",
          controller: noteController,
          textInputType: TextInputType.text,
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
                      isChecked: cubit.splitMembers.contains(member),
                      onCheckedChange: (isChecked) {});
                })),
        addVerticalSpacing(20),
        commonButton("Pay via UPI", context, () {
          cubit.getUpiAppsFromMobile(upiIdController.text.trim().toString(),
              noteController.text.trim().toString());
        }),
        addVerticalSpacing(20),
      ],
    );
  }
}
