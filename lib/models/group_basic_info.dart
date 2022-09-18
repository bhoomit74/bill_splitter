/// id : "GroupId"
/// name : "GroupName"

class GroupBasicInfo {
  String? id;
  String? name;

  GroupBasicInfo({
    this.id,
    this.name,
  });

  GroupBasicInfo.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

  GroupBasicInfo copyWith({
    String? id,
    String? name,
  }) =>
      GroupBasicInfo(
        id: id ?? this.id,
        name: name ?? this.name,
      );
}
