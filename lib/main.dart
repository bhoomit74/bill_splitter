import 'package:bill_splitter/ui/sign_in/sign_in.dart';
import 'package:bill_splitter/ui/signup/signup.dart';
import 'package:bill_splitter/ui/split_screen/settle_up_screen.dart';
import 'package:bill_splitter/ui/split_screen/split_screen.dart';
import 'package:bill_splitter/ui/transaction_detail/transaction_detail.dart';
import 'package:bill_splitter/utils/global_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'ui/dashboard/dashboard.dart';

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.transparent,
          )),
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? SignInScreen.routeName
          : Dashboard.routeName,
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        Dashboard.routeName: (context) => const Dashboard(),
        SettleUpScreen.routeName: (context) =>
            SettleUpScreen(group: navGroup, member: navSettleUpMember),
        SplitScreen.splitScreenRoute: (context) => SplitScreen(group: navGroup),
        TransactionDetail.routeName: (context) =>
            TransactionDetail(transaction: navTransaction!)
      },
    );
  }
}
