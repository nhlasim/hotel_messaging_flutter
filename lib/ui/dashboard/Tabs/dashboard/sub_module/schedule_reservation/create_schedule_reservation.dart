import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hote_management/components/dropdown_with_input_field.dart';
import 'package:hote_management/components/input_field_with_header.dart';
import 'package:hote_management/models/user_models.dart';
import 'package:hote_management/ui/dashboard/Tabs/dashboard/dashboard_view_model.dart';

import '../../../../../../components/custom_elevated_btn.dart';
import '../../../../../../config/app_color.dart';

class CreateScheduleReservation extends StatelessWidget {

  final DashboardTabModel dashboardTabModel;

  const CreateScheduleReservation({
    super.key,
    required this.dashboardTabModel
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "SCHEDULED RESERVATIONS",
            style: TextStyle(
              fontSize: 24,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.sp
            )
          ),

          SizedBox(height: 32.h),
          
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [

              DropDownWithInputField(
                editingController: dashboardTabModel.nameController,
                items: dashboardTabModel.titles,
                selectedItems: dashboardTabModel.selectedTitles,
                onItemSelect: (String? value) => dashboardTabModel.onTitleChange(value!),
                headerLabel: 'Name',
                inputHint: 'Type Name',
                borderColor: Colors.grey,
              ),

              SizedBox(width: 60.w,),

              InputFieldWithHeader(
                editingController: dashboardTabModel.surnameController,
                headerLabel: 'Surname',
                inputHint: 'Type Surname',
              )

            ],
          ),

          SizedBox(height: 32.h),

          Row(
            mainAxisSize: MainAxisSize.max,
            children: [

              DropDownWithInputField(
                editingController: dashboardTabModel.mobileNoController,
                items: dashboardTabModel.countryCode,
                selectedItems: dashboardTabModel.selectedCountryCode,
                onItemSelect: (String? value) {
                  if (dashboardTabModel.editScheduleReservation != null) return;
                   dashboardTabModel.onCountryCodeChange(value!);
                },
                headerLabel: 'Mobile',
                inputHint: 'Example 1234567890',
                isReadable: dashboardTabModel.editScheduleReservation != null,
                borderColor: Colors.grey,
                keyboardType: TextInputType.number,
              ),

              SizedBox(width: 60.w,),

              Row(
                mainAxisSize: MainAxisSize.max,
                children: [

                  InputFieldWithHeader(
                    editingController: dashboardTabModel.startController,
                    headerLabel: 'Start',
                    inputHint: '',
                    inputFieldWidth: 40.w,
                    onDateSelected: (DateTime value) {
                      dashboardTabModel.startController.text = dashboardTabModel.ddMMyyyyFormat.format(value);
                      dashboardTabModel.start = value;
                    },
                    inputType: TextInputType.datetime,
                    isReadOnly: true,
                  ),

                  SizedBox(width: 20.w,),

                  InputFieldWithHeader(
                    editingController: dashboardTabModel.endController,
                    headerLabel: 'End',
                    inputHint: '',
                    inputFieldWidth: 40.w,
                    onDateSelected: (DateTime value) {
                      dashboardTabModel.endController.text = dashboardTabModel.ddMMyyyyFormat.format(value);
                      dashboardTabModel.end = value;
                    },
                    inputType: TextInputType.datetime,
                    isReadOnly: true,
                  ),

                ],
              )

            ],
          ),

          SizedBox(height: 32.h),

          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                'Assigned To',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12
                )
              ),

              SizedBox(height: 2.h,),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  shape: BoxShape.rectangle
                ),
                width: 80.w,
                height: 30.h,
                margin: EdgeInsets.only(top: 4.h),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<UserModels>(
                    items: (dashboardTabModel.staffDetails == null ? <UserModels>[] : dashboardTabModel.staffDetails!).map((e) {
                      return DropdownMenuItem<UserModels>(
                        value: e,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Text(
                            '${e.name} ${e.surname}',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (UserModels? value) => dashboardTabModel.onSelectStaff(value!),
                    value: dashboardTabModel.selectedStaffDetails,
                    alignment: Alignment.center,
                    isExpanded: true,
                  ),
                ),
              ),

            ],
          ),

          SizedBox(height: 32.h),

          Row(
            mainAxisSize: MainAxisSize.max,
            children: [

              SizedBox(
                height: 35.h,
                width: 22.w,
                child: CustomElevatedButton(
                  btnLabel: 'Save',
                  borderColor: AppColors.primaryColor,
                  btnColor: Colors.green.shade600,
                  btnBorderRadius: BorderRadius.circular(2.w),
                  onBtnPressed: () => dashboardTabModel.onScheduleReservationSaveOrUpdate(context),
                ),
              ),

              SizedBox(width: 6.w,),

              SizedBox(
                height: 35.h,
                width: 22.w,
                child: CustomElevatedButton(
                  btnLabel: 'Cancel',
                  btnColor: Colors.grey,
                  btnBorderRadius: BorderRadius.circular(2.w),
                  onBtnPressed: () => dashboardTabModel.changeCreateScheduleConversation(),
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }
}
