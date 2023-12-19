import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hote_management/log/app_log.dart';
import 'package:hote_management/ui/password/components/password_strength_checker.dart';

import '../../components/custom_elevated_btn.dart';
import '../../config/app_color.dart';
import '../../config/app_toast.dart';
import '../../config/constants.dart';
import '../../services/http_services.dart';
import '../login/components/header_with_input.dart';

class PasswordScreen extends StatefulWidget {

  final String token;

  const PasswordScreen({super.key, required this.token});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool useNewPasswordObscure = true;
  bool useConfirmPasswordObscure = true;

  bool isLoading = true;
  bool isPasswordVerificationLinkExpired = false;
  bool _isStrong = false;

  String? id;

  @override
  void initState() {
    super.initState();
    passwordTokenExpiration(widget.token);
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.white,
      title: 'Password',
      child: Scaffold(
        backgroundColor: const Color(0xFFD7D7D7),
        body: Builder(
          builder: (context) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (isPasswordVerificationLinkExpired) {
              return Center(
                child: Text(
                  'Password verification link has been expired.\nPlease try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.h,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54
                  ),
                ),
              );
            }

            return Center(
              child: Container(
                width: 150.w,
                height: 500.h,
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

                    SizedBox(
                      height: 180.h,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          HeaderWithInput(
                            editingController: newPasswordController,
                            header: 'New Password',
                            inputType: TextInputType.visiblePassword,
                            shouldObscureText: useNewPasswordObscure,
                            onObscureChange: () => setState(() => useNewPasswordObscure = !useNewPasswordObscure),
                          ),

                          SizedBox(height: 8.h,),

                          Flexible(
                            child: AnimatedBuilder(
                              animation: newPasswordController,
                              builder: (context, child) {
                                final password = newPasswordController.text;
                          
                                return PasswordStrengthChecker(
                                  onStrengthChanged: (bool value) {
                                    setState(() => _isStrong = value);
                                  },
                                  password: password,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30.h,),

                    HeaderWithInput(
                      editingController: confirmPasswordController,
                      header: 'Confirm Password',
                      inputType: TextInputType.visiblePassword,
                      shouldObscureText: useConfirmPasswordObscure,
                      onObscureChange: () => setState(() => useConfirmPasswordObscure = !useConfirmPasswordObscure),
                    ),

                    SizedBox(height: 30.h,),

                    Flexible(
                      child: SizedBox(
                        width: double.infinity,
                        height: 45.h,
                        child: CustomElevatedButton(
                          btnLabel: 'log in'.toUpperCase(),
                          onBtnPressed: () => onLoginPressed(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> onLoginPressed() async {
    String password = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    if (password != confirmPassword) {
      AppToast.showToastMsg('Password Mismatch', fontSize: 18.h, bgColor: Colors.red.shade600);
      return;
    }

    if (!_isStrong) {
      AppToast.showToastMsg('PLease try to create strong password.', fontSize: 18.h, bgColor: Colors.red.shade600);
      return;
    }

    try {
      String url = 'auth/generate-password';
      Map<String, dynamic> body = {'id': id, 'password': password};
      final userModel = await postRequest(url, body: body);
      if (userModel != null) {
        if (!mounted) return;
        Router.neglect(context, () {
          context.go('/');
        });
      }
    } catch (e) {
      AppLog.d('Password View Model', message: 'exception: $e', methodName: 'onLoginPressed');
    }
  }

  Future<void> passwordTokenExpiration(String token) async {
    try {
      String url = 'auth/token-expiration-password?token=$token';
      final response = await getRequest(url, context: context);
      AppLog.d('PasswordViewModel', message: 'response: $response', methodName: 'passwordTokenExpiration');
      if (response != null) {
        id = response['id'];
        isPasswordVerificationLinkExpired = false;
      } else {
        isPasswordVerificationLinkExpired = true;
      }
    } catch (e) {
      AppLog.d('Password View Model', message: 'exception: $e', methodName: 'passwordTokenExpiration');
    } finally {
      isLoading = false;
    }
    if (!mounted) return;
    setState(() {});
  }

}
