import 'package:bill_splitter/bloc/dashboard/dashboard_cubit.dart';
import 'package:bill_splitter/main.dart';
import 'package:bill_splitter/styles/colors.dart';
import 'package:bill_splitter/styles/spacing.dart';
import 'package:bill_splitter/styles/theme.dart';
import 'package:bill_splitter/ui/dashboard/components/member_item.dart';
import 'package:bill_splitter/ui/split_screen/split_screen.dart';
import 'package:bill_splitter/widgets/common_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/bottom_sheet.dart';
import '../../widgets/progress_dialog.dart';
import '../../widgets/widgets.dart';
import '../sign_in/sign_in.dart';

class Dashboard extends StatefulWidget {
  static const String routeName = "dashboardScreen";

  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final cubit = DashboardCubit();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      cubit.getUserDetail();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is DashboardLoading) {
          ProgressDialogUtils.showProgressDialog(context);
        } else if (state is DashboardSuccess) {
          ProgressDialogUtils.dismissProgressDialog();
        } else if (state is DashboardError) {
          ProgressDialogUtils.dismissProgressDialog();
          showMessageDialog(context, state.errorMessage);
        } else if (state is MemberJoined) {
          ProgressDialogUtils.dismissProgressDialog();
          Navigator.pop(context);
        } else if (state is LogoutSuccess) {
          ProgressDialogUtils.dismissProgressDialog();
          Navigator.pushNamedAndRemoveUntil(
              context, SignInScreen.routeName, (route) => false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              group = cubit.group;
              Navigator.pushNamed(context, SplitScreen.splitScreenRoute)
                  .then((value) {
                if (value == true) {
                  cubit.getUserDetail();
                }
              });
            },
            backgroundColor: MyColor.primaryColor,
            child: const Icon(Icons.add),
          ),
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Good morning,",
                        style: h3().copyWith(fontSize: 20),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                showAddMemberSheet();
                              },
                              child: Icon(
                                Icons.person_add,
                                color: primaryColor,
                                size: 20,
                              )),
                          addHorizontalSpacing(20),
                          GestureDetector(
                              onTap: () {
                                cubit.logout();
                              },
                              child: Icon(
                                Icons.logout,
                                color: primaryColor,
                                size: 20,
                              )),
                        ],
                      )
                    ],
                  ),
                  Text(
                    cubit.username,
                    style: h3Light().copyWith(fontSize: 20),
                  ),
                  addVerticalSpacing(20),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cubit.group?.members?.length ?? 0,
                      itemBuilder: (context, index) {
                        if (cubit.group != null) {
                          var member = cubit.group?.members![index];
                          var length = ((cubit.maxAmount.toInt() *
                                      (member?.amount ?? 0)) /
                                  10000)
                              .abs();
                          return MemberItem(
                              groupMember: member!, length: length);
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cubit.group?.transactions?.length ?? 0,
                      itemBuilder: (context, index) {
                        if (cubit.group != null &&
                            (cubit.group!.transactions?.length ?? 0) > 0) {
                          var transaction = cubit.group?.transactions![index];
                          return ListTile(
                            tileColor: MyColor.grey_800,
                            title: Text(
                              transaction?.transactionBy ?? "",
                              style: h3().copyWith(fontSize: 14),
                            ),
                            subtitle: Text(
                              "${transaction?.transactionName} : ${transaction?.transactionAmount}",
                              style: h3().copyWith(fontSize: 12),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  showAddMemberSheet() {
    TextEditingController controller = TextEditingController();
    CustomBottomSheet().showSheet(
        context,
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addVerticalSpacing(10),
              Text(
                "Add Member",
                style: h3Bold().copyWith(fontSize: 20),
              ),
              addVerticalSpacing(20),
              CommonTextField(
                hint: "Member id",
                controller: controller,
              ),
              addVerticalSpacing(20),
              commonButton("Add Member", context, () {
                cubit.addMemberInGroup(controller.text.toString());
              })
            ],
          ),
        ));
  }
}
