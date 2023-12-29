// create a APIs class and do all server request there
// and call the APIs class function from anywhere in the app
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constants/messages.dart';
import '../functions/alert.dart';

class APIs {
  static late Map<String, dynamic> jsonResponse;
  static late String diseaseDataJson;
  static String baseURL = 'https://agritech-server-i3xa.onrender.com';

  static dynamic imageDetection(
      File imageFile, String cropName, BuildContext context, popFreq) async {
    if (kDebugMode) {
      print('APIs.imageDetection called...');
    }
    try {
      var request = cropName != ''
          ? http.MultipartRequest(
              'POST',
              Uri.parse(
                  '$baseURL/disease-detection/$cropName') // add your server ip here
              )
          : http.MultipartRequest(
              'POST', Uri.parse('$baseURL/type-detection/soil'));
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));
      var res = await request.send();
      var response = await http.Response.fromStream(res);
      jsonResponse = jsonDecode(response.body);
      if (kDebugMode) {
        print(jsonResponse);
      }
      return jsonResponse['predicted_label'].toString().toLowerCase();
    } catch (err) {
      if (kDebugMode) {
        print('error in APIs.imageDetection: ${err.toString()}');
      }
      String errorType =
          err.toString().replaceAll('Exception', '}').split('}')[0];

      if (errorType == 'Handshake') {
        alert(
            context,
            popupMessages[Get.locale.toString()]!['network']!['title']!,
            popupMessages[Get.locale.toString()]!['network']!['message']!,
            'error',
            popFreq: popFreq);
      } else {
        alert(
            context,
            popupMessages[Get.locale.toString()]!['unknown']!['title']!,
            popupMessages[Get.locale.toString()]!['unknown']!['message']!,
            'error',
            popFreq: popFreq);
      }
    }
  }

  static dynamic getDiseaseData(
      String diseaseCode, String cropName, BuildContext context) async {
    if (kDebugMode) {
      print('APIs.getDiseaseData called...');
    }
    try {
      await FirebaseFirestore.instance
          .collection('${cropName}_diseases')
          .doc('${diseaseCode}_${Get.locale}.json')
          .get()
          .then((value) {
        diseaseDataJson = value.data()?['data'];
      });
      if (kDebugMode) {
        print(diseaseDataJson);
      }
      return diseaseDataJson;
    } catch (e) {
      alert(context, popupMessages[Get.locale.toString()]!['noData']!['title']!,
          popupMessages[Get.locale.toString()]!['noData']!['message']!, 'error',
          popFreq: 2);
    }
  }
}
