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
  GroupModel? group;
  int maxAmount = 0;
  DashboardCubit() : super(DashboardInitial());

  Future<dynamic> getUserDetail() async {
    emit(DashboardLoading());
    userRef.child(firebaseAuth.currentUser?.uid ?? "").get().then((value) {
      username = value.child("name").value.toString();
      if (kDebugMode) {
        if (value.hasChild("groups")) {
          fetchGroup(value.child("groups").children.first.key);
        } else {
          emit(DashboardSuccess());
        }
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
        var group = {groupId: groupName};
        userRef
            .child(firebaseAuth.currentUser!.uid)
            .child('groups')
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
            emit(DashboardSuccess());
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
    if (firebaseAuth.currentUser != null) {
      allGroupRef.child(groupId).get().then((value) {
        if (kDebugMode) {
          print(value.value.toString());
          List<GroupMember> members = [];
          value.child("members").children.forEach((element) {
            members.add(GroupMember(
                id: element.child("id").value.toString(),
                name: element.child("name").value.toString(),
                amount:
                    double.parse(element.child("amount").value.toString())));
          });
          List<SplitTransaction> transactions = [];
          value.child("transactions").children.forEach((element) {
            /*print("in transaction child")
            List<GroupMember> splitMembers = [];
            element.child("members").forEach((member) {
              print("in member child");
              splitMembers.add(GroupMember(
                  id: member.child("id").value.toString(),
                  name: member.child("name").value.toString(),
                  amount:
                      double.parse(member.child("amount").value.toString())));
            });*/
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
                members: []));
          });

          print("transactions Length : ${transactions.length}");
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
          emit(MemberJoined());
          getUserDetail();
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
}
