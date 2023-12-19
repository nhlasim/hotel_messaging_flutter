import 'package:hote_management/log/app_log.dart';
import 'package:intl/intl.dart';

class SettingsModel {
  final ManagementSetting? managementSetting;
  final AdministrationSetting? administrationSetting;

  SettingsModel({ required this.managementSetting, required this.administrationSetting});

  factory SettingsModel.fromJson(Map<String, dynamic> data) {
    return SettingsModel(
      managementSetting: data.containsKey('management') && data['management'] != null
      ? ManagementSetting.fromJson(data['management'])
      : null,
      administrationSetting: data.containsKey('administration') && data['administration'] != null
      ? AdministrationSetting.fromJson(data['administration'])
      : null
    );
  }
}

class ManagementSetting {
  final int targetResponseTime;
  final DateTime startDate;
  final DateTime endDate;
  
  ManagementSetting({
    required this.endDate,
    required this.startDate,
    required this.targetResponseTime
  });
  
  factory ManagementSetting.fromJson(Map<String, dynamic> data) {
    DateTime tempEndDateTime = DateTime.now();
    if (data.containsKey('endDate') && data['endDate'] != null) {
      try {
        tempEndDateTime = DateFormat("yyyy-MM-dd").parse(data['endDate']);
        AppLog.d('Settings Model', message: 'endDate: $tempEndDateTime');
      } catch (e) {
        tempEndDateTime = DateTime.now();
        AppLog.d('Settings Model', message: 'exception (endDate): $e');
      }
    }

    DateTime tempStartDateTime = DateTime.now();
    if (data.containsKey('startDate') && data['startDate'] != null) {
      try {
        tempStartDateTime = DateFormat("yyyy-MM-dd").parse(data['startDate']);
        AppLog.d('Settings Model', message: 'startDate: $tempEndDateTime');
      } catch (e) {
        tempStartDateTime = DateTime.now();
        AppLog.d('Settings Model', message: 'exception (startDate): $e');
      }
    }

    return ManagementSetting(
        endDate: tempEndDateTime,
        startDate: tempStartDateTime,
        targetResponseTime: data['target_response_time']
    );
  }
}

class AdministrationSetting {
  final String minPasswordLength;
  final String minNumericCharacterCount;
  final String lockUserAfterFailLogin;
  final String failLoginAttemptWithin;
  final String temporaryPasswordDuration;

  AdministrationSetting({
    required this.failLoginAttemptWithin,
    required this.lockUserAfterFailLogin,
    required this.minNumericCharacterCount,
    required this.minPasswordLength,
    required this.temporaryPasswordDuration
  });

  factory AdministrationSetting.fromJson(Map<String, dynamic> data) {
    return AdministrationSetting(
        failLoginAttemptWithin: data['failLoginAttemptWithin'],
        lockUserAfterFailLogin: data['lockUserAfterFailLogin'],
        minNumericCharacterCount: data['minNumericCharacterCount'],
        minPasswordLength: data['minPasswordLength'],
        temporaryPasswordDuration: data['temporaryPasswordDuration']
    );
  }
}