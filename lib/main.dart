import 'package:bill_splitter/models/group_member.dart';
import 'package:bill_splitter/models/group_model.dart';
import 'package:bill_splitter/ui/onboarding/onboarding_screen.dart';
import 'package:bill_splitter/ui/sign_in/sign_in.dart';
import 'package:bill_splitter/ui/signup/signup.dart';
import 'package:bill_splitter/ui/split_screen/settle_up_screen.dart';
import 'package:bill_splitter/ui/split_screen/split_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'ui/dashboard/dashboard.dart';

GroupModel? selectedGroup;
GroupMember? settleUpMember;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.transparent,
          )),
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? SignInScreen.routeName
          : Dashboard.routeName,
      routes: {
        OnBoardingScreen.routeName: (context) => const OnBoardingScreen(),
        SignInScreen.routeName: (context) => SignInScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        Dashboard.routeName: (context) => const Dashboard(),
        SettleUpScreen.routeName: (context) =>
            SettleUpScreen(group: selectedGroup, member: settleUpMember),
        SplitScreen.splitScreenRoute: (context) =>
            SplitScreen(group: selectedGroup)
      },
    );
  }
}
