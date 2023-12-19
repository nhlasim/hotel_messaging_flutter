import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hote_management/components/custom_elevated_btn.dart';
import 'package:hote_management/components/input_field_with_header.dart';
import 'package:hote_management/enum/user_roles.dart';
import 'package:hote_management/models/user_models.dart';
import 'package:hote_management/ui/dashboard/Tabs/dashboard/dashboard_view_model.dart';
import 'package:hote_management/ui/dashboard/components/chat_item_view.dart';
import 'package:intl/intl.dart';

import '../../../../../../config/app_assets.dart';
import '../../../../../../models/quick_reply_models.dart';
import '../../../../components/conversation_options_items.dart';

class ChatConversationView extends StatelessWidget {

  final DashboardTabModel dashboardTabModel;

  const ChatConversationView({
    super.key,
    required this.dashboardTabModel
  });

  @override
  Widget build(BuildContext context) {
    final userFullName = dashboardTabModel.selectedScheduleReservationFromActive!.fullName;
    final roomNo = dashboardTabModel.selectedScheduleReservationFromActive!.roomNo!;
    final start = dashboardTabModel.ddMMyyyyFormat.format(dashboardTabModel.selectedScheduleReservationFromActive!.start);
    final end = dashboardTabModel.ddMMyyyyFormat.format(dashboardTabModel.selectedScheduleReservationFromActive!.end);
    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 8.h, 4.w, 0.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.black)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(
                      userFullName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black
                      ),
                    ),

                    SizedBox(width: 18.w,),

                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Text(
                            'Room $roomNo',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54
                            ),
                          ),

                          SizedBox(width: 2.w,),

                          Container(
                            height: 16.h,
                            width: 0.5.w,
                            color: Colors.black38,
                          ),

                          SizedBox(width: 2.w,),

                          Text(
                            '$start - $end',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54
                            ),
                          ),

                        ],
                      ),
                    ),

                    SizedBox(width: 18.w,),

                    if (dashboardTabModel.selectedScheduleReservationFromActive != null
                        && dashboardTabModel.selectedScheduleReservationFromActive!.isActiveConversation)
                      CustomElevatedButton(
                        btnLabel: 'Archive',
                        onBtnPressed: () => dashboardTabModel.onArchiveScheduleReservation(context),
                      )

                  ],
                ),

                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    reverse: true,
                    controller: dashboardTabModel.scrollController,
                    itemCount: dashboardTabModel.conversationChatList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final chatItem = dashboardTabModel.conversationChatList[index];

                      final dateFormat = DateFormat('MMM dd hh:mm a');

                      String body, date, type;
                      if (chatItem.senderMessageInstance != null) {
                        type = '${dashboardTabModel.selectedScheduleReservationFromActive!.name}: ';
                        body = chatItem.senderMessageInstance!.body;
                        date = dateFormat.format(chatItem.senderMessageInstance!.dateCreated);
                      } else {
                        type = 'Guest: ';
                        body = chatItem.receiverMessageInstance!.body;
                        date = dateFormat.format(chatItem.receiverMessageInstance!.dateCreated);
                      }

                      return Container(
                        width: 1.sw,
                        margin: EdgeInsets.symmetric(vertical: 4.h),
                        alignment: chatItem.senderMessageInstance == null
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                        child: ChatItemView(
                          messageBody: body,
                          type: type,
                          containerColor: chatItem.senderMessageInstance == null ? const Color(0xFFfdff85) : const Color(0xFF5dffc4),
                          messageDate: date,
                          serverStaticRobotMenu: chatItem.senderMessageInstance?.robotStaticMenu,
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(bottom: 4.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Flexible(
                        child: InputFieldWithHeader(
                          editingController: dashboardTabModel.messageController,
                          headerLabel: '',
                          inputHint: 'Click to send a reply ....',
                          inputFieldWidth: 1.0.sw,
                          hideHeader: true,
                          inputType: TextInputType.multiline,
                          maximumLines: 5,
                          borderRadius: BorderRadius.circular(4.w),
                        ),
                      ),

                      SizedBox(width: 4.w,),

                      SizedBox(
                        height: 35.h,
                        width: 35.w,
                        child: CustomElevatedButton(
                          btnLabel: 'Send',
                          onBtnPressed: () => dashboardTabModel.onMessageSend(context),
                          btnBorderRadius: BorderRadius.circular(2.w),
                          labletextstyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 12
                          ),
                        ),
                      )

                    ],
                  ),
                ),

              ],
            ),
          ),

          SizedBox(width: 8.w,),

          SizedBox(
            width: 60.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                ConversationOptionsItem<QuickReplyModels>(
                  assetName: AppAssets.quickReplyIMG,
                  e: dashboardTabModel.menusBesideConversation[0],
                  items: const [],
                  key: dashboardTabModel.globalKey,
                  usePopupMenuButtonAsTopLevel: false,
                  onCustomPressed: () {
                    Offset offs = const Offset(0,0);
                    final RenderBox button = dashboardTabModel.globalKey.currentContext!.findRenderObject()! as RenderBox;
                    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
                    final RelativeRect position = RelativeRect.fromRect(
                      Rect.fromPoints(
                        button.localToGlobal(offs, ancestor: overlay),
                        button.localToGlobal(button.size.bottomRight(Offset.zero) + offs, ancestor: overlay),
                      ),
                      Offset.zero & overlay.size,
                    );

                    showMenu(
                      context: context,
                      position: position,
                      surfaceTintColor: Colors.white,
                      constraints: BoxConstraints(minWidth: 80.w, maxWidth: 80.w, minHeight: 240.h, maxHeight: 240.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1.w)
                      ),
                      items: [
                        PopupMenuItem(
                          enabled: true,
                          padding: EdgeInsets.zero,
                          // height: 300.h,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                SizedBox(
                                  height: 35.h,
                                  child: TextField(
                                    enabled: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(color: Colors.grey)
                                      ),
                                      alignLabelWithHint: true,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(color: Colors.grey)
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: const BorderSide(color: Colors.grey)
                                      ),
                                      suffixIcon: const Icon(Icons.search_rounded, color: Colors.grey,)
                                    ),
                                  ),
                                ),

                                SizedBox(height: 12.h,),

                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: dashboardTabModel.quickReplyList.map((e) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [

                                        Text(
                                          e.title,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700
                                          ),
                                        ),

                                        SizedBox(height: 12.h,),

                                        Flexible(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: e.replies.length,
                                            physics: const NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  dashboardTabModel.messageController.text = e.replies[index];
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  height: 30.h,
                                                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                                                  child: Text(
                                                    e.replies[index],
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),

                                      ],
                                    );
                                  }).toList(),
                                )

                              ],
                            ),
                          ),
                        )
                      ]
                    );
                  },
                ),

                if (dashboardTabModel.loggedInUserModels != null && dashboardTabModel.loggedInUserModels!.roles.userRoles == UserRoles.manager)
                  ConversationOptionsItem<UserModels>(
                    assetName: AppAssets.handOffIMG,
                    width: 60.w,
                    e: dashboardTabModel.menusBesideConversation[2],
                    items: dashboardTabModel.managerWiseStaffDetails.map((e) {
                      return PopupMenuItem<UserModels>(
                        value: e,
                        height: 35.h,
                        onTap: () {
                          dashboardTabModel.onScheduleReservationHandoff(context, e.id);
                        },
                        padding: EdgeInsets.zero,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Text(
                            '${e.name} ${e.surname}',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

              ],
            ),
          )

        ],
      ),
    );
  }
}