import 'package:bill_splitter/models/group_member.dart';
import 'package:bill_splitter/models/transaction_model.dart';

class GroupModel {
  String? groupId;
  String? groupName;
  List<GroupMember>? members;
  List<SplitTransaction>? transactions;

  GroupModel({this.groupId, this.groupName, this.members, this.transactions});

  GroupModel.fromJson(Map<String, dynamic> json) {
    groupId = json['id'] ?? "";
    groupName = json['name'] ?? "";
    if (json['members'] != null) {
      members = <GroupMember>[];
      json['members'].forEach((v) {
        members?.add(GroupMember.fromJson(v));
      });
    }
    if (json['transactions'] != null) {
      transactions = <SplitTransaction>[];
      json['transactions'].forEach((v) {
        transactions?.add(SplitTransaction.fromJson(v));
      });
    } else {
      transactions = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = groupId;
    data['name'] = groupName;
    if (members != null) {
      data['members'] = members!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
