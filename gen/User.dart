/// id : "id"
/// name : "name"
/// email : "email"

class User {
  User({
    String? id,
    String? name,
    String? email,
  }) {
    _id = id;
    _name = name;
    _email = email;
  }

  User.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
  }
  String? _id;
  String? _name;
  String? _email;
  User copyWith({
    String? id,
    String? name,
    String? email,
  }) =>
      User(
        id: id ?? _id,
        name: name ?? _name,
        email: email ?? _email,
      );
  String? get id => _id;
  String? get name => _name;
  String? get email => _email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    return map;
  }
}
