import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hote_management/components/custom_elevated_btn.dart';
import 'package:hote_management/config/app_color.dart';
import 'package:hote_management/ui/login/components/header_with_input.dart';
import 'package:hote_management/ui/login/login_view_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../config/constants.dart';

class LoginScreen extends StatelessWidget {

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Login',
      color: Colors.white,
      child: Scaffold(
        backgroundColor: const Color(0xFFD7D7D7),
        body: ListenableProvider<LoginViewModel>(
          create: (_) => LoginViewModel(),
          builder: (context, child) {
            final loginViewModel = context.watch<LoginViewModel>();
            return ModalProgressHUD(
              inAsyncCall: loginViewModel.isLoading,
              dismissible: false,
              child: Center(
                child: Container(
                  width: 150.w,
                  height: 450.h,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.02.sw),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Center(
                        child: Text(
                          ConstantStrings.appname,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 36.sp,
                            color: AppColors.primaryColor
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h,),

                      HeaderWithInput(
                        editingController: loginViewModel.emailController,
                        header: 'Email',
                        inputType: TextInputType.emailAddress,
                      ),

                      SizedBox(height: 40.h,),

                      HeaderWithInput(
                        editingController: loginViewModel.passwordController,
                        header: 'Password',
                        inputType: TextInputType.visiblePassword,
                        inputAction: TextInputAction.done,
                        shouldObscureText: loginViewModel.shouldObscure,
                        onObscureChange: () => loginViewModel.onObscureChange(),
                        onValueSubmitted: (String value) {
                          loginViewModel.onLoginPressed(context);
                        },
                      ),

                      SizedBox(height: 40.h,),

                      Flexible(
                        child: SizedBox(
                          width: double.infinity,
                          height: 45.h,
                          child: CustomElevatedButton(
                            btnLabel: 'log in'.toUpperCase(),
                            onBtnPressed: () {
                              loginViewModel.onLoginPressed(context);
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h,),

                      Flexible(
                        child: SizedBox(
                          width: double.infinity,
                          height: 45.h,
                          child: CustomElevatedButton(
                            btnLabel: 'reset password'.toUpperCase(),
                            onBtnPressed: () {
                              loginViewModel.onResetPasswordPressed(context);
                            },
                            btnColor: AppColors.resetPasswordBtnColor,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}