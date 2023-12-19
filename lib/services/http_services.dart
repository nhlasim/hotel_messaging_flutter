// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import '../components/AlertDialog/error_message_dialog.dart';
import 'package:hote_management/log/app_log.dart';
import 'storage_services.dart';
import '../config/constants.dart';

import 'package:http/http.dart' as http;

Uri url(String endPoint) {
  return Uri.parse('$baseUrl/api/$endPoint');
}

Future<Map<String, String>> appHeaders() async {
  Map<String, String> headers = {
    HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/json",
  };
  final userModel = await StorageServices.user;
  if (userModel != null && userModel.accessToken != null) {
    headers = {
      ...headers,
      'authorization': userModel.accessToken!
    };
  }
  return headers;
}

Future postRequest(String endPoint, {required Map<String, dynamic> body, BuildContext? context}) async {

  final headers = await appHeaders();
  AppLog.d('HttpService: ', message: 'body: $body, headers: $headers');
  final responseData = await http.post(url(endPoint), body: json.encode(body), headers: headers);
  AppLog.d('HttpService: ', message: 'Status Code: ${responseData.statusCode}, Response: ${responseData.body}');
  return _responseBody(responseData, context: context);
}

Future putRequest(String endPoint, {BuildContext? context, Map<String, dynamic>? body}) async {

  final headers = await appHeaders();

  AppLog.d('HttpService: ', message: 'headers: $headers');
  AppLog.d('HttpService', message: url(endPoint).queryParameters.toString());

  final responseData = await http.put(url(endPoint), headers: headers, body: body != null ? json.encode(body) : null);
  AppLog.d('HttpService: ', message: 'Status Code: ${responseData.statusCode}, Response: ${responseData.body}');
  return _responseBody(responseData, context: context);
}

Future deleteRequest(String endPoint, {BuildContext? context}) async {

  final headers = await appHeaders();

  AppLog.d('HttpService: ', message: 'headers: $headers');
  AppLog.d('HttpService', message: url(endPoint).queryParameters.toString());

  final responseData = await http.delete(url(endPoint), headers: headers);
  AppLog.d('HttpService: ', message: 'Status Code: ${responseData.statusCode}, Response: ${responseData.body}');
  return _responseBody(responseData, context: context);
}

Future getRequest(String endPoint, {BuildContext? context}) async {

  final headers = await appHeaders();
  AppLog.d('HttpService: ', message: 'headers: $headers');

  final responseData = await http.get(url(endPoint), headers: headers);
  AppLog.d('HttpService: ', message: 'Status Code: ${responseData.statusCode}, Response: ${responseData.body}');
  return _responseBody(responseData, context: context);
}

dynamic _responseBody(http.Response response, {BuildContext? context}) {
  final responseResult = json.decode(response.body);
  switch (response.statusCode) {
    case 200:
    case 201: {
      return responseResult;
    }
    case 400: {

      if (context != null) {
        showDialog(
          context: context,
          builder: (context) {
            return ErrorMsgDialog(errorMsg: responseResult['error']);
          }
        );
      }
      return null;
    }

    case 401: {
      if (context != null) {
        showDialog(
            context: context,
            builder: (context) {
              return ErrorMsgDialog(errorMsg: responseResult['error']);
            }
        );
      }
      return null;
    }

    case 403: {
      if (context != null) {
        showDialog(
            context: context,
            builder: (context) {
              return ErrorMsgDialog(errorMsg: responseResult['error']);
            }
        );
      }
      return null;
    }

    case 404: {
      if (context != null) {
        showDialog(
            context: context,
            builder: (context) {
              return ErrorMsgDialog(errorMsg: responseResult['error']);
            }
        );
      }
      return null;
    }
    default:
      throw Exception("Unable to parse response.");
  }
}