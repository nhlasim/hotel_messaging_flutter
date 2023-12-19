import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../components/custom_elevated_btn.dart';
import '../../../../../config/app_color.dart';
import '../../../../../enum/user_roles.dart';
import '../../../components/custom_header_with_text.dart';
import '../user_view_model.dart';

class DeactivateUserView extends StatelessWidget {

  final UserViewModel userViewModel;
  final UserRoles userRoles;
  final VoidCallback? updateUserSearch;

  const DeactivateUserView({super.key, required this.userRoles, required this.userViewModel, this.updateUserSearch});

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
            'Deactivate/Activate User',
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w600
            ),
          ),
        ),

        if (userViewModel.selectedSearchUser == null)
          const Expanded(
            child: Center(
              child: Text(
                'No User has been selected',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24
                ),
              ),
            ),
          )
        else
          ... [

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [

                  CustomHeaderWithText(
                    label: 'Name',
                    value: userViewModel.selectedSearchUser?.name ?? '',
                  ),

                  CustomHeaderWithText(
                    label: 'Surname',
                    value: userViewModel.selectedSearchUser?.surname ?? '',
                  )

                ],
              ),
            ),

            SizedBox(height: 20.h,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [

                  CustomHeaderWithText(
                    label: 'Email',
                    value: userViewModel.selectedSearchUser?.emailId ?? '',
                  ),

                  CustomHeaderWithText(
                    label: 'Mobile',
                    value: userViewModel.selectedSearchUser?.concatCountryCodeWithMobileNo ?? '',
                  )

                ],
              ),
            ),

            SizedBox(height: 20.h,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [

                  SizedBox(
                    height: 35.h,
                    child: CustomElevatedButton(
                      btnLabel: 'Deactivate',
                      btnBorderRadius: BorderRadius.circular(2.w),
                      btnColor: userViewModel.selectedSearchUser != null
                      ? userViewModel.selectedSearchUser!.isActive ? AppColors.primaryColor : Colors.grey.withOpacity(0.2)
                      : null,
                      labletextstyle: userViewModel.selectedSearchUser != null
                      ? userViewModel.selectedSearchUser!.isActive ? null : const TextStyle(color: Colors.grey)
                      : null,
                      onBtnPressed: () async {
                        await userViewModel.onUserDeActive(context);
                        if (updateUserSearch != null) {
                          updateUserSearch!();
                        }
                      },
                    ),
                  ),

                  SizedBox(width: 40.w,),

                  SizedBox(
                    height: 35.h,
                    child: CustomElevatedButton(
                      btnLabel: 'Activate',
                      btnColor: userViewModel.selectedSearchUser != null
                      ? !userViewModel.selectedSearchUser!.isActive ? AppColors.primaryColor : Colors.grey.withOpacity(0.2)
                      : null,
                      borderColor: Colors.transparent,
                      labletextstyle: userViewModel.selectedSearchUser != null
                      ? !userViewModel.selectedSearchUser!.isActive ? null : const TextStyle(color: Colors.grey)
                      : null,
                      btnBorderRadius: BorderRadius.circular(2.w),
                      onBtnPressed: () async {
                        await userViewModel.onUserActive(context);
                        if (updateUserSearch != null) {
                          updateUserSearch!();
                        }
                      },
                    ),
                  ),

                ],
              ),
            )

          ]

      ],
    );
  }
}