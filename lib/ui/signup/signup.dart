import 'package:bill_splitter/styles/colors.dart';
import 'package:bill_splitter/styles/spacing.dart';
import 'package:bill_splitter/widgets/common_text_field.dart';
import 'package:bill_splitter/widgets/progress_dialog.dart';
import 'package:bill_splitter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_cubit.dart';
import '../../styles/theme.dart';
import '../dashboard/dashboard.dart';

class SignUpScreen extends StatelessWidget {
  static const String routeName = "SignUpScreen";
  final cubit = AuthCubit();

  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return BlocConsumer<AuthCubit, AuthState>(
      bloc: cubit,
      listener: (context, state) {
        if(state is AuthLoading){
          ProgressDialogUtils.showProgressDialog(context);
        }else if(state is AuthSuccess){
          ProgressDialogUtils.dismissProgressDialog();
          Navigator.pushNamedAndRemoveUntil(context, Dashboard.routeName, (route) => false);
        }else if(state is AuthError){
          ProgressDialogUtils.dismissProgressDialog();
          showMessageDialog(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hey,", style: h3Bold(),),
                    addVerticalSpacing(6),
                    Text("Register now.", style: h3Bold(),),
                    addVerticalSpacing(10),
                    Row(
                      children: [
                        Text("If you already have account /", style: h3Light().copyWith(
                            color: MyColor.greyColor, fontSize: 16),),
                        addHorizontalSpacing(6),
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Text("Login",
                              style: h3Bold().copyWith(fontSize: 16)),
                        ),
                      ],
                    ),
                    addVerticalSpacing(40),
                    CommonTextField(
                      controller: nameController,
                      hint: "Your name",
                    ),
                    addVerticalSpacing(20),
                    CommonTextField(
                      controller: emailController,
                      hint: "Email",
                    ),
                    addVerticalSpacing(20),
                    CommonTextField(
                      controller: passwordController,
                      hint: "Password",
                      obscureText: true,
                    ),
                    addVerticalSpacing(30),
                    commonButton("Create account", context, () {
                      cubit.createAccount(
                          nameController.text.trim().toString(),
                          emailController.text.trim().toString(),
                          passwordController.text.trim().toString()
                      );
                    })
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
