import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hote_management/models/notification_model.dart';
import 'package:hote_management/ui/dashboard/components/side_by_side_text.dart';
import 'package:hote_management/ui/statistics/components/group_chat_item_view.dart';
import 'package:provider/provider.dart';

import '../../components/custom_elevated_btn.dart';
import 'statistics_view_model.dart';

class DashboardStatistics extends StatelessWidget {

  const DashboardStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StatisticsViewModel>(
      builder: (context, statisticsVM, child) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                SizedBox(height: 8.h,),

                const Text(
                  'Last 7 Days',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16
                  ),
                ),

                SizedBox(height: 8.h,),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SideBySideText(value: statisticsVM.totalConversation, label: 'Total Conversation'),

                    SizedBox(height: 4.h,),

                    SideBySideText(value: statisticsVM.averageConversationPerDay, label: 'Average conversation Per Day'),

                    SizedBox(height: 4.h,),

                    SideBySideText(value: statisticsVM.averageResponseTime, label: 'Average response time'),

                  ],
                )
              ],
            ),

            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 8.h,),

                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const Text(
                    'Online Now',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 16
                    ),
                  ),
                ),

                SizedBox(height: 8.h,),

                SizedBox(
                  height: 62.h,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 8.h,),
                    padding: EdgeInsets.zero,
                    itemCount: statisticsVM.onlineUserModels.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final name = '${statisticsVM.onlineUserModels[index].name} ${statisticsVM.onlineUserModels[index].surname}';
                      return Text(
                        name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black
                        ),
                      );
                    },
                  ),
                ),

                const Divider()
              ],
            ),

            Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                SizedBox(height: 8.h,),

                const Text(
                  'Group Chat',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16
                  ),
                ),

                SizedBox(height: 8.h,),

                Container(
                  height: 0.4.sh,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.grey)
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [

                      Expanded(
                        child: ListView.builder(
                          itemCount: statisticsVM.groupedByDateGroupChat.keys.toList().length,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GroupChatItemView(groupChatModels: statisticsVM.groupedByDateGroupChat, index: index);
                          },
                        ),
                      ),

                      Container(
                        color: const Color.fromRGBO(240, 240, 240, 1),
                        padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 4.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Flexible(
                              child: TextField(
                                maxLines: 4,
                                minLines: 1,
                                controller: statisticsVM.messageController,
                                autocorrect: true,
                                enableIMEPersonalizedLearning: true,
                                enableInteractiveSelection: true,
                                enableSuggestions: true,
                                textInputAction: TextInputAction.newline,
                                keyboardType: TextInputType.multiline,
                                style: const TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 2.w),
                                  filled: true,
                                  isDense: true,
                                  hintStyle: const TextStyle(fontSize: 12, color: Color.fromRGBO(191, 191, 191, 1)),
                                  hintText: 'Type a message',
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)
                                  )
                                ),
                              )
                            ),

                            SizedBox(width: 4.w,),

                            CustomElevatedButton(
                              btnLabel: 'Send',
                              btnColor: Colors.white,
                              labletextstyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 12
                              ),
                              onBtnPressed: () => statisticsVM.onSendGroupMessage(context),
                            )

                          ],
                        ),
                      ),

                    ],
                  ),
                )
              ],
            ),

            SizedBox(
              height: 40.h,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Flexible(
                    fit: FlexFit.tight,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const Text(
                          'Desktop Notification',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black
                          ),
                        ),

                        SizedBox(width: 8.w,),

                        Container(
                          decoration: BoxDecoration(
                            color: statisticsVM.notificationModelData.isEmpty ? Colors.green : Colors.red,
                            shape: BoxShape.circle
                          ),
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            '${statisticsVM.notificationModelData.length}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                              color: Colors.white
                            ),
                          ),
                        )

                      ],
                    ),
                  ),

                  PopupMenuButton<NotificationModels>(
                    itemBuilder: (context) {
                      return statisticsVM.notificationModelData.map((e) {
                        return PopupMenuItem<NotificationModels>(
                          value: e,
                          onTap: () => statisticsVM.openPreviousConversation(context, e.mobileNo),
                          child: Text(
                            e.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black
                            ),
                          ),
                        );
                      }).toList();
                    },
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.w)
                    ),
                    position: PopupMenuPosition.under,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  )

                ],
              ),
            ),

          ],
        );
      }
    );
  }
}