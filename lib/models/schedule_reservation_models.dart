import 'package:hote_management/log/app_log.dart';
import 'package:hote_management/models/user_models.dart';

class ErrorClass {
  final Map<String, dynamic>? error;

  ErrorClass({this.error});

  factory ErrorClass.fromJson(Map<String, dynamic> data) {
    return ErrorClass(
      error: data['error']
    );
  }
}

class CreateConversation {
  final String chatServiceSid;
  final DateTime dateCreated;
  final DateTime dateUpdated;
  final String friendlyName;
  final Map<String, dynamic> links;
  final String messagingServiceSid;
  final String sid;
  final String uniqueName;
  final String url;
  final ErrorClass? errorClass;

  CreateConversation({
    this.errorClass,
    required this.chatServiceSid,
    required this.messagingServiceSid,
    required this.dateCreated,
    required this.url,
    required this.links,
    required this.dateUpdated,
    required this.sid,
    required this.friendlyName,
    required this.uniqueName
  });

  factory CreateConversation.fromJson(Map<String, dynamic> data) {
    final createJson = data['data'];

    DateTime tempDateCreatedAt = DateTime.now();
    if (createJson.containsKey('date_created') && createJson['date_created'] != null) {
      try {
        tempDateCreatedAt = DateTime.parse(createJson['date_created']);
      } catch (e) {
        tempDateCreatedAt = DateTime.now();
        AppLog.e(e, 'CreateConversation', message: e.toString());
      }
    }

    DateTime tempDateUpdated = DateTime.now();
    if (createJson.containsKey('date_updated') && createJson['date_updated'] != null) {
      try {
        tempDateUpdated = DateTime.parse(createJson['date_updated']);
      } catch (e) {
        tempDateUpdated = DateTime.now();
        AppLog.e(e, 'CreateConversation', message: e.toString());
      }
    }

    return CreateConversation(
      chatServiceSid: createJson['chat_service_sid'],
      messagingServiceSid: createJson['messaging_service_sid'],
      dateCreated: tempDateCreatedAt,
      url: createJson['url'],
      links: createJson['links'],
      dateUpdated: tempDateUpdated,
      sid: createJson['sid'],
      friendlyName: createJson['friendly_name'],
      uniqueName: createJson['unique_name'],
      errorClass: data['error'] == null ? null : ErrorClass.fromJson(data)
    );
  }
}

class ScheduleReservationModels {
  final String assignedTo;
  final CreateConversation? createConversation;
  final String countryCode;
  final DateTime createdAt;
  final DateTime end;
  final String id;
  final String mobileNo;
  final String name;  
  final DateTime? roomAllocatedAt;
  final DateTime start;
  final String surname;
  final UserModels? assignedToUser;
  final String? messageVia;
  final String? roomNo;
  final bool isActiveConversation;

  ScheduleReservationModels({
    required this.id,
    required this.assignedToUser,
    required this.start,
    required this.countryCode,
    required this.name,
    required this.surname,
    required this.mobileNo,
    required this.assignedTo,
    required this.end,
    required this.createdAt,
    this.messageVia,
    this.roomAllocatedAt,
    this.roomNo,
    this.createConversation,
    required this.isActiveConversation
  });

  String get fullName {
    return '$name $surname';
  }

  Map<String, dynamic> toJson(String start, String end) {
    return {
      'name': name,
      'surname': surname,
      'countryCode': countryCode,
      'mobileNo': mobileNo,
      'start': start,
      'end': end,
      'assignedTo': assignedTo
    };
  }

  factory ScheduleReservationModels.fromJson(Map<String, dynamic> data) {
    DateTime tempStart = DateTime.now();
    if (data.containsKey('start') && data['start'] != null) {
      try {
        tempStart = DateTime.parse(data['start']);
      } catch (e) {
        tempStart = DateTime.now();
        AppLog.e(e, 'ScheduleReservationModel (start)', message: e.toString());
      }
    }

    DateTime tempEnd = DateTime.now();
    if (data.containsKey('end') && data['end'] != null) {
      try {
        tempEnd = DateTime.parse(data['end']);
      } catch (e) {
        tempEnd = DateTime.now();
        AppLog.e(e, 'ScheduleReservationModel (end)', message: e.toString());
      }
    }

    DateTime tempCreatedAt = DateTime.now();
    if (data.containsKey('created_at') && data['created_at'] != null) {
      try {
        tempCreatedAt = DateTime.parse(data['created_at']);
      } catch (e) {
        tempCreatedAt = DateTime.now();
        AppLog.e(e, 'Schedule Reservation Model', message: e.toString());
      }
    }

    DateTime? tempRoomAllocatedAt;
    if (data.containsKey('room_allocated_at') && data['room_allocated_at'] != null) {
      try {
        tempRoomAllocatedAt = DateTime.parse(data['room_allocated_at']);
      } catch (e) {
        AppLog.e(e, 'ScheduleReservationModel', message: e.toString());
      }
    }
    
    return ScheduleReservationModels(
      id: data['id'],
      assignedToUser: UserModels.fromJson(Map.from(data['assignedToUser'])),
      start: tempStart,
      countryCode: data['countryCode'],
      name: data['name'],
      surname: data['surname'],
      mobileNo: data['mobileNo'],
      assignedTo: data['assignedTo'],
      end: tempEnd,
      createdAt: tempCreatedAt,
      messageVia: data['messageVia'],
      roomNo: data['roomNo'],
      createConversation: data['conversation'] == null
      ? null
      : CreateConversation.fromJson(data['conversation']),
      roomAllocatedAt: tempRoomAllocatedAt,
      isActiveConversation: data['isActiveConversation']
    );
  }
}