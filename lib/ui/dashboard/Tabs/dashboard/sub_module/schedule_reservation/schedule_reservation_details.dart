import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hote_management/ui/dashboard/Tabs/dashboard/dashboard_view_model.dart';
import 'package:intl/intl.dart';

import '../../../../../../components/custom_elevated_btn.dart';
import '../../../../../../models/schedule_reservation_models.dart';

class ScheduleReservationDetails extends StatelessWidget {

  final DashboardTabModel dashboardTabModel;

  const ScheduleReservationDetails({
    super.key,
    required this.dashboardTabModel
  });

  @override
  Widget build(BuildContext context) {
    return (dashboardTabModel.searchScheduleReservationList != null && dashboardTabModel.searchScheduleReservationList!.isEmpty)
    && (dashboardTabModel.scheduleReservationList != null && dashboardTabModel.scheduleReservationList!.isEmpty)
    ? Center(
      child: Text(
        'No Reservation Found',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600
        ),
      ),
    )
    : Container(
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

          SizedBox(height: 4.h),

          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: dashboardTabModel.searchScheduleReservationList?.length ?? 0,
              itemBuilder: (context, index) {
                if (dashboardTabModel.searchScheduleReservationList == null) {
                  return const SizedBox.shrink();
                }
                final items = dashboardTabModel.searchScheduleReservationList![index];
                return ScheduleReservationItems(
                  scheduleReservationModels: items,
                  onDeletePressed: (ScheduleReservationModels value) {
                    dashboardTabModel.onDeleteScheduleReservation(value, context);
                  },
                  onEditPressed: (ScheduleReservationModels value) {
                    dashboardTabModel.onEditScheduleReservation(value.id, context);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class ScheduleReservationItems extends StatelessWidget {

  final ScheduleReservationModels scheduleReservationModels;
  final ValueChanged<ScheduleReservationModels> onDeletePressed;
  final ValueChanged<ScheduleReservationModels> onEditPressed;

  const ScheduleReservationItems({
    super.key,
    required this.scheduleReservationModels,
    required this.onDeletePressed,
    required this.onEditPressed
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("dd/MM/yyyy");

    String name = scheduleReservationModels.name;

    final temporary = scheduleReservationModels.name.split(" ");
    if (temporary.isNotEmpty) {
      name = temporary[temporary.length - 1];
    }
    return Container(
      height: 45.h,
      margin: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(
            width: 34.w,
            child: CustomHeaderWithValue(
              label: "Name",
              value: name
            ),
          ),

          SizedBox(
            width: 34.w,
            child: CustomHeaderWithValue(
              label: "Surname",
              value: scheduleReservationModels.surname
            ),
          ),

          SizedBox(
            width: 40.w,
            child: CustomHeaderWithValue(
              label: "Mobile Number",
              value: "${scheduleReservationModels.countryCode} ${scheduleReservationModels.mobileNo}"
            ),
          ),

          SizedBox(
            width: 34.w,
            child: CustomHeaderWithValue(
              label: "Start Date",
              value: dateFormat.format(scheduleReservationModels.start)
            ),
          ),

          SizedBox(
            width: 34.w,
            child: CustomHeaderWithValue(
              label: "End Date",
              value: dateFormat.format(scheduleReservationModels.end)
            ),
          ),

          SizedBox(
            width: 34.w,
            child: CustomHeaderWithValue(
              label: "Assigned to",
              value: scheduleReservationModels.assignedToUser!.name
            ),
          ),

          SizedBox(width: 8.w,),

          SizedBox(
            width: 20.w,
            height: double.infinity,
            child: CustomElevatedButton(
              btnLabel: "Delete",
              btnColor: Colors.red,
              onBtnPressed: () => onDeletePressed(scheduleReservationModels),
              btnBorderRadius: BorderRadius.circular(5.r)
            ),
          ),

          SizedBox(width: 8.w,),

          SizedBox(
            width: 20.w,
            height: double.infinity,
            child: CustomElevatedButton(
              btnLabel: "Edit",
              onBtnPressed: () => onEditPressed(scheduleReservationModels),
              btnColor: Colors.yellow.shade800,
              btnBorderRadius: BorderRadius.circular(5.r)
            ),
          ),

        ],
      ),
    );
  }
}

class CustomHeaderWithValue extends StatelessWidget {

  const CustomHeaderWithValue({
    super.key,
    required this.label,
    required this.value
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text(
            label,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.bold
            )
        ),

        SizedBox(height: 4.h,),

        Text(
          value,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey
          )
        ),

      ],
    );
  }
}
