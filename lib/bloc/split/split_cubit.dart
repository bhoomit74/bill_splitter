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

  var allGroupRef = FirebaseDatabase.instance.ref("allGroups");

  SplitCubit(this.group) : super(SplitInitial()) {
    splitMembers.addAll(group?.members ?? []);
  }

  addSplit(name, desc) {
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
    if (amount.isNotEmpty) {
      totalSplitAmount = double.parse(amount);
      splitAmount = (totalSplitAmount / splitMembers.length);
      emit(SplitChanged());
    } else {
      splitAmount = 0.0;
      emit(SplitChanged());
    }
  }
}
