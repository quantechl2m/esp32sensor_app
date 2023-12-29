import 'package:esp32sensor/screens/disease_detector.dart';
import 'package:esp32sensor/screens/npk_sensor.dart';
import 'package:esp32sensor/utils/constants/constants.dart';
import 'package:esp32sensor/widgets/banner_image.dart';
import 'package:esp32sensor/widgets/tap_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SoilPage extends StatelessWidget {
  const SoilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 180,
          centerTitle: true,
          title: Text('agriculture'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              )),
          backgroundColor: Colors.black26,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: SizedBox(
                height: 80.0,
                width: MediaQuery.of(context).size.width - 100,
                child: Text(
                  "agri_subtitle".tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                )),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                BannerImage(
                  image: images['agricultureBanner']!,
                  height: 180 + MediaQuery.of(context).padding.top,
                ),
                const SizedBox(height: 40),
                Column(
                  children: <Widget>[
                    TapCard(
                      title: 'disease_detector'.tr,
                      icon: customIcons['diseaseDetectorIcon']!,
                      route: const DiseaseDetector(),
                      color: Colors.black,
                      orientation: 'landscape',
                    ),
                    TapCard(
                      title: 'npk_sensor'.tr,
                      icon: customIcons['npkSensorIcon']!,
                      route: const NPKSensor(),
                      color: Colors.black,
                      orientation: 'landscape',
                    ),
                  ],
                ),
              ],
            )));
  }
}
