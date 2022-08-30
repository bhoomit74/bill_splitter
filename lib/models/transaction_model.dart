import 'package:bill_splitter/models/group_member.dart';

class SplitTransaction {
  String? transactionId;
  String? transactionName;
  String? transactionDescription;
  String? transactionBy;
  double? transactionAmount;
  int? time;
  List<GroupMember>? members;

  SplitTransaction(
      {this.transactionId,
      this.transactionName,
      this.transactionDescription,
      this.transactionBy,
      this.transactionAmount,
      this.time,
      this.members});

  SplitTransaction.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    transactionName = json['transactionName'];
    transactionDescription = json['transactionDescription'];
    transactionBy = json['transactionBy'];
    transactionAmount = json['transactionAmount'];
    time = json[time];
    if (json['members'] != null) {
      members = <GroupMember>[];
      json['members'].forEach((v) {
        members!.add(GroupMember.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transactionId'] = transactionId;
    data['transactionName'] = transactionName;
    data['transactionDescription'] = transactionDescription;
    data['transactionBy'] = transactionBy;
    data['transactionAmount'] = transactionAmount;
    data['time'] = time;
    if (members != null) {
      data['members'] = members!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
