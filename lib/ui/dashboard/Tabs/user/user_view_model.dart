// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hote_management/components/AlertDialog/error_message_dialog.dart';
import 'package:hote_management/config/app_toast.dart';
import 'package:hote_management/log/app_log.dart';
import 'package:hote_management/services/http_services.dart';

import '../../../../enum/user_roles.dart';
import '../../../../models/user_models.dart';

class UserViewModel extends ChangeNotifier {

  final searchController = TextEditingController();

  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileNoController = TextEditingController();

  UserRoles? userRole;

  List<UserModels>? managerDetails;
  UserModels? selectedManagerDetails, selectedSearchUser;

  final userStats = ['Create', 'Deactivate' , 'Delete'];
  String selectedUserStats = 'Create';

  Future<void> onManagerDetailsFetch() async {
    if (managerDetails == null) {
      final fetchResult = await getRequest('user/manager-details?role=${UserRoles.manager.name}');
      managerDetails = (fetchResult as List).map((e) => UserModels.fromJson(e)).toList();
      if (managerDetails != null && managerDetails!.isNotEmpty) {
        selectedManagerDetails = managerDetails!.first;
      }
      notifyListeners();
    }
  }

  void onSelectUserFromSearch(UserModels userModels) {
    selectedSearchUser = userModels;
    notifyListeners();
  }

  void onUserStatsChanged(String value) {
    selectedUserStats = value;
    selectedSearchUser = null;
    searchController.clear();
    notifyListeners();
  }

  void onUserRoleChanged(UserRoles? value) {
    onManagerDetailsFetch();
    if (value != UserRoles.staff) {
      selectedManagerDetails = null;
    }
    userRole = value!;
    notifyListeners();
  }

  void onManagerChanged(UserModels? value) {
    selectedManagerDetails = value;
    notifyListeners();
  }

  Future<void> onUserDelete(BuildContext context) async {
    if (selectedSearchUser != null) {
      try {

        useLoader = true;
        notifyListeners();

        final fetchResult = await deleteRequest('user/delete-user?id=${selectedSearchUser!.id}', context: context);
        if (fetchResult != null) {
          AppToast.showToastMsg('${selectedSearchUser!.name} ${selectedSearchUser!.surname} account has been deleted successfully.', bgColor: Colors.green.shade600);
          selectedSearchUser = null;
          searchController.clear();
        }

      } catch (e) {
        AppLog.e(e, 'User View Model', message: e.toString());
      } finally {
        useLoader = false;
        notifyListeners();
      }
    }
  }

  Future<void> onUserDeActive(BuildContext context) async {
    if (selectedSearchUser != null) {
      if (selectedSearchUser!.isActive == false) {
        showDialog(context: context, builder: (context) => ErrorMsgDialog(errorMsg: '${selectedSearchUser!.name} ${selectedSearchUser!.surname} is already deactivated.'));
        return;
      }

      try {

        useLoader = true;
        notifyListeners();

        final fetchResult = await putRequest('user/deactive-user?id=${selectedSearchUser!.id}', context: context);
        if (fetchResult != null) {
          AppToast.showToastMsg('${selectedSearchUser!.name} ${selectedSearchUser!.surname} account has been deactivated successfully.', bgColor: Colors.green.shade600);
          selectedSearchUser = null;
          searchController.clear();
        } else {
          AppToast.showToastMsg('Something went wrong', bgColor: Colors.red.shade600);
        }

      } catch (e) {
        AppLog.e(e, 'User View Model', message: e.toString());
      } finally {
        useLoader = false;
        notifyListeners();
      }
    }
  }

  Future<void> onUserActive(BuildContext context) async {
    if (selectedSearchUser != null) {
      if (selectedSearchUser!.isActive == true) {
        showDialog(context: context, builder: (context) => ErrorMsgDialog(errorMsg: '${selectedSearchUser!.name} ${selectedSearchUser!.surname} is already active.'));
        return;
      }

      try {

        useLoader = true;
        notifyListeners();

        final fetchResult = await putRequest('user/active-user?id=${selectedSearchUser!.id}', context: context);
        if (fetchResult != null) {
          AppToast.showToastMsg('${selectedSearchUser!.name} ${selectedSearchUser!.surname} account has been activated successfully.', bgColor: Colors.green.shade600);
          selectedSearchUser = null;
          searchController.clear();
        }

      } catch (e) {
        AppLog.e(e, 'User View Model', message: e.toString());
      } finally {
        useLoader = false;
        notifyListeners();
      }
    }
  }

  bool useLoader = false;

  Future<void> onCreateUser(BuildContext context) async {
    final name = nameController.text.trim();
    final surname = surnameController.text.trim();
    final email = emailController.text.trim();
    final mobileNo = mobileNoController.text.trim();

    if (name.isEmpty) {
      AppToast.showToastMsg('Name should not be empty');
      return;
    }

    if (surname.isEmpty) {
      AppToast.showToastMsg('Surname should not be empty');
      return;
    }

    if (email.isEmpty) {
      AppToast.showToastMsg('Email should not be empty');
      return;
    }

    if (mobileNo.isEmpty) {
      AppToast.showToastMsg('Mobile no should not be empty.');
      return;
    }

    if (userRole == null) {
      AppToast.showToastMsg('Please select any one of the role.');
      return;
    }

    try {

      useLoader = true;
      notifyListeners();

      Map<String, dynamic> bodyParams = {
        'name' : name,
        'surname' : surname,
        'emailId': email,
        'countryCode': '+27',
        'mobileNo': mobileNo,
        'role': userRole!.name,
      };

      if (selectedManagerDetails != null) {
        bodyParams.addEntries({'managerDetails' : selectedManagerDetails!.toJson(useAccessToken: false)}.entries);
      }

      final creationResult = await postRequest('user/create-user', body: bodyParams, context: context);
      if (creationResult != null) {
        nameController.clear();
        searchController.clear();
        surnameController.clear();
        mobileNoController.clear();
        emailController.clear();
        userRole = null;
        selectedSearchUser = null;
        AppToast.showToastMsg('User created successfully.', bgColor: Colors.green.shade600);
      }

    } catch (e) {
      AppLog.e(e, 'User View Model', message: e.toString());
    } finally {
      useLoader = false;
      onManagerDetailsFetch();
      notifyListeners();
    }
  }
}