import 'package:bill_splitter/styles/app_images.dart';
import 'package:bill_splitter/styles/app_strings.dart';
import 'package:bill_splitter/styles/colors.dart';
import 'package:bill_splitter/styles/spacing.dart';
import 'package:bill_splitter/ui/signup/signup.dart';
import 'package:bill_splitter/widgets/common_text_field.dart';
import 'package:bill_splitter/widgets/progress_dialog.dart';
import 'package:bill_splitter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_cubit.dart';
import '../../styles/theme.dart';
import '../dashboard/dashboard.dart';

class SignInScreen extends StatelessWidget {
  static const String routeName = "SignInScreen";
  final cubit = AuthCubit();

  SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return BlocConsumer<AuthCubit, AuthState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is AuthLoading) {
          ProgressDialogUtils.showProgressDialog(context);
        } else if (state is AuthSuccess) {
          ProgressDialogUtils.dismissProgressDialog();
          Navigator.pushNamedAndRemoveUntil(
              context, Dashboard.routeName, (route) => false);
        } else if (state is AuthError) {
          ProgressDialogUtils.dismissProgressDialog();
          showMessageDialog(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(140),
                          child: Image.asset(
                            AppImages.profilePic,
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      addVerticalSpacing(40),
                      Text(
                        AppStrings.labelHey,
                        style: h3Bold(),
                      ),
                      addVerticalSpacing(6),
                      Text(
                        AppStrings.labelWelcomeBack,
                        style: h3Bold(),
                      ),
                      addVerticalSpacing(10),
                      Row(
                        children: [
                          Text(
                            AppStrings.labelIfYouAreNew,
                            style: h3Light().copyWith(
                                color: MyColor.black_800.withOpacity(0.5),
                                fontSize: 16),
                          ),
                          addHorizontalSpacing(6),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, SignUpScreen.routeName);
                            },
                            child: Text(AppStrings.labelCreateAccount,
                                style: h3Bold(
                                    color: MyColor.blue_700, fontSize: 16)),
                          ),
                        ],
                      ),
                      addVerticalSpacing(30),
                      CommonTextField(
                        controller: emailController,
                        hint: AppStrings.labelEmail,
                      ),
                      addVerticalSpacing(20),
                      CommonTextField(
                        controller: passwordController,
                        hint: AppStrings.labelPassword,
                        obscureText: true,
                      ),
                      addVerticalSpacing(30),
                      commonButton(AppStrings.labelLogin, context, () {
                        cubit.login(emailController.text.trim().toString(),
                            passwordController.text.trim().toString());
                      })
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
