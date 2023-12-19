import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hote_management/components/custom_elevated_btn.dart';
import 'package:hote_management/components/dropdown_with_input_field.dart';

import '../../../../../../components/custom_chip.dart';
import '../../../../../../components/input_field_with_header.dart';
import '../../../../../../config/app_color.dart';
import '../../dashboard_view_model.dart';

class StartConversationScreen extends StatelessWidget {

  const StartConversationScreen({
    super.key,
    required this.dashboardModel
  });

  final DashboardTabModel  dashboardModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [

        Flexible(
          child: Container(
            decoration:  BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color:Colors.black ),
              color: AppColors.lavenderBlue
            ),
            height: 50.h,
            alignment: Alignment.centerLeft,
            width: 1.0.sw,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Start the Conversation',
              style: TextStyle(
                color: Colors.black,
                fontSize: 4.w,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
        ),

        Flexible(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              border: Border.all(color: Colors.black)
            ),
            width: double.infinity,
            padding: EdgeInsets.all(12.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [

                    Flexible(
                      child: DropDownWithInputField<String>(
                        inputHint: 'Enter guest mobile number',
                        headerLabel: 'Guest Mobile Number',
                        isReadable: true,
                        borderColor: Colors.grey,
                        editingController: dashboardModel.guestMobileNoController,
                        items: dashboardModel.countryCode,
                        selectedItems: dashboardModel.selectedCountryCode,
                        keyboardType: TextInputType.number,
                        onItemSelect: (String? value) => dashboardModel.onCountryCodeChange(value!),
                      ),
                    ),

                    SizedBox(width: 8.w),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Send Message Via",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp
                          )
                        ),

                        SizedBox(height: 4.h),

                        SizedBox(
                          height: 40.h,
                          child: CustomChip<String>(
                            items: dashboardModel.messageViaList,
                            sizePerItems: 24.w,
                            containerBorderColor: Colors.black54,
                            chipTextFontWeight: FontWeight.w400,
                            chipTextFontSize: 3.w,
                            selectedItemColor: AppColors.homeBtnColor,
                            containerBorderRadius: BorderRadius.circular(2.w),
                            onValueSelected: (value) {
                              dashboardModel.onSendMessageVia(value);
                            },
                            selectedItem: dashboardModel.selectedMessageVia,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: 10.w),

                    InputFieldWithHeader(
                      inputFieldWidth: 38.w,
                      borderRadius: BorderRadius.circular(5.r),
                      editingController: dashboardModel.reservationFromController,
                      headerLabel: 'Reservation dates',
                      isReadOnly: true,
                      borderSideColor: Colors.grey,
                      textAlignment: TextAlign.start,
                      inputHint: '',
                      inputType: TextInputType.name,
                      inputAction: TextInputAction.next,
                      hintStyle: const TextStyle(color: Colors.black),
                    ),

                    SizedBox(width: 8.w),

                    InputFieldWithHeader(
                      inputFieldWidth: 38.w,
                      borderRadius: BorderRadius.circular(5.r),
                      editingController: dashboardModel.reservationToController,
                      headerLabel: '',
                      isReadOnly: true,
                      borderSideColor: Colors.grey,
                      hintStyle: const TextStyle(color: Colors.black),
                      inputHint:  '',
                      inputType: TextInputType.datetime,
                      inputAction: TextInputAction.done,
                    ),

                  ],
                ),

                SizedBox(height: 14.h),

                Row(
                  children: [

                    Flexible(
                      child: DropDownWithInputField<String>(
                        inputHint: 'Enter guest full name',
                        headerLabel: 'Guest name',
                        editingController: dashboardModel.guestNameController,
                        items: dashboardModel.titles,
                        isReadable: true,
                        selectedItems: dashboardModel.selectedTitles,
                        borderColor: Colors.grey,
                        onItemSelect: (String? value) => dashboardModel.onTitleChange(value!),
                      ),
                    ),

                    SizedBox(width: 66.w),

                    SizedBox(
                      width: 35.w,
                      child: InputFieldWithHeader(
                        borderRadius: BorderRadius.circular(5.r),
                        editingController: dashboardModel.roomNoController,
                        headerLabel: 'Room Number',
                        inputHint: 'Room #',
                        inputType: TextInputType.number,
                        inputAction: TextInputAction.next,
                        borderSideColor: Colors.grey,
                        hintStyle: const TextStyle(
                          color: Colors.black
                        ),
                      )
                    ),

                    SizedBox(width: 24.w),

                    if (dashboardModel.selectedScheduleReservationFromActive != null
                    && dashboardModel.selectedScheduleReservationFromActive!.messageVia == null
                    && dashboardModel.selectedScheduleReservationFromActive!.roomNo == null)
                      SizedBox(
                        height: 45.h,
                        child: CustomElevatedButton(
                          btnLabel: 'Submit',
                          onBtnPressed: () => dashboardModel.updateScheduleReservation(context),
                          borderColor: Colors.black,
                          btnBorderRadius: BorderRadius.circular(4.w),
                        ),
                      )
                    else
                      SizedBox(
                        height: 45.h,
                        child: CustomElevatedButton(
                          btnLabel: 'Cancel',
                          onBtnPressed: () => dashboardModel.changeStartConversation(),
                          borderColor: Colors.black,
                          btnBorderRadius: BorderRadius.circular(4.w),
                        ),
                      )  
                  ]
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}