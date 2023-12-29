import 'dart:io';

import 'package:esp32sensor/utils/apis/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../constants/messages.dart';
import '../functions/alert.dart';

class SoilDetection {
  late String soilType;
  late String soilDataJson;
  BuildContext context;
  File? imageFile;

  SoilDetection({
    required this.context,
    required this.imageFile,
  });

  Future<void> detectSoil() async {
    if (kDebugMode) {
      print('SoilDetection.detectSoil called...');
    }
    await APIs.imageDetection(imageFile!, '', context, 1).then((value) {
      if (value == null) {
        soilType = '';
        return;
      }
      if (value == 'random') {
        soilType = '';
        alert(
            context,
            popupMessages[Get.locale.toString()]!['random']!['title']!,
            popupMessages[Get.locale.toString()]!['random']!['message']!,
            'error');
      } else {
        soilType = value.toString();
      }
    });
  }
}
