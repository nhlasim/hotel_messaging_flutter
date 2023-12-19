import 'package:hote_management/models/user_models.dart';

import '../log/app_log.dart';

class GroupChatModels {
  final String id;
  final String message;
  final DateTime? dateCreated;
  final UserModels userModels;

  GroupChatModels({required this.userModels, required this.id, required this.message, required this.dateCreated});

  factory GroupChatModels.fromJson(Map<String, dynamic> data) {
    DateTime? tempCreatedAt;
    if (data.containsKey('created_at') && data['created_at'] != null) {
      try {
        tempCreatedAt = DateTime.parse(data['created_at']);
      } catch (e) {
        AppLog.e(e, 'GroupChatModels', message: e.toString());
      }
    }
    return GroupChatModels(
      userModels: UserModels.fromJson(data['user']),
      id: data['id'],
      message: data['message'],
      dateCreated: tempCreatedAt
    );
  }
}