import 'package:bill_splitter/models/group_model.dart';
import 'package:bill_splitter/models/transaction_model.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

import '../../models/group_member.dart';

part 'split_state.dart';

class SplitCubit extends Cubit<SplitState> {
  GroupModel? group;
  List<GroupMember> splitMembers = [];
  double totalSplitAmount = 0;
  double splitAmount = 0;
  GroupMember? settleMember;

  var allGroupRef = FirebaseDatabase.instance.ref("allGroups");

  SplitCubit(this.group, {this.settleMember}) : super(SplitInitial()) {
    if (settleMember == null) {
      splitMembers.addAll(group?.members ?? []);
    } else {
      splitMembers.add(settleMember!);
      GroupMember? member = group?.members?.singleWhere(
          (element) => FirebaseAuth.instance.currentUser?.uid == element.id);
      if (member != null) {
        changeTotalSplitAmount(member.amount?.abs().toString() ?? "0");
      }
    }
  }

  addSplit(name, desc, {isSettleUpTransaction = false}) {
    emit(SplitLoading());
    for (var element in splitMembers) {
      element.amount = (element.amount ?? 0) - splitAmount;
    }
    group?.members?.forEach((element) {
      if (element.id == FirebaseAuth.instance.currentUser?.uid) {
        element.amount = (element.amount ?? 0) + totalSplitAmount;
      }
    });
    List<GroupMember> transactionMember = [];
    splitMembers.forEach((element) {
      transactionMember.add(
          GroupMember(id: element.id, name: element.name, amount: splitAmount));
    });
    var transactionId = Uuid().v4();
    var splitTransaction = SplitTransaction(
        transactionId: transactionId,
        transactionName: name,
        transactionDescription: desc,
        transactionAmount: totalSplitAmount,
        transactionBy: FirebaseAuth.instance.currentUser?.displayName,
        time: DateTime.now().microsecondsSinceEpoch,
        isSettleUpTransaction: isSettleUpTransaction,
        members: transactionMember);

    /*group?.transactions ??= [];
    group?.transactions?.add(splitTransaction);
    group?.members?.forEach((element) {
      print("${element.name} : ${element.amount}");
    });
    group?.transactions?.forEach((element) {
      print("${element.transactionName} ${element.transactionAmount}");
    });*/
    Map<String, dynamic> update = {};
    group?.members?.forEach((element) {
      update["members/${element.id}/amount"] = element.amount;
    });
    update["transactions/$transactionId"] = splitTransaction.toJson();
    allGroupRef.child(group?.groupId ?? "0").update(update).then((value) {
      emit(SplitSuccess());
    }).onError((error, stackTrace) {
      emit(SplitError(error.toString()));
    });
  }

  settleUp() {
    var title =
        "${FirebaseAuth.instance.currentUser?.displayName} settle up with ${settleMember?.name}";
    var description =
        "${FirebaseAuth.instance.currentUser?.displayName} Paid money to ${settleMember?.name} for settle up";
    addSplit(title, description, isSettleUpTransaction: true);
  }

  removeMemberFromSplit(GroupMember member) {
    splitMembers.remove(member);
    splitAmount = (totalSplitAmount / splitMembers.length);
    emit(SplitChanged());
  }

  addMemberFromSplit(GroupMember member) {
    splitMembers.add(member);
    splitAmount = (totalSplitAmount / splitMembers.length);
    emit(SplitChanged());
  }

  changeTotalSplitAmount(String amount) {
    print("Total amount : ${amount}");
    try {
      if (amount.isNotEmpty) {
        if (amount.endsWith('.')) {
          amount.replaceAll('.', '');
        }
        totalSplitAmount = double.parse(amount);
        splitAmount = (totalSplitAmount / splitMembers.length);
        emit(SplitChanged());
      } else {
        splitAmount = 0.0;
        emit(SplitChanged());
      }
    } catch (exception) {
      totalSplitAmount = 0;
      splitAmount = 0;
    }
  }
}
