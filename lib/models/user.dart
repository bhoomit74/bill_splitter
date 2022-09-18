import 'package:bill_splitter/models/group_basic_info.dart';

class AppUser {
  String? id;
  String? name;
  String? email;
  List<GroupBasicInfo>? groups;

  AppUser({
    this.id,
    this.name,
    this.email,
    this.groups,
  });

  AppUser.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    if (json['groups'] != null) {
      groups = [];
      json['groups'].forEach((v) {
        print(v);
        groups?.add(GroupBasicInfo.fromJson(v));
      });
    } else {
      print("group null");
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    if (groups != null) {
      map['groups '] = groups?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
  }) =>
      AppUser(
        id: id ?? id,
        name: name ?? name,
        email: email ?? email,
      );
}
