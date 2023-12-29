import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/disease.dart';
import '../constants/messages.dart';
import '../functions/alert.dart';
import '../pojo/disease.dart';
import 'api.dart';

class DiseaseDetection {
  late String cropName;
  File? imageFile;
  Disease diseaseObject = Disease(
      diseaseCode: '',
      diseaseName: '',
      diseaseType: '',
      symptoms: '',
      description: [],
      measures: [],
      suggestions: Suggestions(commercial: [], household: []));
  String diseaseCode = '';
  BuildContext context;

  DiseaseDetection({
    required this.cropName,
    required this.imageFile,
    required this.context,
  });

  Future<void> detectDisease() async {
    if (kDebugMode) {
      print('DiseaseDetection.detectDisease called...');
    }

    await APIs.imageDetection(imageFile!, cropName, context, 2)
        .then((value) async {
      if (value == null) {
        return;
      }
      diseaseCode = value.toString();
      if (diseaseCode == 'healthy') {
        Navigator.pop(context);
        alert(
            context,
            popupMessages[Get.locale.toString()]!['healthy']!['title']!,
            popupMessages[Get.locale.toString()]!['healthy']!['message']!,
            'success');
      } else if (diseaseCode == 'random') {
        Navigator.pop(context);
        alert(
            context,
            popupMessages[Get.locale.toString()]!['random']!['title']!,
            popupMessages[Get.locale.toString()]!['random']!['message']!,
            'error');
      } else if (diseaseCode != '') {
        await APIs.getDiseaseData(diseaseCode, cropName, context).then((value) {
          diseaseObject = diseaseFromJson(value);
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DiseasePage(
                        diseaseObject: diseaseObject,
                        diseaseCode: diseaseCode,
                      )));
        });
      }
    });
  }
}
