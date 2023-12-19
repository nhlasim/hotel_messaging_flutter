import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hote_management/models/group_chat_models.dart';
import 'package:hote_management/models/notification_model.dart';
import 'package:hote_management/models/user_models.dart';
import 'package:provider/provider.dart';

import '../../log/app_log.dart';
import '../../services/http_services.dart';
import '../dashboard/Tabs/dashboard/dashboard_view_model.dart';

class StatisticsViewModel extends ChangeNotifier {

  final messageController = TextEditingController();

  Map<DateTime, List<GroupChatModels>> groupedByDateGroupChat = {};
  List<GroupChatModels> groupChatModelData = [];
  List<UserModels> onlineUserModels = [];
  List<NotificationModels> notificationModelData = [];

  UserModels? userModels;

  bool useLoader = false;

  String totalConversation = '0';
  String averageConversationPerDay = '0';
  String averageResponseTime = '00:00:00';

  Future<void> conversationStatistics(BuildContext context) async {

    if (userModels == null) {
      await _getUserByUserId(context);
    }

    try {
      // ignore: use_build_context_synchronously
      final fetchResult = await getRequest('conversation/conversation-statistics', context: context);
      if (fetchResult != null) {
        totalConversation = fetchResult['totalConversation'].toString();
        averageConversationPerDay = fetchResult['averageConversationPerDays'];
        averageResponseTime = fetchResult['averageResponseTime'];
      }
      notifyListeners();
    } catch (e) {
      AppLog.e(e, 'StatisticsViewModel', message: "$e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> firebaseConversationIdWiseChat(BuildContext context) async {
    CollectionReference chatCollection = FirebaseFirestore.instance.collection('chat');
    chatCollection.snapshots().listen((event) async {
      await conversationStatistics(context);
      notifyListeners();
    });
  }

  void firebaseStatisticsNotification() {
    notificationModelData.clear();
    CollectionReference chatCollection = FirebaseFirestore.instance.collection('notification');
    chatCollection.snapshots().listen((event) {
      for (int i = 0; i < event.docChanges.length; i++) {
        AppLog.d('StatisticsViewModel', message: 'firebaseStatisticsNotification: ${event.docChanges[i].type}');
        final notificationModels = NotificationModels.fromJson(event.docChanges[i].doc.data() as Map<String, dynamic>);
        if (event.docChanges[i].type == DocumentChangeType.removed) {
          final index = notificationModelData.indexWhere((element) => notificationModels.id == element.id);
          if (index != -1) {
            notificationModelData.removeAt(index);
          }
        } else if (event.docChanges[i].type == DocumentChangeType.added) {
          notificationModelData.add(notificationModels);
        }
      }
      notifyListeners();
    });
  }

  void firebaseStatisticsGroupChat() {
    groupChatModelData.clear();
    CollectionReference chatCollection = FirebaseFirestore.instance.collection('group_chat');
    chatCollection.orderBy('created_at', descending: true);
    chatCollection.snapshots().listen((event) {
      for (int i = 0; i < event.docChanges.length; i++) {
        final groupChatModels = GroupChatModels.fromJson(event.docChanges[i].doc.data() as Map<String, dynamic>);
        if (event.docChanges[i].type == DocumentChangeType.added) {
          if (groupChatModelData.isNotEmpty) {
            groupChatModelData.insert(groupChatModelData.length - 1, groupChatModels);
          } else {
            groupChatModelData.add(groupChatModels);
          }
        }
      }
      _sortConversationChat();
      groupedByDateGroupChat = groupBy(groupChatModelData, (p0) => DateTime(p0.dateCreated!.year, p0.dateCreated!.month, p0.dateCreated!.day));
      notifyListeners();
    });
  }

  void firebaseStatisticsIsOnlineUser() {
    onlineUserModels.clear();
    CollectionReference chatCollection = FirebaseFirestore.instance.collection('user');
    chatCollection.snapshots().listen((event) {
      for (int i = 0; i < event.docChanges.length; i++) {
        final userJson = event.docChanges[i].doc.data() as Map<String, dynamic>;
        if (userJson.containsKey('isOnline') && userJson['isOnline'] != null && userJson['isOnline'] == true) {
          final userModels = UserModels.fromJson(userJson);
          final searchIndex = onlineUserModels.indexWhere((element) => element.id == userModels.id);
          if (searchIndex == -1) {
            if (event.docChanges[i].type == DocumentChangeType.added) {
              
              if (onlineUserModels.isNotEmpty) {
                onlineUserModels.insert(onlineUserModels.length - 1, userModels);
              } else {
                onlineUserModels.add(userModels);
              }

            } else if (event.docChanges[i].type == DocumentChangeType.removed) {
              onlineUserModels.removeAt(searchIndex);
            }
          }
        }
      }
      notifyListeners();
    });
  }

  void openPreviousConversation(BuildContext context, String mobile) {
    final dashboardTabModel = Provider.of<DashboardTabModel>(context, listen: false);
    dashboardTabModel.searchController.clear();
    dashboardTabModel.searchController.text = mobile;
    dashboardTabModel.loggedInUserModels = userModels;
    dashboardTabModel.conversationChatList.clear();
    dashboardTabModel.searchScheduleReservationByMobile(context);
  }

  Future<void> _getUserByUserId(BuildContext context) async {
    try {
      final fetchResult = await getRequest('user/userById', context: context);
      if (fetchResult != null) {
        userModels = UserModels.fromJson(fetchResult);
      }
    } catch (e) {
      AppLog.e(e, 'StatisticsViewModel', message: "$e");
    }
  }

  Future<void> onSendGroupMessage(BuildContext context) async {
    String? message = messageController.text.trim();

    if (message.isEmpty) return;

    try {

      final bodyParams = { 'message': message };

      final result = await postRequest('conversation/group-chat/sendMessage', body: bodyParams, context: context);
      messageController.clear();
      AppLog.d('StatisticsViewModel', message: '$result', methodName: 'onSendGroupMessage');
    } catch (e) {
      AppLog.e(e, 'StatisticsViewModel', message: "$e", methodName: 'onSendGroupMessage');
    } finally {
      notifyListeners();
    }
  }

  void _sortConversationChat() {
    groupChatModelData.sort((a, b) {
      return b.dateCreated!.compareTo(a.dateCreated!);
    });
  }
}