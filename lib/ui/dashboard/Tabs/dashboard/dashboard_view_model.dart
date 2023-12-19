
// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hote_management/enum/conversation_source.dart';
import 'package:hote_management/models/chat_models.dart';
import 'package:hote_management/models/quick_reply_models.dart';
import 'package:hote_management/models/schedule_reservation_models.dart';
import 'package:intl/intl.dart';

import '../../../../config/app_toast.dart';
import '../../../../enum/user_roles.dart';
import '../../../../log/app_log.dart';
import '../../../../models/user_models.dart';
import '../../../../services/http_services.dart';


class DashboardTabModel extends ChangeNotifier {

  UserModels? loggedInUserModels;
  DashboardTabModel(UserModels? userModels) {
    loggedInUserModels = userModels;
  }

  final titles = ['Mr', 'Mrs', 'Miss', 'Ms', 'Dr', 'Prof', 'Sir', 'Madam'];
  String selectedTitles = 'Mr';
  void onTitleChange(String value) {
    selectedTitles = value;
    notifyListeners();
  }

  final countryCode = ['+27', '+91'];
  String selectedCountryCode = '+27';
  void onCountryCodeChange(String value) {
    selectedCountryCode = value;
    notifyListeners();
  }

  final messageStats = ['Active', 'Scheduled'];
  String selectedMessageStats = 'Active';
  void onMessageStatsChange(String value, BuildContext context) {
    selectedMessageStats = value;
    createScheduleConversation = false;
    selectedTitles = titles.first;
    selectedCountryCode = countryCode.first;
    searchController.clear();

    notifyListeners();
    if (selectedMessageStats == 'Scheduled') {
      showAllScheduleReservation();
    }

    if (selectedMessageStats != 'Active') {
      _resetActiveTabValues();
    }
  }

  final ddMMyyyyFormat = DateFormat("dd/MM/yyyy");

  bool useLoader = false;

  /// START ACTIVE

  final GlobalKey globalKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  final searchController = TextEditingController();
  final guestNameController = TextEditingController();
  final guestMobileNoController = TextEditingController();
  final reservationFromController = TextEditingController();
  final reservationToController = TextEditingController();
  final roomNoController = TextEditingController();

  final messageController = TextEditingController();

  List<ChatModels> conversationChatList = [];

  List<QuickReplyModels> quickReplyList = [];

  List<UserModels> managerWiseStaffDetails = [];

  final menusBesideConversation = ['Quick Reply', 'Follow up', 'Handoff', 'Note', 'Archive'];

  final messageViaList = [ConversationSource.SMS.name, ConversationSource.Whatsapp.name];

  ScheduleReservationModels? selectedScheduleReservationFromActive;

  bool shouldStartConversation = false;

  String selectedMessageVia = "Whatsapp";

  void resetActiveTabValues() => _resetActiveTabValues();

  void _resetActiveTabValues() {
    searchController.clear();
    guestNameController.clear();
    guestMobileNoController.clear();
    reservationFromController.clear();
    reservationToController.clear();
    roomNoController.clear();
    messageController.clear();

    conversationChatList = [];
    quickReplyList = [];
    managerWiseStaffDetails = [];
    selectedScheduleReservationFromActive = null;
    shouldStartConversation = false;
  }

  Future<void> onArchiveScheduleReservation(BuildContext context) async {

    if (selectedScheduleReservationFromActive == null) return;
    
    try {
      useLoader = true;
      notifyListeners();
      final fetchResult = await deleteRequest('conversation/archive/${selectedScheduleReservationFromActive!.id}', context: context);
      if (fetchResult != null) {
        AppToast.showToastMsg('Conversation Archive successfully.', bgColor: Colors.green.shade600);
        _resetActiveTabValues();
      }

    } catch (e) {
      AppLog.e(e, 'User View Model', message: e.toString());
    } finally {
      useLoader = false;
      notifyListeners();
    }
  }
  
  Future<void> fetchQuickReply(BuildContext context) async {
    try {
      final fetchResult = await getRequest('conversation/getQuickReply', context: context);
      if (fetchResult != null) {
        List<dynamic> responseData = fetchResult[0]['data'];
        quickReplyList = responseData.map((e) => QuickReplyModels.fromJson(e)).toList();
      }
    } catch (e) {
      AppLog.e(e, 'DashboardViewModel', message: "(fetchQuickReply): $e");
    }
  }

  Future<void> fetchManagerWiseStaffDetails(BuildContext context) async {
    try {
      final fetchResult = await getRequest('user/manager-wise-staff-details/${loggedInUserModels!.id}', context: context);
      if (fetchResult != null) {
        List<dynamic> responseData = fetchResult;
        managerWiseStaffDetails = responseData.map((e) => UserModels.fromJson(e)).toList();
        managerWiseStaffDetails = managerWiseStaffDetails.where((element) {
          return selectedScheduleReservationFromActive != null && selectedScheduleReservationFromActive!.assignedTo != element.id;
        }).toList();
      }
    } catch (e) {
      AppLog.e(e, 'DashboardViewModel', message: "(fetchManagerWiseStaffDetails) $e");
    }
  }

  Future<void> onMessageSend(BuildContext context) async {
    String message = messageController.text.trim();
    String messageVia = selectedScheduleReservationFromActive!.messageVia!.toLowerCase();

    if (message.isEmpty) return;

    try {

      final bodyParams = {
        'message': message,
        'messageVia': messageVia,
        'conversationSid': selectedScheduleReservationFromActive!.createConversation!.sid,
      };

      final result = await postRequest('conversation/on-message-send', body: bodyParams, context: context);
      if (result != null) {
        messageController.clear();
        _sortConversationChat();
      }

    } catch (e) {
      AppLog.e(e, 'User View Model', message: e.toString());
    } finally {
      notifyListeners();
    }
  }

  void _addDefaultValueToStartConversation() {
    selectedTitles = selectedScheduleReservationFromActive!.name.split(" ")[0];
    guestNameController.text = '${selectedScheduleReservationFromActive!.name.substring(selectedTitles.length, selectedScheduleReservationFromActive!.name.length)} ${selectedScheduleReservationFromActive!.surname}';
    int findCountryCode = countryCode.indexOf(selectedScheduleReservationFromActive!.countryCode);
    if (findCountryCode != -1) {
      selectedCountryCode = countryCode[findCountryCode];
    }
    guestMobileNoController.text = selectedScheduleReservationFromActive!.mobileNo;
    reservationFromController.text = ddMMyyyyFormat.format(selectedScheduleReservationFromActive!.start);
    start = selectedScheduleReservationFromActive!.start;
    reservationToController.text = ddMMyyyyFormat.format(selectedScheduleReservationFromActive!.end);
    end = selectedScheduleReservationFromActive!.end;
    if (selectedScheduleReservationFromActive!.roomNo != null) {
      roomNoController.text = selectedScheduleReservationFromActive!.roomNo!;
    }
    if (selectedScheduleReservationFromActive!.messageVia != null) {
      selectedMessageVia = selectedScheduleReservationFromActive!.messageVia!;
    }
  }
  
  Future<void> searchScheduleReservationByMobile(BuildContext context, {bool? openStartConversation}) async {
    if (searchController.text.trim().isEmpty) {
      AppToast.showToastMsg('Name or mobile number should not be empty.');
      return;
    }

    if (openStartConversation != null) {
      shouldStartConversation = openStartConversation;
    }

    useLoader = true;
    notifyListeners();
    try {
      final fetchResult = await getRequest('scheduled-reservations/search?filter=${searchController.text.trim()}', context: context);
      if (fetchResult != null) {
        List<dynamic> data = fetchResult;
        if (data.isEmpty) {
          AppToast.showToastMsg('Mobile number not found.');
        } else {

          List<ScheduleReservationModels> temporaryScheduleReservationModel = data.map((e) => ScheduleReservationModels.fromJson(e)).toList();
          int index = temporaryScheduleReservationModel.indexWhere((element) => element.isActiveConversation == true && element.createConversation != null);
          int secondaryIndex = temporaryScheduleReservationModel.indexWhere((element) => element.isActiveConversation == true);
          if (index != -1) {
            selectedScheduleReservationFromActive = temporaryScheduleReservationModel[index];
          } else if (secondaryIndex != -1) {
            selectedScheduleReservationFromActive = temporaryScheduleReservationModel[secondaryIndex];
          } else {
            selectedScheduleReservationFromActive = null;
          }

          if (selectedScheduleReservationFromActive != null) {

            if (shouldStartConversation) {
              _addDefaultValueToStartConversation();
            } else {

              bool isSatisfied = selectedScheduleReservationFromActive!.roomNo == null
                && selectedScheduleReservationFromActive!.roomAllocatedAt == null
                && selectedScheduleReservationFromActive!.messageVia == null;

              shouldStartConversation = false;

              if (isSatisfied) {

                _addDefaultValueToStartConversation();
                changeStartConversation();

              } else {

                if (selectedScheduleReservationFromActive!.createConversation != null) {

                  fetchQuickReply(context);

                  if (loggedInUserModels!.roles.userRoles == UserRoles.manager) {
                    fetchManagerWiseStaffDetails(context);
                  }

                  String messageViaWithMobileNo = '${selectedScheduleReservationFromActive!.countryCode}${selectedScheduleReservationFromActive!.mobileNo}';
                  if (selectedScheduleReservationFromActive!.messageVia != null && selectedScheduleReservationFromActive!.messageVia!.toLowerCase() == ConversationSource.Whatsapp.name.toLowerCase()) {
                    messageViaWithMobileNo = 'whatsapp:$messageViaWithMobileNo';
                  }
                  await _firebaseConversationIdWiseChat(messageViaWithMobileNo);
                }

              }
            }

          } else {
            AppToast.showToastMsg('No active reservation found with the same mobile number.');
          }
        }
      }
    } catch (e) {
      AppLog.e(e, 'DashboardTabModel', message: "$e");
    } finally {
      useLoader = false;
      notifyListeners();
    }
  }

  Future<void> updateScheduleReservation(BuildContext context) async {
    String roomNo = roomNoController.text.trim();
    if (roomNo.isEmpty) {
      AppToast.showToastMsg('Room no should not be empty.');
      return;
    }

    String name = selectedScheduleReservationFromActive!.name.substring(selectedTitles.length, selectedScheduleReservationFromActive!.name.length);
    String surname = selectedScheduleReservationFromActive!.surname.trim();
    String mobileNo = selectedScheduleReservationFromActive!.mobileNo.trim();

    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    final bodyParams = {
      'name': '${selectedTitles.trim()} ${name.trim()}',
      'surname': surname,
      'countryCode': selectedCountryCode,
      'mobileNo': mobileNo,
      'start': dateFormat.format(start!),
      'end': dateFormat.format(end!),
      'assignedTo': selectedScheduleReservationFromActive!.assignedTo,
      'roomNo': roomNo,
      'messageVia': selectedMessageVia,
      'id': selectedScheduleReservationFromActive!.id
    };

    AppLog.d('Dashboard Tab Model', message: bodyParams.toString());

    useLoader = true;
    notifyListeners();

    try {
      final result = await putRequest('scheduled-reservations/update/${selectedScheduleReservationFromActive!.id}', body: bodyParams, context: context);
      if (result != null) {
        AppToast.showToastMsg('Scheduled Reservation has been updated successfully.', bgColor: Colors.green.shade600);
        selectedScheduleReservationFromActive = null;
        selectedMessageVia = messageViaList.last;
        shouldStartConversation = false;
        searchController.clear();
        roomNoController.clear();
      }
    } catch (e) {
      AppLog.e(e, 'User View Model', message: e.toString());
    } finally {
      useLoader = false;
      notifyListeners();
    }
  }

  Future<void> onScheduleReservationHandoff(BuildContext context, String userId) async {
    try {

      final bodyParams = {
        'reservationId ': selectedScheduleReservationFromActive!.id,
        'userId': userId,
      };

      AppLog.d('Dashboard Tab Model', message: bodyParams.toString());

      useLoader = true;
      notifyListeners();

      final result = await putRequest('scheduled-reservations/handoff/${selectedScheduleReservationFromActive!.id}', body: bodyParams, context: context);
      if (result != null) {
        selectedScheduleReservationFromActive = ScheduleReservationModels.fromJson(result);
        AppToast.showToastMsg('Handoff has been completed.', bgColor: Colors.green.shade600);
        await fetchManagerWiseStaffDetails(context);
      }

    } catch (e) {
      AppLog.e(e, 'Dashboard Tab Model', message: e.toString());
    } finally {
      useLoader = false;
      notifyListeners();
    }
  }

  void changeStartConversation() {
    shouldStartConversation = !shouldStartConversation;
    if (!shouldStartConversation) {
      _resetActiveTabValues();
    }
    notifyListeners();
  }

  void onSendMessageVia(String value) {
    selectedMessageVia = value;
    notifyListeners();
  }
  
  Future<void> _firebaseConversationIdWiseChat(String docId) async {

    CollectionReference chatCollection = FirebaseFirestore.instance.collection('chat');
    chatCollection.where('sender', isEqualTo: docId).where('receiver', isEqualTo: docId);
    chatCollection.snapshots().listen((event) {
      try {

        for (int i = 0; i < event.docs.length; i++) {
          AppLog.d('DashboardViewModel', message: 'event.docs: ${event.docs[i].data()}');
        }

        for (int i = 0; i < event.docChanges.length; i++) {
          AppLog.d('DashboardViewModel', message: 'event.docChanges: ${event.docChanges[i].doc.data()}');
          final chatModels = ChatModels.fromJson(event.docChanges[i].doc.data() as Map<String, dynamic>);

          conversationChatList.removeWhere((element) {
            if (element.receiverMessageInstance != null && chatModels.receiverMessageInstance != null) {
              return element.receiverMessageInstance!.dateCreated == chatModels.receiverMessageInstance!.dateCreated;
            } else if (element.senderMessageInstance != null && chatModels.senderMessageInstance != null) {
              return element.senderMessageInstance!.dateCreated == chatModels.senderMessageInstance!.dateCreated;
            }
            return false;
          });

          int index = conversationChatList.indexOf(chatModels);
          if (index == -1) {
            if (event.docChanges[i].type == DocumentChangeType.added) {
              if (chatModels.senderMessageInstance != null && chatModels.senderMessageInstance!.receiver == docId) {
                conversationChatList.add(chatModels);
              } else if (chatModels.receiverMessageInstance != null && chatModels.receiverMessageInstance!.sender == docId) {
                conversationChatList.add(chatModels);
              }
            }
          }
        }
        _sortConversationChat();
        notifyListeners();
      } catch (e) {
        AppLog.e(e, 'DashboardTabModel', message: '_firebaseConversationIdWiseChat: $e');
      }
    });
  }

  void _sortConversationChat() {
    conversationChatList.sort((a, b) {
      DateTime tempDateA = a.senderMessageInstance == null ? a.receiverMessageInstance!.dateCreated : a.senderMessageInstance!.dateCreated;
      DateTime tempDateB = b.senderMessageInstance == null ? b.receiverMessageInstance!.dateCreated : b.senderMessageInstance!.dateCreated;
      return tempDateB.compareTo(tempDateA);
    });
  }

  /// END ACTIVE


  /// START SCHEDULE RESERVATIONS

  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final mobileNoController = TextEditingController();
  final startController = TextEditingController();
  final endController = TextEditingController();

  DateTime? start, end;

  List<ScheduleReservationModels>? scheduleReservationList;
  List<ScheduleReservationModels>? searchScheduleReservationList;
  ScheduleReservationModels? editScheduleReservation;

  List<UserModels>? staffDetails;
  UserModels? selectedStaffDetails;

  bool createScheduleConversation = false;
  
  Future<void> showAllScheduleReservation() async {
    if (createScheduleConversation) {
      createScheduleConversation = !createScheduleConversation;
    }
    useLoader = true;
    notifyListeners();
    try {

      final fetchResult = await getRequest('scheduled-reservations/show-all');
      if (fetchResult != null) {
        scheduleReservationList = (fetchResult as List<dynamic>).map((e) => ScheduleReservationModels.fromJson(e)).toList();
        searchScheduleReservationList = scheduleReservationList;
      }

    } catch (e) {
      AppLog.e(e, 'Dashboard Tab Model', message: e.toString());
    } finally {
      useLoader = false;
      notifyListeners();
    }
  }
  
  Future<void> fetchScheduleReservationById(String id) async {
    useLoader = true;
    notifyListeners();
    try {
      final fetchResult = await getRequest('scheduled-reservations/byId?id=$id');
      if (fetchResult != null) {
        editScheduleReservation = ScheduleReservationModels.fromJson(fetchResult);
        if (editScheduleReservation != null) {
          selectedTitles = editScheduleReservation!.name.split(" ")[0];
          nameController.text = editScheduleReservation!.name.substring(selectedTitles.length, editScheduleReservation!.name.length);
          surnameController.text = editScheduleReservation!.surname;
          int findCountryCode = countryCode.indexOf(editScheduleReservation!.countryCode);
          if (findCountryCode != -1) {
            selectedCountryCode = countryCode[findCountryCode];
          }
          mobileNoController.text = editScheduleReservation!.mobileNo;
          startController.text = ddMMyyyyFormat.format(editScheduleReservation!.start);
          start = editScheduleReservation!.start;
          endController.text = ddMMyyyyFormat.format(editScheduleReservation!.end);
          end = editScheduleReservation!.end;
          if (staffDetails != null && staffDetails!.isNotEmpty) {
            final index = staffDetails!.indexWhere((element) => editScheduleReservation!.assignedTo == element.id);
            if (index != -1) {
              selectedStaffDetails = staffDetails![index];
            }
          }
        }
      }
    } catch (e) {
      AppLog.e(e, 'Dashboard Tab Model', message: e.toString());
    } finally {
      useLoader = false;
      notifyListeners();
    }
  }
  
  Future<void> onDeleteScheduleReservation(ScheduleReservationModels value, BuildContext context) async {
    try {
      useLoader = true;
      notifyListeners();
      final fetchResult = await deleteRequest('scheduled-reservations/delete/${value.id}', context: context);
      if (fetchResult != null) {
        AppToast.showToastMsg('Reservation deleted successfully.', bgColor: Colors.green.shade600);
        searchController.clear();
        if (searchScheduleReservationList != null) {
          searchScheduleReservationList!.remove(value);
        }
      }

    } catch (e) {
      AppLog.e(e, 'User View Model', message: e.toString());
    } finally {
      useLoader = false;
      notifyListeners();
    }
  }
  
  Future<void> changeCreateScheduleConversation() async {
    createScheduleConversation = !createScheduleConversation;
    _resetValueForScheduleReservation();
    notifyListeners();
    if (createScheduleConversation) {
      useLoader = true;
      notifyListeners();
      await onStaffDetailsFetch();
      useLoader = false;
      notifyListeners();
    }
  }
  
  Future<void> onStaffDetailsFetch() async {
    if (staffDetails == null) {
      final fetchResult = await getRequest('user/manager-details?role=${UserRoles.staff.name}');
      staffDetails = (fetchResult as List).map((e) => UserModels.fromJson(e)).toList();
      if (staffDetails != null && staffDetails!.isNotEmpty) {
        selectedStaffDetails = staffDetails!.first;
      }
    }
  }
  
  Future<void> onScheduleReservationSaveOrUpdate(BuildContext context) async {
    String name = nameController.text.trim();
    String surname = surnameController.text.trim();
    String mobileNo = mobileNoController.text.trim();
    String startDate = startController.text.trim();
    String endDate = endController.text.trim();

    if (name.isEmpty) {
      AppToast.showToastMsg('Name should not be empty.');
      return;
    }

    if (surname.isEmpty) {
      AppToast.showToastMsg('Surname should not be empty.');
      return;
    }

    if (mobileNo.isEmpty) {
      AppToast.showToastMsg('Mobile No should not be empty.');
      return;
    }

    if (startDate.isEmpty) {
      AppToast.showToastMsg('Start should not be empty.');
      return;
    }

    if (endDate.isEmpty) {
      AppToast.showToastMsg('End should not be empty.');
      return;
    }

    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    try {

      final bodyParams = {
        'name': '$selectedTitles $name',
        'surname': surname,
        'countryCode': selectedCountryCode,
        'mobileNo': mobileNo,
        'start': dateFormat.format(start!),
        'end': dateFormat.format(end!),
        'assignedTo': selectedStaffDetails!.id
      };

      if (editScheduleReservation != null) {
        bodyParams.addEntries({ 'id': editScheduleReservation!.id }.entries);
      }

      AppLog.d('Dashboard Tab Model', message: bodyParams.toString());

      useLoader = true;
      notifyListeners();

      if (editScheduleReservation != null) {
        final result = await putRequest('scheduled-reservations/update/${editScheduleReservation!.id}', body: bodyParams, context: context);
        if (result != null) {
          AppToast.showToastMsg('Scheduled Reservation has been updated successfully.', bgColor: Colors.green.shade600);
          editScheduleReservation = null;
        }
      } else {
        final result = await postRequest('scheduled-reservations/create', body: bodyParams, context: context);
        if (result != null) {
          AppToast.showToastMsg('Reservation has been scheduled successfully.', bgColor: Colors.green.shade600);
        }
      }

      _resetValueForScheduleReservation();
      changeCreateScheduleConversation();
      showAllScheduleReservation();

    } catch (e) {
      AppLog.e(e, 'User View Model', message: e.toString());
    } finally {
      useLoader = false;
      notifyListeners();
    }
  }
  
  Future<void> onEditScheduleReservation(String id, BuildContext context) async {
    await changeCreateScheduleConversation();
    fetchScheduleReservationById(id);
  }

  void searchScheduleReservationByMobileNo(String value) {
    if (value.trim().isEmpty) {
      searchScheduleReservationList = scheduleReservationList;
    } else {
      searchScheduleReservationList = scheduleReservationList!.where((element) {
        return element.mobileNo.trim().toLowerCase().contains(value.trim().toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void onSelectStaff(UserModels value) {
    selectedStaffDetails = value;
    notifyListeners();
  }

  void _resetValueForScheduleReservation() {
    nameController.clear();
    surnameController.clear();
    mobileNoController.clear();
    startController.clear();
    start = null;
    endController.clear();
    end = null;

    selectedTitles = titles.first;
    selectedCountryCode = countryCode.first;
    if (staffDetails != null && staffDetails!.isNotEmpty) {
      selectedStaffDetails = staffDetails!.first;
    }
  }

  /// END SCHEDULE RESERVATIONS

}