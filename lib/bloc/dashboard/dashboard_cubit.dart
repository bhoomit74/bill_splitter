import 'dart:math';

import 'package:bill_splitter/models/group_member.dart';
import 'package:bill_splitter/models/group_model.dart';
import 'package:bill_splitter/models/transaction_model.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  var firebaseAuth = FirebaseAuth.instance;
  var userRef = FirebaseDatabase.instance.ref("user");
  var allGroupRef = FirebaseDatabase.instance.ref("allGroups");
  var username = "";
  var userId = "";
  GroupModel? group;
  int maxAmount = 0;
  List<GroupModel> userGroupList = [];
  DashboardCubit() : super(DashboardLoading());

  Future<dynamic> getUserDetail() async {
    emit(DashboardLoading());
    userRef.child(firebaseAuth.currentUser?.uid ?? "").get().then((value) {
      username = value.child("name").value.toString();
      userId = value.child("id").value.toString();
      if (value.hasChild("groups")) {
        userGroupList.clear();
        value.child('groups').children.forEach((element) {
          userGroupList.add(GroupModel(
            groupId: element.child('id').value.toString(),
            groupName: element.child('name').value.toString(),
          ));
        });
        fetchGroup(value.child("groups").children.first.key);
      } else {
        emit(GroupNotFound());
      }
    }).onError((error, stackTrace) {
      emit(DashboardError(error.toString()));
    });
  }

  joinGroup(groupId) {
    state is! DashboardLoading
        ? emit(DashboardLoading())
        : emit(DashboardInitial());
    if (firebaseAuth.currentUser != null) {
      allGroupRef.child(groupId).child("groupName").get().then((value) {
        var groupName = value.value.toString();
        print(groupName);
        var group = {"id": groupId, "name": groupName};
        userRef
            .child(firebaseAuth.currentUser!.uid)
            .child('groups')
            .child(groupId)
            .set(group)
            .then((value) {
          var userId = firebaseAuth.currentUser?.uid ?? "";
          var member = GroupMember(
                  name: firebaseAuth.currentUser?.displayName ?? "",
                  id: userId,
                  amount: 0)
              .toJson();
          allGroupRef
              .child(groupId)
              .child("members")
              .child(userId)
              .set(member)
              .then((value) {
            emit(MemberJoined());
            getUserDetail();
          }).onError((error, stackTrace) {
            emit(DashboardError(error.toString()));
          });
        }).onError((error, stackTrace) {
          emit(DashboardError(error.toString()));
        });
      });
    }
  }

  createGroup(String groupName) {
    emit(DashboardLoading());
    if (firebaseAuth.currentUser != null) {
      var groupId = const Uuid().v4();
      var group = GroupModel(groupId: groupId, groupName: groupName).toJson();
      allGroupRef.child(groupId).set(group).then((value) {
        joinGroup(groupId);
      }).onError((error, stackTrace) {
        emit(DashboardError(error.toString()));
      });
    }
  }

  fetchGroup(groupId) {
    state is! DashboardLoading ? emit(DashboardLoading()) : null;
    if (firebaseAuth.currentUser != null) {
      allGroupRef.child(groupId).get().then((value) {
        if (kDebugMode) {
          print(value.value.toString());
          List<GroupMember> members = [];
          value.child("members").children.forEach((element) {
            if (element.child('id').value.toString() == userId) {
              members.insert(
                  0,
                  GroupMember(
                      id: element.child("id").value.toString(),
                      name: element.child("name").value.toString(),
                      amount: double.parse(
                          element.child("amount").value.toString())));
            } else {
              members.add(GroupMember(
                  id: element.child("id").value.toString(),
                  name: element.child("name").value.toString(),
                  amount:
                      double.parse(element.child("amount").value.toString())));
            }
          });
          List<SplitTransaction> transactions = [];
          value.child("transactions").children.forEach((element) {
            List<GroupMember> splitMembers = [];
            element.child("members").children.forEach((member) {
              splitMembers.add(GroupMember(
                  id: member.child("id").value.toString(),
                  name: member.child("name").value.toString(),
                  amount:
                      double.parse(member.child("amount").value.toString())));
            });
            transactions.add(SplitTransaction(
                transactionId: element.child("transactionId").value.toString(),
                transactionName:
                    element.child("transactionName").value.toString(),
                transactionAmount: double.parse(
                    element.child("transactionAmount").value.toString()),
                transactionDescription:
                    element.child("transactionDescription").value.toString(),
                transactionBy: element.child("transactionBy").value.toString(),
                time: int.parse(element.child("time").value.toString()),
                isSettleUpTransaction:
                    element.child("isSettleUpTransaction").value.toString() ==
                        "true",
                members: splitMembers));
          });

          group = GroupModel(
              groupName: value.child("groupName").value.toString(),
              groupId: value.key.toString(),
              members: members,
              transactions: transactions);
          List<double> amounts =
              members.map((e) => e.amount?.abs() ?? 0).toList();
          maxAmount = amounts.reduce(max).toInt();
        }
        emit(DashboardSuccess());
      }).onError((error, stackTrace) {
        emit(DashboardError(error.toString()));
      });
    }
  }

  addMemberInGroup(memberId) {
    state is! DashboardLoading
        ? emit(DashboardLoading())
        : emit(DashboardInitial());
    if (firebaseAuth.currentUser != null) {
      userRef.child(memberId).get().then((value) {
        var member = GroupMember(
                name: value.child("name").value.toString(),
                id: value.child("id").value.toString(),
                amount: 0)
            .toJson();
        allGroupRef
            .child(group?.groupId ?? "")
            .child("members")
            .child(memberId)
            .set(member)
            .then((value) {
          var groupMap = {group?.groupId: group?.groupName};
          userRef.child(memberId).child('groups').set(groupMap).then((value) {
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

  Future<dynamic> logout() async {
    emit(DashboardLoading());
    firebaseAuth.signOut().then((value) {
      emit(LogoutSuccess());
    }).onError((error, stackTrace) {
      emit(DashboardError(error.toString()));
    });
  }

  double getTotalTransactionAmount() {
    double totalTransactionAmount = 0.0;
    group?.transactions?.forEach((element) {
      if (element.isSettleUpTransaction != true) {
        totalTransactionAmount += element.transactionAmount ?? 0;
      }
    });
    return totalTransactionAmount;
  }
}
