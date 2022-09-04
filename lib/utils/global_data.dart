import 'package:firebase_auth/firebase_auth.dart';

import '../models/group_member.dart';
import '../models/group_model.dart';
import '../models/transaction_model.dart';

GroupModel? navGroup;
GroupMember? navSettleUpMember;
SplitTransaction? navTransaction;

String currentUserId = FirebaseAuth.instance.currentUser?.uid.toString() ?? "0";
