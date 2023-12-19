import 'package:hote_management/enum/conversation_source.dart';
import 'package:hote_management/models/user_models.dart';

class ChatModels {

  final SenderMessageInstance? senderMessageInstance;
  final ReceiverMessageInstance? receiverMessageInstance;

  ChatModels({ this.senderMessageInstance, this.receiverMessageInstance});

  factory ChatModels.fromJson(Map<String, dynamic> data) {
    return ChatModels(
      receiverMessageInstance: data.containsKey('eventType') ? ReceiverMessageInstance.fromJson(data) : null,
      senderMessageInstance: data['eventType'] != null && data.containsKey('eventType')
      ? null
      : SenderMessageInstance.fromJson(data)
    );
  }
}

class SenderMessageInstance {
  
  final String sender;
  final String receiver;
  final String body;
  final String conversationSid;
  final DateTime dateCreated;
  final DateTime dateUpdated;
  final String? participantSid;
  final String url;
  final DateTime serverDateCreatedAt;
  final UserModels? senderUser;

  final String source;
  final String? robotStaticMenu;

  SenderMessageInstance({
    this.participantSid,
    required this.dateUpdated,
    required this.dateCreated,
    required this.conversationSid,
    required this.body,
    required this.url,
    required this.source,
    this.robotStaticMenu,
    this.senderUser,
    required this.serverDateCreatedAt,
    required this.receiver,
    required this.sender
  });

  factory SenderMessageInstance.fromJson(Map<String, dynamic> data) {
    String tempSender = '', tempSource = '';
    if (data.containsKey('sender')) {
      tempSender = data['sender'];
      if ((data['sender'] as String).startsWith('whatsapp')) {
        tempSource = ConversationSource.Whatsapp.name;
        final splitAuthorName = tempSender.split(":");
        tempSender = splitAuthorName[splitAuthorName.length - 1];
      } else {
        tempSource = ConversationSource.SMS.name;
      }
    }

    DateTime tempDateCreatedAt = DateTime.now();
    if (data.containsKey('date_created') && data['date_created'] != null) {
      try {
        tempDateCreatedAt = DateTime.parse(data['date_created']);
      } catch (e) {
        tempDateCreatedAt = DateTime.now();
      }
    }

    DateTime tempServerDateCreatedAt = DateTime.now();
    if (data.containsKey('serverDateCreatedAt') && data['serverDateCreatedAt'] != null) {
      try {
        tempServerDateCreatedAt = DateTime.parse(data['serverDateCreatedAt']);
      } catch (e) {
        tempServerDateCreatedAt = DateTime.now();
      }
    }

    DateTime tempDateUpdated = DateTime.now();
    if (data.containsKey('date_updated') && data['date_updated'] != null) {
      try {
        tempDateUpdated = DateTime.parse(data['date_updated']);
      } catch (e) {
        tempDateUpdated = DateTime.now();
      }
    }

    String body = data['body'];
    return SenderMessageInstance(
      sender: tempSender,
      receiver: data['receiver'],
      serverDateCreatedAt: tempServerDateCreatedAt,
      conversationSid: data['conversation_sid'],
      body: body,
      url: data['url'],
      dateUpdated: tempDateUpdated,
      dateCreated: tempDateCreatedAt,
      senderUser: data.containsKey('senderUser') && data['senderUser'] != null 
      ? UserModels.fromJson(data['senderUser']) 
      : null,
      source: tempSource,
      participantSid: data['participant_sid'],
      robotStaticMenu: body == 'robot menu'
      ? 'https://hotel-management-nodejs.vercel.app/hotel_menu/Restaurentmenu.pdf'
      : null
    );
  }
}

class ReceiverMessageInstance {
  final String sender;
  final String receiver;
  final String body;
  final String conversationSid;
  final DateTime dateCreated;
  final String eventType;
  final String participantSid;
  final String source;
  final DateTime serverDateCreatedAt;

  ReceiverMessageInstance({
    required this.source,
    required this.body,
    required this.conversationSid,
    required this.dateCreated,
    required this.participantSid,
    required this.eventType,
    required this.serverDateCreatedAt,
    required this.sender,
    required this.receiver
  });

  factory ReceiverMessageInstance.fromJson(Map<String, dynamic> data) {

    DateTime tempDateCreatedAt = DateTime.now();
    if (data.containsKey('dateCreated') && data['dateCreated'] != null) {
      try {
        tempDateCreatedAt = DateTime.parse(data['dateCreated']);
      } catch (e) {
        tempDateCreatedAt = DateTime.now();
      }
    }

    DateTime tempServerDateCreatedAt = DateTime.now();
    if (data.containsKey('serverDateCreatedAt') && data['serverDateCreatedAt'] != null) {
      try {
        tempServerDateCreatedAt = DateTime.parse(data['serverDateCreatedAt']);
      } catch (e) {
        tempServerDateCreatedAt = DateTime.now();
      }
    }

    return ReceiverMessageInstance(
        body: data['body'],
        conversationSid: data['conversationSid'],
        dateCreated: tempDateCreatedAt,
        eventType: data['eventType'],
        participantSid: data['participantSid'],
        receiver: data['receiver'],
        sender: data['sender'],
        serverDateCreatedAt: tempServerDateCreatedAt,
        source: data['source'],
    );
  }
}