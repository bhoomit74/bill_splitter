class GroupMember {
  String? id;
  String? name;
  double? amount;

  GroupMember({this.id, this.name, this.amount});

  GroupMember.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = double.parse(json['amount'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['amount'] = amount;
    return data;
  }

  GroupMember copyWith({String? id, String? name, double? amount}) {
    return GroupMember(
        id: id ?? this.id,
        name: name ?? this.name,
        amount: amount ?? this.amount);
  }
}
