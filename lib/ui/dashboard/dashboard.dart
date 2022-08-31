import 'package:bill_splitter/bloc/dashboard/dashboard_cubit.dart';
import 'package:bill_splitter/main.dart';
import 'package:bill_splitter/styles/app_images.dart';
import 'package:bill_splitter/styles/colors.dart';
import 'package:bill_splitter/styles/spacing.dart';
import 'package:bill_splitter/styles/theme.dart';
import 'package:bill_splitter/ui/dashboard/components/member_item.dart';
import 'package:bill_splitter/ui/dashboard/components/transaction_item.dart';
import 'package:bill_splitter/ui/split_screen/split_screen.dart';
import 'package:bill_splitter/widgets/common_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        } else if (state is GroupNotFound) {
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
          backgroundColor: MyColor.white,
          appBar: AppBar(
              title: Text(
                "Dashboard",
                style: h3().copyWith(fontSize: 20),
              ),
              actions: [
                cubit.group != null
                    ? GestureDetector(
                        onTap: () {
                          showAddMemberSheet();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: Icon(
                            CupertinoIcons.person_crop_circle_badge_plus,
                            color: primaryColor,
                          ),
                        ))
                    : Container(),
              ],
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: MyColor.black_800)),
          floatingActionButton: cubit.group != null
              ? FloatingActionButton(
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
                )
              : null,
          drawer: Drawer(
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: MyColor.grey_800,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.person_alt_circle,
                        color: MyColor.black_800,
                        size: 80,
                      ),
                      addVerticalSpacing(5),
                      Text(cubit.username, style: h3().copyWith(fontSize: 20)),
                      addVerticalSpacing(20),
                      buttonSmall(cubit.userId, () {}),
                      addVerticalSpacing(10),
                    ],
                  ),
                ),
                addVerticalSpacing(10),
                ListTile(
                  leading: const Icon(
                    CupertinoIcons.home,
                  ),
                  title: const Text('Dashboard'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    CupertinoIcons.group,
                  ),
                  title: const Text('Create group'),
                  onTap: () {
                    Navigator.pop(context);
                    showCreateGroupSheet();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    CupertinoIcons.square_arrow_left,
                  ),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pop(context);
                    cubit.logout();
                  },
                )
              ],
            ),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                cubit.getUserDetail();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: cubit.group != null,
                          child: Flexible(
                            child: SizedBox(
                              height: 300,
                              child: ListView.builder(
                                shrinkWrap: true,
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
                          ),
                        ),
                        Visibility(
                          visible: cubit.group != null,
                          child: Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cubit.group?.transactions?.length ?? 0,
                              itemBuilder: (context, index) {
                                if (cubit.group != null &&
                                    (cubit.group!.transactions?.length ?? 0) >
                                        0) {
                                  var transaction =
                                      cubit.group?.transactions![index];
                                  if (transaction != null) {
                                    return TransactionItem(
                                        transaction: transaction);
                                  } else {
                                    return Container();
                                  }
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ),
                        ),
                        Visibility(
                          visible: cubit.group == null,
                          child: Center(
                              child: Column(
                            children: [
                              Image.asset(AppImages.onBoardingPage2),
                              addVerticalSpacing(20),
                              const Text("You are not part of any group"),
                              addVerticalSpacing(20),
                              commonButton("Create Group", context, () {
                                showCreateGroupSheet();
                              }),
                            ],
                          )),
                        )
                      ],
                    ),
                  ),
                ),
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

  showCreateGroupSheet() {
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
                "Create Group",
                style: h3Bold().copyWith(fontSize: 20),
              ),
              addVerticalSpacing(20),
              CommonTextField(
                hint: "Group name",
                controller: controller,
              ),
              addVerticalSpacing(20),
              commonButton("Create group", context, () {
                cubit.createGroup(controller.text.toString());
              })
            ],
          ),
        ));
  }
}
