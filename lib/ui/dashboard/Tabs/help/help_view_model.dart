// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:hote_management/models/help_models.dart';
import 'package:http/http.dart' as http;


import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hote_management/config/app_toast.dart';
import 'package:hote_management/log/app_log.dart';

import '../../../../services/http_services.dart';

class HelpViewModel extends ChangeNotifier {

  final searchController = TextEditingController();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();


  PlatformFile? attachmentFile;

  bool showCreateHelpItem = false;
  bool useLoader = false;

  void onFindPressed() {
    showCreateHelpItem = false;
    notifyListeners();
  }

  void onShowAllPressed() {
    showCreateHelpItem = false;
    notifyListeners();
  }

  void onCreateHelpItem() {
    showCreateHelpItem = true;
    notifyListeners();
  }

  Future<void> pickFiles() async {
    final pickFileResults = await FilePicker.platform.pickFiles(allowCompression: true, type: FileType.custom, withReadStream: true, allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'pdf', 'webp'], allowMultiple: false);
    if (pickFileResults != null) {
      attachmentFile = pickFileResults.files.first;
      notifyListeners();
    }
  }

  List<HelpModels>? originalHelpModel;
  List<HelpModels>? searchHelpModels;

  Future<void> showAllHelp(BuildContext context) async {
    useLoader = true;
    notifyListeners();

    try {
      final fetchResult = await getRequest('help/show-all', context: context);
      if (fetchResult != null) {
        originalHelpModel = (fetchResult as List<dynamic>).map((e) => HelpModels.fromJson(e)).toList();
        searchHelpModels = originalHelpModel;
      }
    } catch (e) {
      AppLog.e('exception: $e', 'HelpViewModel', message: e.toString(), methodName: 'showAllHelp');
    } finally {
      useLoader = false;
      notifyListeners();
    }
  }

  void onSearchHelp(String value) {
    if (value.trim().isEmpty) {
      searchHelpModels = originalHelpModel;
    } else {
      searchHelpModels = originalHelpModel!.where((element) {
        return element.title.toLowerCase().contains(value.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<void> createHelp(BuildContext context) async {

    String title = titleController.text.trim();
    String description = descriptionController.text.trim();

    if (title.isEmpty) {
      AppToast.showToastMsg('Title should not be empty.');
      return;
    }

    if (description.isEmpty) {
      AppToast.showToastMsg('Description should not be empty.');
      return;
    }

    try {
      useLoader = true;
      notifyListeners();

      var request = http.MultipartRequest('POST', url('help/create-help'));

      if (attachmentFile != null) {
        final uploadFile = http.MultipartFile('file', attachmentFile!.readStream!, attachmentFile!.size, filename: attachmentFile!.name);
        request.files.add(uploadFile);
      }

      request.fields.addEntries({'title': title}.entries);
      request.fields.addEntries({'description': description}.entries);

      AppLog.d('HelpViewModel', message: 'request field: ${request.fields}');
      Map<String, String> headers = await appHeaders();

      request.headers.addEntries(headers.entries);
      request.headers.addEntries({HttpHeaders.contentTypeHeader: 'multipart/form-data'}.entries);
      AppLog.d('HelpViewModel', message: 'headers: ${request.headers}');

      var streamedResponse = await request.send();
      AppLog.d('Help View Model', message: 'Response (Creating Help): ${streamedResponse.statusCode}');
      if (streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201) {
        titleController.clear();
        descriptionController.clear();
        attachmentFile = null;
        showCreateHelpItem = false;
        String result = await streamedResponse.stream.bytesToString();
        AppLog.d('Help View Model', message: 'Response (Creating Help): $result');
        AppToast.showToastMsg('Help created successfully.');
        showAllHelp(context);
      }

    } catch (e) {
      AppLog.d('Help View Model', message: 'exception while creating help: $e');
    } finally {
      useLoader = false;
      notifyListeners();
    }
  }
}