import 'package:flutter/material.dart';
import 'package:hote_management/config/app_toast.dart';
import 'package:hote_management/models/settings_model.dart';
import 'package:intl/intl.dart';

import '../../../../log/app_log.dart';
import '../../../../services/http_services.dart';

class SettingViewModel extends ChangeNotifier {

  ///CONTROLLERS USED FOR MANAGEMENT
  final targetResTimeController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  DateTime? startDateTime, endDateTime;

  ///CONTROLLERS USED FOR ADMINISTRATION
  final minPasswordLengthController = TextEditingController();
  final minNumericCharacterCountController = TextEditingController();
  final lockUserAfterFailLoginController = TextEditingController();
  final failLoginAttemptWithinController = TextEditingController();
  final tempPasswordDurationController = TextEditingController();

  final passwordResetController = TextEditingController();

  SettingsModel? settingsModel;

  bool isLoading = false;

  Future<void> fetchSettings(BuildContext context) async {
    if (settingsModel == null) {
      final fetchResult = await getRequest('settings', context: context);
      if (fetchResult != null) {
        settingsModel = SettingsModel.fromJson(fetchResult);
        if (settingsModel != null) {

          if (settingsModel!.managementSetting != null) {
            targetResTimeController.text = settingsModel!.managementSetting!.targetResponseTime.toString();
            startDateController.text = DateFormat("dd-MM-yyyy").format(settingsModel!.managementSetting!.startDate);
            startDateTime = settingsModel!.managementSetting!.startDate;
            endDateController.text = DateFormat("dd-MM-yyyy").format(settingsModel!.managementSetting!.endDate);
            endDateTime = settingsModel!.managementSetting!.endDate;
          }

          if (settingsModel!.administrationSetting != null) {
            minPasswordLengthController.text = settingsModel!.administrationSetting!.minPasswordLength;
            minNumericCharacterCountController.text = settingsModel!.administrationSetting!.minNumericCharacterCount;
            lockUserAfterFailLoginController.text = settingsModel!.administrationSetting!.lockUserAfterFailLogin;
            failLoginAttemptWithinController.text = settingsModel!.administrationSetting!.failLoginAttemptWithin;
            tempPasswordDurationController.text = settingsModel!.administrationSetting!.temporaryPasswordDuration;
          }

        }
        notifyListeners();
      }
    }
  }

  Future<void> onResetPasswordPressed(BuildContext context) async {
    if (passwordResetController.text.trim().isEmpty) {
      AppToast.showToastMsg('Username should not be empty.');
      return;
    }

    try {

      isLoading = true;
      notifyListeners();

      String url = 'auth/reset-password?emailId=${passwordResetController.text.trim()}';
      final response = await getRequest(url, context: context);
      if (response != null) {
        AppToast.showToastMsg('Reset Password link has been sent on ${passwordResetController.text.trim()}', bgColor: Colors.green.shade600);
        passwordResetController.clear();
        return;
      }
    } catch (e) {
      AppLog.d('Login View Model', message: 'exception: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onManagementSaveChanges(BuildContext context) async {
    String targetResponseTime = targetResTimeController.text.trim();

    if (startDateTime == null) {
      AppToast.showToastMsg('Start date should not be empty.');
      return;
    }

    if (endDateTime == null) {
      AppToast.showToastMsg('End date should not be empty.');
      return;
    }

    final dateformat = DateFormat('yyyy-MM-dd HH:mm');
    try {

      final bodyParams = {
        'target_response_time': targetResponseTime,
        'startDate': dateformat.format(startDateTime!),
        'endDate': dateformat.format(endDateTime!)
      };

      isLoading = true;
      notifyListeners();

      final result = await postRequest('settings/management-settings', body: bodyParams, context: context);
      if (result != null) {
        AppToast.showToastMsg('Management setting saved successfully.', bgColor: Colors.green.shade600);
      }

    } catch (e) {
      AppLog.e(e, 'User View Model', message: e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onAdministrationSaveChanges(BuildContext context) async {
    String minPasswordLength = minPasswordLengthController.text.trim();
    String minNumericCharacterCount = minNumericCharacterCountController.text.trim();
    String lockUserAfterFailLogin = lockUserAfterFailLoginController.text.trim();
    String failLoginAttemptWithin = failLoginAttemptWithinController.text.trim();
    String tempPasswordDuration = tempPasswordDurationController.text.trim();

    if (minPasswordLength.isEmpty) {
      AppToast.showToastMsg('Minimum password length should not be empty.');
      return;
    }

    if (minNumericCharacterCount.isEmpty) {
      AppToast.showToastMsg('Minimum character count should not be empty.');
      return;
    }

    if (lockUserAfterFailLogin.isEmpty) {
      AppToast.showToastMsg('Lock user after login after count should not be empty.');
      return;
    }

    if (failLoginAttemptWithin.isEmpty) {
      AppToast.showToastMsg('Login failed attempt (in minutes) should not be empty.');
      return;
    }

    if (tempPasswordDuration.isEmpty) {
      AppToast.showToastMsg('Temporary password duration (in minutes) should not be empty.');
      return;
    }

    try {

      final bodyParams = {
        'minPasswordLength': minPasswordLength,
        'minNumericCharacterCount': minNumericCharacterCount,
        'lockUserAfterFailLogin': lockUserAfterFailLogin,
        'failLoginAttemptWithin': failLoginAttemptWithin,
        'temporaryPasswordDuration': tempPasswordDuration
      };

      isLoading = true;
      notifyListeners();

      final result = await postRequest('settings/administration-settings', body: bodyParams, context: context);
      if (result != null) {
        AppToast.showToastMsg('Administration setting saved successfully.', bgColor: Colors.green.shade600);
      }

    } catch (e) {
      AppLog.e(e, 'User View Model', message: e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}