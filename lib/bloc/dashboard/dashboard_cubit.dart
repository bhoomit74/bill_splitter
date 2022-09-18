import 'dart:math';

import 'package:bill_splitter/models/group_basic_info.dart';
import 'package:bill_splitter/models/group_member.dart';
import 'package:bill_splitter/models/group_model.dart';
import 'package:bill_splitter/models/user.dart';
import 'package:bill_splitter/network/firebase_reference.dart';
import 'package:bill_splitter/utils/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  var currentUser = FirebaseAuth.instance.currentUser;
  var currentUserAmount = 0.0;
  String? selectedGroupId;
  GroupModel? group;
  int maxAmount = 0;
  List<GroupModel> userGroupList = [];
  DashboardCubit() : super(DashboardLoading());

  Future<dynamic> getUserDetail() async {
    emit(DashboardLoading());
    var userSnapShot =
        await Reference.users.child(currentUser?.uid ?? "").get();
    var userMap = userSnapShot.toMap();
    var user = AppUser.fromJson(userMap);
    if (user.groups == null || user.groups!.isEmpty) {
      emit(GroupNotFound());
    } else {
      fetchGroup(selectedGroupId ?? user.groups?.first.id);
    }
  }

  joinGroup(GroupBasicInfo group) async {
    state is! DashboardLoading
        ? emit(DashboardLoading())
        : emit(DashboardInitial());
    if (currentUser != null) {
      var userId = currentUser?.uid ?? "";
      try {
        //add groupInfo to user
        await Reference.users
            .child(userId)
            .child('groups')
            .child(userId)
            .set(group.toJson());

        //add member in group
        var member = GroupMember(
          name: currentUser?.displayName ?? "",
          id: userId,
          amount: 0,
        ).toJson();
        await Reference.groups
            .child(group.id ?? "1")
            .child("members")
            .child(userId)
            .set(member);
        emit(MemberJoined());
        getUserDetail();
      } on FirebaseException catch (e) {
        emit(DashboardError(e.toString()));
      }
    }
  }

  createGroup(String groupName) async {
    emit(DashboardLoading());
    if (currentUser != null) {
      var groupId = const Uuid().v4();
      var groupBasicInfo = GroupBasicInfo(id: groupId, name: groupName);
      try {
        await Reference.groups.child(groupId).set(groupBasicInfo.toJson());
        await joinGroup(groupBasicInfo);
      } on FirebaseException catch (e) {
        emit(DashboardError(e.message ?? ""));
      }
    }
  }

  fetchGroup(groupId) async {
    state is! DashboardLoading ? emit(DashboardLoading()) : null;
    if (currentUser != null) {
      selectedGroupId = groupId;
      var groupsSnapShot = await Reference.groups.child(groupId).get();
      var groupMap = groupsSnapShot.toMap();
      group = GroupModel.fromJson(groupMap);
      List<double> amounts =
          group?.members?.map((e) => e.amount?.abs() ?? 0).toList() ?? [];
      maxAmount = amounts.reduce(max).toInt();
      emit(DashboardSuccess());
    }
  }

  addMemberInGroup(memberId) {
    state is! DashboardLoading
        ? emit(DashboardLoading())
        : emit(DashboardInitial());
    if (currentUser != null) {
      Reference.users.child(memberId).get().then((value) {
        var member = GroupMember(
                name: value.child("name").value.toString(),
                id: value.child("id").value.toString(),
                amount: 0)
            .toJson();
        Reference.groups
            .child(group?.groupId ?? "")
            .child("members")
            .child(memberId)
            .set(member)
            .then((value) {
          var groupMap = {group?.groupId: group?.groupName};
          Reference.users
              .child(memberId)
              .child('groups')
              .set(groupMap)
              .then((value) {
            emit(MemberJoined());
            getUserDetail();
          });
        }).onError((error, stackTrace) {
          emit(DashboardError(error.toString()));
        });
      }).onError((error, stackTrace) {
        emit(DashboardError(error.toString()));
      });
    }
  }

  logout() async {
    emit(DashboardLoading());
    try {
      await FirebaseAuth.instance.signOut();
      emit(LogoutSuccess());
    } on FirebaseException catch (e) {
      emit(DashboardError(e.message ?? ""));
    }
  }

  double getTotalTransactionAmount() {
    double totalTransactionAmount = 0.0;
    group?.transactions?.forEach((element) {
      if (element.isSettleUpTransaction == true) {
        return;
      } else {
        totalTransactionAmount += element.transactionAmount ?? 0;
      }
    });
    return totalTransactionAmount;
  }
}
