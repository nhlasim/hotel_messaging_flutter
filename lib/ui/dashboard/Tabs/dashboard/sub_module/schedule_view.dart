import 'package:flutter/material.dart';
import 'package:hote_management/ui/dashboard/Tabs/dashboard/dashboard_view_model.dart';

import 'schedule_reservation/create_schedule_reservation.dart';
import 'schedule_reservation/schedule_reservation_details.dart';

class ScheduleScreen extends StatelessWidget {

  final DashboardTabModel dashboardTabModel;

  const ScheduleScreen({super.key, required this.dashboardTabModel});

  @override
  Widget build(BuildContext context) {
    return dashboardTabModel.createScheduleConversation
    ? CreateScheduleReservation(dashboardTabModel: dashboardTabModel)
    : ScheduleReservationDetails(dashboardTabModel: dashboardTabModel);
  }
}