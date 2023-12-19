import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hote_management/components/input_field_with_header.dart';
import 'package:hote_management/config/app_color.dart';
import 'package:hote_management/enum/user_roles.dart';
import 'package:hote_management/ui/dashboard/Tabs/settings/setting_view_model.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../../components/custom_elevated_btn.dart';

class SettingScreen extends StatelessWidget {

  final UserRoles userRoles;
  const SettingScreen({super.key, required this.userRoles});

  @override
  Widget build(BuildContext context) {
    return ListenableProvider<SettingViewModel>(
      lazy: true,
      create: (context) => SettingViewModel(),
      builder: (context, child) {
        final settingViewModel = context.watch<SettingViewModel>();
        if (settingViewModel.settingsModel == null) {
          settingViewModel.fetchSettings(context);
        }
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
          width: 0.75.sw,
          height: 0.905.sh,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            border: Border.all(color: Colors.black)
          ),
          child: ModalProgressHUD(
            inAsyncCall: settingViewModel.isLoading,
            dismissible: false,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.only(top: 12.h, left: 12.h, right: 12.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Flexible(
                    child: SizedBox(
                      height: 136.h,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                const Text(
                                  'Management',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12
                                  ),
                                ),

                                SizedBox(height: 4.h,),

                                Container(
                                  height: 1.h,
                                  color: Colors.grey.shade400,
                                ),

                              ],
                            ),
                          ),

                          SizedBox(height: 24.h,),

                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              InputFieldWithHeader(
                                editingController: settingViewModel.targetResTimeController,
                                headerLabel: 'Target Response Time',
                                inputHint: '',
                              ),

                              SizedBox(width: 20.w,),

                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  InputFieldWithHeader(
                                    editingController: settingViewModel.startDateController,
                                    headerLabel: 'Start Date',
                                    inputHint: '',
                                    isReadOnly: true,
                                    inputFieldWidth: 40.w,
                                    onDateSelected: (value) {
                                      settingViewModel.startDateController.text = DateFormat('dd-MM-yyyy').format(value);
                                      settingViewModel.startDateTime = value;
                                    },
                                  ),

                                  SizedBox(width: 4.w,),

                                  InputFieldWithHeader(
                                    editingController: settingViewModel.endDateController,
                                    headerLabel: 'End Date',
                                    inputHint: '',
                                    isReadOnly: true,
                                    inputFieldWidth: 40.w,
                                    onDateSelected: (value) {
                                      settingViewModel.endDateController.text = DateFormat('dd-MM-yyyy').format(value);
                                      settingViewModel.endDateTime = value;
                                    },
                                  ),

                                ],
                              ),

                              SizedBox(width: 20.w,),

                              SizedBox(
                                height: 35.h,
                                width: 30.w,
                                child: CustomElevatedButton(
                                  btnLabel: 'Save',
                                  btnBorderRadius: BorderRadius.circular(2.w),
                                  onBtnPressed: () => settingViewModel.onManagementSaveChanges(context),
                                  borderColor: AppColors.primaryColor,
                                  btnColor: AppColors.mediumSeaGreen,
                                  borderWidth: 2.0,
                                ),
                              ),

                            ],
                          )

                        ],
                      ),
                    ),
                  ),

                  if (userRoles == UserRoles.admin)
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                const Text(
                                  'Administration',
                                  style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12
                                  ),
                                ),

                                SizedBox(height: 4.h,),

                                Container(
                                  height: 1.h,
                                  color: Colors.grey.shade400,
                                ),

                              ],
                            ),
                          ),

                          SizedBox(height: 24.h,),

                          InputFieldWithHeader(
                            editingController: settingViewModel.minPasswordLengthController,
                            headerLabel: 'Min Password Length',
                            inputHint: '',
                            inputType: TextInputType.number,
                            textAlignment: TextAlign.center,
                          ),

                          SizedBox(height: 24.h,),

                          InputFieldWithHeader(
                            editingController: settingViewModel.minNumericCharacterCountController,
                            headerLabel: 'Minimum Numeric Character Count',
                            inputHint: '',
                            inputType: TextInputType.number,
                            textAlignment: TextAlign.center,
                          ),

                          SizedBox(height: 24.h,),

                          SizedBox(
                            height: 60.h,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                InputFieldWithHeader(
                                  editingController: settingViewModel.lockUserAfterFailLoginController,
                                  headerLabel: 'Locked User After Failed Logins',
                                  inputHint: '',
                                  inputType: TextInputType.number,
                                  textAlignment: TextAlign.center,
                                ),

                                SizedBox(width: 8.w,),

                                Container(
                                  height: 74.h,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 14.0),
                                  child: const Text(
                                      'failed login attempt within',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12
                                      )
                                  ),
                                ),

                                SizedBox(width: 4.w,),

                                Flexible(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 18.0,),
                                      InputFieldWithHeader(
                                        hideHeader: true,
                                        editingController: settingViewModel.failLoginAttemptWithinController,
                                        headerLabel: 'Locked User After Failed Logins',
                                        inputHint: '',
                                        inputType: TextInputType.number,
                                        textAlignment: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )

                              ],
                            ),
                          ),

                          SizedBox(height: 24.h,),

                          SizedBox(
                            height: 60.h,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                InputFieldWithHeader(
                                  editingController: settingViewModel.tempPasswordDurationController,
                                  headerLabel: 'Temporary Password Duration',
                                  inputHint: '',
                                  inputType: TextInputType.number,
                                  textAlignment: TextAlign.center,
                                ),

                                SizedBox(width: 8.w,),

                                Container(
                                  height: 60.h,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: const Text(
                                      'minutes',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12
                                      )
                                  ),
                                ),

                              ],
                            ),
                          ),

                          SizedBox(height: 24.h,),

                          SizedBox(
                            height: 60.h,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                InputFieldWithHeader(
                                  editingController: settingViewModel.passwordResetController,
                                  headerLabel: 'Password Reset',
                                  inputHint: 'Username',
                                  inputType: TextInputType.number,
                                  textAlignment: TextAlign.center,
                                ),

                                SizedBox(width: 4.w,),

                                Container(
                                  height: 35.h,
                                  width: 40.w,
                                  margin: const EdgeInsets.only(top: 20.0),
                                  child: CustomElevatedButton(
                                    btnLabel: 'Reset',
                                    btnBorderRadius: BorderRadius.circular(2.w),
                                    onBtnPressed: () => settingViewModel.onResetPasswordPressed(context),
                                  ),
                                ),

                              ],
                            ),
                          ),

                          SizedBox(height: 18.h,),

                          SizedBox(
                            height: 35.h,
                            width: 40.w,
                            child: CustomElevatedButton(
                              btnLabel: 'Save Changes',
                              btnBorderRadius: BorderRadius.circular(2.w),
                              onBtnPressed: () => settingViewModel.onAdministrationSaveChanges(context),
                              borderColor: AppColors.primaryColor,
                              btnColor: AppColors.mediumSeaGreen,
                              borderWidth: 2.0,
                            ),
                          ),

                        ],
                      ),
                    )

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}