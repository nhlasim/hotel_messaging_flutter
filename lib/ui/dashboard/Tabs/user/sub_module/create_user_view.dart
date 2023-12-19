import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hote_management/models/user_models.dart';
import 'package:hote_management/ui/dashboard/Tabs/user/user_view_model.dart';

import '../../../../../components/custom_elevated_btn.dart';
import '../../../../../components/input_field_with_header.dart';
import '../../../../../config/app_color.dart';
import '../../../../../enum/user_roles.dart';
import '../../../components/custom_radio_button.dart';

class CreateUserView extends StatelessWidget {

  final UserViewModel userViewModel;
  final UserRoles userRoles;

  const CreateUserView({
    super.key,
    required this.userViewModel,
    required this.userRoles
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border(bottom: BorderSide(color: Colors.black)),
            color: AppColors.lavenderBlue
          ),
          height: 50.h,
          alignment: Alignment.centerLeft,
          width: 1.0.sw,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: const Text(
            'Create User',
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w600
            ),
          ),
        ),

        SizedBox(height: 4.h,),

        Container(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Flexible(
                    child: InputFieldWithHeader(
                      editingController: userViewModel.nameController,
                      headerLabel: 'Name',
                      inputHint: 'Type name',
                      inputType: TextInputType.name,
                      inputAction: TextInputAction.next,
                    ),
                  ),

                  SizedBox(width: 20.w,),

                  Flexible(
                    child: InputFieldWithHeader(
                      editingController: userViewModel.surnameController,
                      headerLabel: 'Surname',
                      inputHint: 'Type surname',
                      inputType: TextInputType.name,
                      inputAction: TextInputAction.next,
                    ),
                  )

                ],
              ),

              SizedBox(height: 30.h,),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Flexible(
                    child: InputFieldWithHeader(
                      editingController: userViewModel.emailController,
                      headerLabel: 'Email',
                      inputHint: 'Type username',
                      inputType: TextInputType.emailAddress,
                      inputAction: TextInputAction.next,
                    ),
                  ),

                  SizedBox(width: 20.w,),

                  Flexible(
                    child: InputFieldWithHeader(
                      editingController: userViewModel.mobileNoController,
                      headerLabel: 'Mobile',
                      inputHint: 'Type mobile number',
                      inputType: TextInputType.number,
                      inputAction: TextInputAction.done,
                    ),
                  )

                ],
              ),

            ],
          ),
        ),

        SizedBox(height: 12.h,),

        Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                'Role',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w600,
                  fontSize: 12
                ),
              ),

              SizedBox(height: 4.h,),

              Container(
                height: 1.h,
                color: Colors.grey.shade400,
              ),

              SizedBox(height: 4.h,),

              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  CustomRadioButton<UserRoles>(
                    onRadioValueChanged: userViewModel.onUserRoleChanged,
                    radioGroupValue: userViewModel.userRole,
                    radioValue: UserRoles.admin,
                    data: 'Admin'
                  ),

                  SizedBox(width: 10.w,),

                  CustomRadioButton<UserRoles>(
                    onRadioValueChanged: userViewModel.onUserRoleChanged,
                    radioGroupValue: userViewModel.userRole,
                    radioValue: UserRoles.super_user,
                    data: 'Super Admin'
                  ),

                  SizedBox(width: 10.w,),

                  CustomRadioButton<UserRoles>(
                      onRadioValueChanged: userViewModel.onUserRoleChanged,
                      radioGroupValue: userViewModel.userRole,
                      radioValue: UserRoles.manager,
                      data: 'Manager'
                  ),

                  SizedBox(width: 10.w,),

                  CustomRadioButton<UserRoles>(
                    onRadioValueChanged: userViewModel.onUserRoleChanged,
                    radioGroupValue: userViewModel.userRole,
                    radioValue: UserRoles.staff,
                    data: 'Staff'
                  )

                ],
              )

            ],
          ),
        ),

        SizedBox(height: 24.h,),

        if (userViewModel.userRole != null && userViewModel.userRole == UserRoles.staff) ... {
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  'Manager',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),

                SizedBox(height: 12.h,),

                Container(
                  height: 35.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: AppColors.inputBorderColor, width: 2.0)
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<UserModels>(
                      items: (userViewModel.managerDetails ?? []).map((e) {
                        return DropdownMenuItem<UserModels>(
                          value: e,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              child: Text(
                                  "${e.name} ${e.surname}",
                                 style: const TextStyle(
                                   fontSize: 12,
                                   fontWeight: FontWeight.w500
                                 ),
                              ),
                            )
                        );
                      }).toList(),
                      onChanged: (value) {
                        userViewModel.onManagerChanged(value);
                      },
                      isExpanded: true,
                      value: userViewModel.selectedManagerDetails,
                      isDense: true,
                    ),
                  ),
                ),

                SizedBox(height: 12.h,),

              ],
            ),
          ),
        },

        Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
          child: SizedBox(
            height: 35.h,
            child: CustomElevatedButton(
              btnLabel: 'Create',
              labletextstyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              btnBorderRadius: BorderRadius.circular(2.w),
              onBtnPressed: () => userViewModel.onCreateUser(context),
            ),
          ),
        )

      ],
    );
  }
}