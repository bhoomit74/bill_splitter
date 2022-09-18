import 'package:bill_splitter/models/group_model.dart';
import 'package:bill_splitter/models/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upi_india/upi_india.dart';
import 'package:uuid/uuid.dart';

import '../../models/group_member.dart';
import '../../network/firebase_reference.dart';
import '../../styles/app_strings.dart';

part 'split_state.dart';

class SplitCubit extends Cubit<SplitState> {
  GroupModel? group;
  List<GroupMember> splitMembers = [];
  double totalSplitAmount = 0;
  double splitAmount = 0;
  GroupMember? settleMember;
  List<UpiApp> upiApps = [];
  UpiIndia upiIndia = UpiIndia();
  bool payViaUPI = true;
  String upiId = "";
  String note = "";
  User? currentUser = FirebaseAuth.instance.currentUser;

  var allGroupRef = FirebaseDatabase.instance.ref("allGroups");

  SplitCubit(this.group, {this.settleMember}) : super(SplitInitial()) {
    if (settleMember == null) {
      splitMembers.addAll(group?.members ?? []);
    } else {
      splitMembers.add(settleMember!);
      GroupMember? member = group?.members
          ?.singleWhere((element) => currentUser?.uid == element.id);
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
      if (element.id == currentUser?.uid) {
        element.amount = (element.amount ?? 0) + totalSplitAmount;
      }
    });
    List<GroupMember> transactionMember = [];
    for (var element in splitMembers) {
      transactionMember.add(element.copyWith(amount: splitAmount));
    }
    var transactionId = const Uuid().v4();
    var splitTransaction = SplitTransaction(
        transactionId: transactionId,
        transactionName: name,
        transactionDescription: desc,
        transactionAmount: totalSplitAmount,
        transactionBy: currentUser?.displayName,
        time: DateTime.now().microsecondsSinceEpoch,
        isSettleUpTransaction: isSettleUpTransaction,
        members: transactionMember);

    Map<String, dynamic> update = {};
    group?.members?.forEach((element) {
      update["members/${element.id}/amount"] = element.amount;
    });
    update["transactions/$transactionId"] = splitTransaction.toJson();

    Reference.groups.child(group?.groupId ?? "0").update(update).then((value) {
      emit(SplitSuccess());
    }).onError((error, stackTrace) {
      emit(SplitError(error.toString()));
    });
  }

  settleUp() {
    var title =
        "${currentUser?.displayName} settle up with ${settleMember?.name}";
    var description =
        "${currentUser?.displayName} Paid money to ${settleMember?.name} for settle up";
    addSplit(title, description, isSettleUpTransaction: true);
  }

  settleUpWithUPI() async {
    print("split up with upi Done");
    /*var title =
        "${FirebaseAuth.instance.currentUser?.displayName} settle up with ${settleMember?.name}";
    var description =
        "${FirebaseAuth.instance.currentUser?.displayName} Paid money to ${settleMember?.name} for settle up";
    addSplit(title, description, isSettleUpTransaction: true);*/
  }

  getUpiAppsFromMobile(String upiId, String note) {
    if (upiId.isNotEmpty) {
      this.upiId = upiId;
      this.note = note;

      upiIndia.getAllUpiApps().then((value) {
        upiApps = value;
        emit(UpiAppUpdated());
      });
    } else {
      emit(SplitError("Please enter UPI Id"));
    }
  }

  initiateTransaction(UpiApp app) async {
    try {
      await upiIndia
          .startTransaction(
              app: app,
              receiverUpiId: upiId,
              receiverName: splitMembers.first.name ?? "",
              transactionRefId: const Uuid().v4(),
              transactionNote: note,
              amount: totalSplitAmount,
              flexibleAmount: false)
          .then((value) {
        switch (value.status) {
          case UpiPaymentStatus.SUCCESS:
            settleUpWithUPI();
            break;
          case UpiPaymentStatus.FAILURE:
            emit(PaymentFailed());
            break;
          case UpiPaymentStatus.SUBMITTED:
            settleUpWithUPI();
            emit(PaymentSubmitted());
            break;
          default:
            break;
        }
      });
    } on UpiIndiaAppNotInstalledException catch (_) {
      emit(SplitError("UPI app not installed in your mobile"));
    } on UpiIndiaUserCancelledException catch (_) {
      emit(SplitError("You have cancelled the transaction"));
    } on UpiIndiaNullResponseException catch (_) {
      emit(SplitError("Requested app didn't return any response"));
    } on UpiIndiaAppsGetException catch (_) {
      emit(SplitError("An Unknown error has occurred"));
    }
  }

  changePaymentMethod(PaymentMethod paymentMethod) {
    payViaUPI = paymentMethod == PaymentMethod.upi;
    emit(PaymentMethodChange());
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
