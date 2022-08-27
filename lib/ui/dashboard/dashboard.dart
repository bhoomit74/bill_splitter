import 'package:bill_splitter/bloc/auth/auth_cubit.dart';
import 'package:bill_splitter/repository/auth_repository.dart';
import 'package:bill_splitter/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/progress_dialog.dart';
import '../../widgets/widgets.dart';

class Dashboard extends StatefulWidget {
  static const String routeName = "dashboardScreen";

  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final cubit = AuthCubit();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      cubit.getUserDetail();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      bloc: cubit,
      listener: (context, state) {
        if(state is AuthLoading){
          ProgressDialogUtils.showProgressDialog(context);
        }else if(state is AuthSuccess){
          ProgressDialogUtils.dismissProgressDialog();
        }else if(state is AuthError){
          ProgressDialogUtils.dismissProgressDialog();
          showMessageDialog(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Good morning,", style: h3().copyWith(fontSize: 20),),
                  Text(cubit.username,style: h3Light().copyWith(fontSize: 20),)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
