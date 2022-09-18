import 'package:firebase_database/firebase_database.dart';

class Reference {
  static final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  static DatabaseReference users = _firebaseDatabase.ref("users");
  static DatabaseReference groups = _firebaseDatabase.ref("allGroups");
}
