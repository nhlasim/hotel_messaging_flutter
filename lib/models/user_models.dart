import 'package:hote_management/log/app_log.dart';
import 'package:intl/intl.dart';

class UserModels {
  final String id;
  final String name;
  final String surname;
  final String countryCode;
  final String mobileNo;
  final String emailId;
  final bool isVerified;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? deletedAt;
  final String? password;
  final String? accessToken;
  final String roles;
  final UserModels? managerDetails;
  final bool isOnline;

  String get concatCountryCodeWithMobileNo {
    return '+$countryCode $mobileNo';
  }

  @override
  String toString() {
    return 'id: $name, name: $name, surname: $surname, roles: $roles, countryCode: $countryCode, created_at: $createdAt, emailId: $emailId, mobileNo: $mobileNo, isActive: $isActive, deleted_at: $deletedAt, password: $password, isVerified: $isVerified, accessToken: $accessToken';
  }

  UserModels({
    required this.name,
    required this.id,
    required this.isActive,
    required this.countryCode,
    required this.createdAt,
    this.deletedAt,
    required this.emailId,
    required this.isVerified,
    required this.mobileNo,
    this.password,
    required this.surname,
    this.accessToken,
    required this.roles,
    this.managerDetails,
    required this.isOnline
  });

  factory UserModels.fromJson(Map<String, dynamic> data) {
    DateTime? createdAt;
    DateTime? deletedAt;

    if (data.containsKey('created_at')) {
      if (data['created_at'] != null) {
        try {
          String? tempCreatedAt = data['created_at'].trim();
          if (tempCreatedAt != null && tempCreatedAt.isNotEmpty) {
            createdAt = DateFormat('dd/MM/yyyy').parse(tempCreatedAt);
          }
        } catch (e) {
          AppLog.d('UserModels', message: 'exception: $e');
        }
      }
    }

    if (data.containsKey('deleted_at')) {
      if (data['deleted_at'] != null) {
        try {
          deletedAt = DateFormat('dd/MM/yyyy').parse(data['deleted_at']);
        } catch (e) {
          deletedAt = null;
          AppLog.d('UserModels', message: 'exception: $e');
        }
      }
    }

    return UserModels(
      name: data['name'],
      roles: data['roles'] ?? data['role'],
      id: data['id'],
      isActive: data['isActive'],
      countryCode: data['countryCode'].toString(),
      createdAt: createdAt,
      emailId: data ['emailId'],
      isVerified: data['isVerified'],
      mobileNo: data['mobileNo'],
      surname: data['surname'],
      deletedAt: deletedAt,
      password: data['password'],
      accessToken: data['accessToken'],
      managerDetails: data.containsKey('managerDetails') && data['managerDetails'] != null
      ? UserModels.fromJson(data['managerDetails'])
      : null,
      isOnline: data['isOnline'] ?? false
    );
  }

  Map<String, dynamic> toJson({bool useAccessToken = false}) {
    Map<String, dynamic> dataJson = {
      'name': name,
      'id': id,
      'isActive': isActive,
      'countryCode': countryCode,
      'emailId': emailId,
      'isVerified': isVerified,
      'mobileNo': mobileNo,
      'surname': surname,
      'password': password,
      'roles': roles,
      'isOnline': isOnline
    };

    if (useAccessToken) {
      dataJson.addEntries({'accessToken': accessToken}.entries);
    }
    return dataJson;
  }
}