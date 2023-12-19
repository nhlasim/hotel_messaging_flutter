import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hote_management/config/app_assets.dart';
import 'package:hote_management/models/user_models.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../../components/custom_chip.dart';
import '../../../../components/custom_elevated_btn.dart';
import 'dashboard_view_model.dart';
import 'sub_module/active/conversation_view.dart';
import 'sub_module/schedule_view.dart';
import 'sub_module/active/start_conversation_view.dart';

class DashboardScreen extends StatelessWidget {

  final UserModels userModels;

  const DashboardScreen({super.key, required this.userModels});

  @override
  Widget build(BuildContext context) {

    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(2.w),
      borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))
    );

    return Consumer<DashboardTabModel>(
    // return ListenableProvider<DashboardTabModel>(
    //   lazy: true,
    //   create: (_) => DashboardTabModel(userModels),
      builder: (context, dashboardModel, child) {
        dashboardModel.loggedInUserModels ??= userModels;
        // final dashboardModel = context.watch<DashboardTabModel>();
        return Container(
          margin: EdgeInsets.only(top: 2.h, left: 2.w, right: 2.w),
          width: 0.75.sw,
          height: 0.91.sh,
          child: ModalProgressHUD(
            inAsyncCall: dashboardModel.useLoader,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                if (!dashboardModel.shouldStartConversation) ... {
                  Flexible(
                    child: Container(
                      height: dashboardModel.selectedMessageStats == dashboardModel.messageStats[1] ?  134.h : 0.1.sh,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        border: Border.all(color: Colors.black)
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          SizedBox(
                            height: 66.h,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [

                                    Container(
                                      width: 120.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2.w),
                                        border: Border.all(color: Colors.grey.withOpacity(0.4))
                                      ),
                                      child: TextField(
                                        controller: dashboardModel.searchController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: outlineInputBorder,
                                          focusedBorder: outlineInputBorder,
                                          enabledBorder: outlineInputBorder,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                                          hintText: 'Add mobile number to send a message (Example: 1234567890)',
                                          isDense: true,
                                          alignLabelWithHint: true,
                                          hintStyle: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey.withOpacity(0.4)
                                          ),
                                        ),
                                        onSubmitted: (String value) {
                                          if (dashboardModel.selectedMessageStats != dashboardModel.messageStats[1]) {
                                            dashboardModel.conversationChatList.clear();
                                            dashboardModel.searchScheduleReservationByMobile(context);
                                          }
                                        },
                                        textInputAction: TextInputAction.search,
                                        textCapitalization: TextCapitalization.none,
                                        enableSuggestions: true,
                                        enableInteractiveSelection: true,
                                        enableIMEPersonalizedLearning: true,
                                        enabled: true,
                                        autocorrect: true,
                                        onChanged: (String value) {
                                          if (dashboardModel.selectedMessageStats == dashboardModel.messageStats[1]) {
                                            dashboardModel.searchScheduleReservationByMobileNo(value);
                                          }
                                        },
                                      ),
                                    ),

                                    SizedBox(width: 4.w,),

                                    if (dashboardModel.selectedMessageStats != dashboardModel.messageStats[1])
                                      GestureDetector(
                                        onTap: () => dashboardModel.searchScheduleReservationByMobile(context, openStartConversation: true),
                                        child: Container(
                                          height: 35.h,
                                          width: 17.5.w,
                                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey.withOpacity(0.4)),
                                            borderRadius: BorderRadius.circular(5.r)
                                          ),
                                          child: Image.asset(
                                            AppAssets.messenger,
                                            fit: BoxFit.contain
                                          ),
                                        ),
                                      )

                                  ],
                                ),

                                SizedBox(
                                  height: 35.h,
                                  child: CustomChip<String>(
                                    items: dashboardModel.messageStats,
                                    sizePerItems: 24.w,
                                    onValueSelected: (String value) {
                                      dashboardModel.onMessageStatsChange(value, context);
                                    },
                                    selectedItem: dashboardModel.selectedMessageStats,
                                    chipTextFontSize: 12,
                                  ),
                                )

                              ],
                            ),
                          ),

                          if (dashboardModel.selectedMessageStats == dashboardModel.messageStats[1]) ... {
                            SizedBox(height: 1.h,),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  height: 35.h,
                                  child: CustomElevatedButton(
                                    btnLabel: 'Show All',
                                    btnBorderRadius: BorderRadius.circular(2.w),
                                    onBtnPressed: () => dashboardModel.showAllScheduleReservation(),
                                  ),
                                ),
                                SizedBox(width: 4.w,),
                                SizedBox(
                                  height: 35.h,
                                  width: 45.w,
                                  child: CustomElevatedButton(
                                    btnLabel: 'Schedule Reservation',
                                    btnBorderRadius: BorderRadius.circular(2.w),
                                    onBtnPressed: () {
                                      dashboardModel.changeCreateScheduleConversation();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          },

                        ],
                      ),
                    ),
                  ),
                },

                dashboardModel.selectedMessageStats == dashboardModel.messageStats[1]
                ? Container(
                  height: 0.68.sh,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    border: Border.all(color: Colors.black)
                  ),
                  child: ScheduleScreen(dashboardTabModel: dashboardModel)
                )
                : dashboardModel.selectedMessageStats == dashboardModel.messageStats[0]
                ? !dashboardModel.shouldStartConversation
                ? Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 4.h),
                  child: ConversationView(dashboardTabModel: dashboardModel,)
                )
                : StartConversationScreen(dashboardModel: dashboardModel)
                : const SizedBox()
              ],
            ),
          ),
        );
      }
    );
  }
}