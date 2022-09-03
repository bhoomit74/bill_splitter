import 'package:bill_splitter/bloc/dashboard/dashboard_cubit.dart';
import 'package:bill_splitter/main.dart';
import 'package:bill_splitter/styles/app_images.dart';
import 'package:bill_splitter/styles/colors.dart';
import 'package:bill_splitter/styles/spacing.dart';
import 'package:bill_splitter/styles/theme.dart';
import 'package:bill_splitter/ui/dashboard/components/member_item.dart';
import 'package:bill_splitter/ui/dashboard/components/transaction_item.dart';
import 'package:bill_splitter/ui/split_screen/settle_up_screen.dart';
import 'package:bill_splitter/ui/transaction_detail/transaction_detail.dart';
import 'package:bill_splitter/utils/extensions.dart';
import 'package:bill_splitter/widgets/common_check_box.dart';
import 'package:bill_splitter/widgets/common_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';

import '../../widgets/bottom_sheet.dart';
import '../../widgets/progress_dialog.dart';
import '../../widgets/widgets.dart';
import '../sign_in/sign_in.dart';
import '../split_screen/split_screen.dart';

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
      buildWhen: (context, state) {
        return state is DashboardSuccess ||
            state is DashboardLoading ||
            state is GroupNotFound;
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: MyColor.white,
          appBar: _appBar(),
          floatingActionButton: _floatingButton(),
          drawer: _drawer(),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                cubit.getUserDetail();
              },
              child: cubit.group != null
                  ? dashboardWidget()
                  : state is GroupNotFound
                      ? newUser()
                      : Container(),
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

  showGroupsSheet() {
    var groups = cubit.userGroupList;
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
                "Groups",
                style: h3Bold().copyWith(fontSize: 20),
              ),
              addVerticalSpacing(20),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    var group = groups[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: MyColor.white_800),
                      child: Row(
                        children: [
                          MyCheckBox(
                              defaultValue:
                                  group.groupId == cubit.group?.groupId,
                              onChange: (isChecked) {
                                Navigator.pop(context);
                                cubit.fetchGroup(group.groupId);
                              }),
                          addHorizontalSpacing(20),
                          Text(group.groupName.toString(),
                              style: h3().copyWith(
                                  fontSize: 16, color: MyColor.black_800))
                        ],
                      ),
                    ).onClick(() {
                      Navigator.pop(context);
                      cubit.fetchGroup(group.groupId);
                    });
                  },
                ),
              ),
            ],
          ),
        ));
  }

  AppBar _appBar() {
    return AppBar(
        title: Text(
          "Dashboard",
          style: h3().copyWith(fontSize: 20),
        ),
        actions: [
          cubit.group != null
              ? Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: Icon(
                    Icons.person_add_outlined,
                    color: primaryColor,
                    size: 30,
                  ),
                ).onClick(() {
                  showAddMemberSheet();
                })
              : Container(),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: MyColor.black_800));
  }

  FloatingActionButton? _floatingButton() {
    return cubit.group != null
        ? FloatingActionButton(
            onPressed: () {
              selectedGroup = cubit.group;
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
        : null;
  }

  Drawer _drawer() {
    return Drawer(
      child: ListView(
        children: [
          _drawerHeader(),
          addVerticalSpacing(10),
          ListTile(
            leading: Icon(
              CupertinoIcons.home,
              color: MyColor.black_800,
            ),
            title: Text('Dashboard', style: h3Bold().copyWith(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Visibility(
            visible: cubit.group != null,
            child: ListTile(
              leading: Icon(
                CupertinoIcons.arrow_2_squarepath,
                color: MyColor.black_800,
              ),
              title:
                  Text('Change group', style: h3Bold().copyWith(fontSize: 16)),
              onTap: () {
                Navigator.pop(context);
                showGroupsSheet();
              },
            ),
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.group_solid,
              color: MyColor.black_800,
            ),
            title: Text('Create group', style: h3Bold().copyWith(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              showCreateGroupSheet();
            },
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.square_arrow_left,
              color: MyColor.black_800,
            ),
            title: Text('Logout', style: h3Bold().copyWith(fontSize: 16)),
            onTap: () {
              Navigator.pop(context);
              cubit.logout();
            },
          )
        ],
      ),
    );
  }

  Widget _drawerHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        MyColor.blue_700,
        MyColor.blue_700,
        MyColor.blue_800,
      ])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.asset(
                  fit: BoxFit.cover,
                  AppImages.profilePic,
                  width: 60,
                  height: 60,
                ),
              ),
              addHorizontalSpacing(10),
              Text(cubit.username,
                  style: h4Bold()
                      .copyWith(fontSize: 18, color: MyColor.white_800)),
            ],
          ),
          addVerticalSpacing(20),
          buttonSmall(cubit.userId, () async {
            await FlutterShare.share(
                title: "Share member id",
                text: cubit.userId,
                chooserTitle: 'TITLE');
          }),
        ],
      ),
    );
  }

  Widget dashboardWidget() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [memberBarGraph(), transactionsList()],
          ),
        ),
      ),
    );
  }

  Widget memberBarGraph() {
    var groupMembers = cubit.group?.members ?? [];
    return Flexible(
      child: SizedBox(
        height: 280,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: groupMembers.length,
            itemBuilder: (context, index) {
              var member = groupMembers[index];
              var heightPercentage =
                  ((member.amount ?? 0) / cubit.maxAmount.toInt()).abs();
              if (heightPercentage.isNaN) {
                heightPercentage = 0;
              }
              return MemberBarItem(
                      key: UniqueKey(),
                      groupMember: member,
                      heightPercentage: heightPercentage)
                  .onClick(() {
                if (index > 0) {
                  settleUpMember = member;
                  selectedGroup = cubit.group;
                  Navigator.pushNamed(context, SettleUpScreen.routeName)
                      .then((value) {
                    if (value == true) {
                      cubit.getUserDetail();
                    }
                  });
                }
              });
            }),
      ),
    );
  }

  Widget transactionsList() {
    var transactions = cubit.group?.transactions ?? [];
    return transactions.isNotEmpty
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addVerticalSpacing(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Transactions", style: h3().copyWith(fontSize: 16)),
                  Text(
                    "Total spending: ${cubit.getTotalTransactionAmount().convertToRupee()}",
                    style: h5().copyWith(
                        color: MyColor.primaryColor,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
              addVerticalSpacing(16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    var transaction = transactions[index];
                    return TransactionItem(transaction: transaction)
                        .onClick(() {
                      glTransaction = transaction;
                      Navigator.pushNamed(context, TransactionDetail.routeName);
                    });
                  },
                  separatorBuilder: (context, index) {
                    return Container();
                  },
                ),
              ),
            ],
          )
        : SizedBox(
            height: 300,
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.empty,
                  fit: BoxFit.cover,
                  width: 120,
                  height: 120,
                ),
                addVerticalSpacing(10),
                Text(
                  "transactions list is empty",
                  style: h5(),
                )
              ],
            ),
          );
  }

  Widget newUser() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImages.onBoardingPage2),
              addVerticalSpacing(20),
              Text("Just one step away", style: h3Bold()),
              addVerticalSpacing(20),
              Text(
                  "You can create a new group\n or \nYour group already on app then share Id with group creator to join",
                  style: h5(),
                  textAlign: TextAlign.center),
              addVerticalSpacing(20),
              Row(
                children: [
                  Flexible(
                    child: commonButton("Create Group", context, () {
                      showCreateGroupSheet();
                    }),
                  ),
                  addHorizontalSpacing(10),
                  Flexible(
                    child: commonButton("Share Id", context, () async {
                      await FlutterShare.share(
                          title: "Share member id",
                          text: cubit.userId,
                          chooserTitle: 'TITLE');
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
