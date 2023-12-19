// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hote_management/log/app_log.dart';
import 'package:hote_management/models/user_models.dart';
import 'package:hote_management/services/http_services.dart';
import 'package:hote_management/services/storage_services.dart';

import '../../config/app_toast.dart';

class LoginViewModel extends ChangeNotifier {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool shouldObscure = true;
  bool isLoading = false;

  void onObscureChange() {
    shouldObscure = !shouldObscure;
    AppLog.d('LoginViewModel', message: 'Obscure: $shouldObscure');
    notifyListeners();
  }

  Future<void> onResetPasswordPressed(BuildContext context) async {
    if (emailController.text.trim().isEmpty) {
      AppToast.showToastMsg('EmailId should not be empty.');
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      String url = 'auth/reset-password?emailId=${emailController.text.trim()}';
      final response = await getRequest(url, context: context);
      if (response != null) {
        AppToast.showToastMsg('Reset Password link has been sent on ${emailController.text.trim()}', bgColor: Colors.green.shade600);
        return;
      }
    } catch (e) {
      AppLog.d('Login View Model', message: 'exception: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onLoginPressed(BuildContext context) async {
    if (emailController.text.trim().isEmpty) {
      AppToast.showToastMsg('EmailId should not be empty.');
      return;
    }

    isLoading = true;
    notifyListeners();

    try {

      Map<String, dynamic> body = {'emailId': emailController.text.trim(), 'password': passwordController.text.trim()};
      final response = await postRequest('auth', body: body, context: context);
      if (response != null) {
        UserModels userModels = UserModels.fromJson(response);
        if (userModels.password == null) {
          AppToast.showToastMsg('Password creation link has been sent on ${emailController.text.trim()}', bgColor: Colors.green.shade600);
          return;
        }
        AppToast.showToastMsg('Login Successfully.');
        await StorageServices.setUser(json.encode(userModels.toJson(useAccessToken: true)));
        Router.neglect(context, () {
          context.go('/dashboard');
        });
      }
    } catch (e) {
      AppLog.d('Login View Model', message: 'exception: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}