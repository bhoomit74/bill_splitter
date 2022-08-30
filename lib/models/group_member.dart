class GroupMember {
  String? id;
  String? name;
  double? amount;

  GroupMember({this.id, this.name, this.amount});

  GroupMember.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['amount'] = amount;
    return data;
  }
}
