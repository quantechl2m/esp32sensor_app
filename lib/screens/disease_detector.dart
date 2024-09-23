import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:esp32sensor/utils/constants/constants.dart';
import 'package:esp32sensor/utils/constants/messages.dart';
import 'package:esp32sensor/widgets/banner_image.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/apis/disease_detection.dart';

class DiseaseDetector extends StatefulWidget {
  const DiseaseDetector({super.key});

  @override
  State<DiseaseDetector> createState() => _DiseaseDetectorState();
}

class _DiseaseDetectorState extends State<DiseaseDetector> {
  File? _imageFile;
  String _cropName = '';
  String _cropType = 'kharif';

  final picker = ImagePicker();
  late Map<String, dynamic> jsonResponse;

  @override
  void initState() {
    super.initState();
  }

  final List<DropdownMenuEntry<String>> kharifCropEntries =
      <DropdownMenuEntry<String>>[
    DropdownMenuEntry(value: '', label: 'choose_kharif'.tr),
    DropdownMenuEntry(value: 'soyabean', label: 'soyabean'.tr),
    DropdownMenuEntry(value: 'maize', label: 'maize'.tr),
    DropdownMenuEntry(value: 'rice', label: 'rice'.tr, enabled: false),
  ];

  final List<DropdownMenuEntry<String>> rabiCropEntries =
      <DropdownMenuEntry<String>>[
    DropdownMenuEntry(value: '', label: 'choose_rabi'.tr),
    DropdownMenuEntry(value: 'potato', label: 'potato'.tr),
    DropdownMenuEntry(value: 'wheat', label: 'wheat'.tr),
    DropdownMenuEntry(value: 'gram', label: 'gram'.tr, enabled: false),
  ];

  Future _predictDisease() async {
    // Make your API request here. Await is necessary.
    List<String> randomFacts = [];
    List<String> factStr = facts[Get.locale.toString()];

    for (int i = 0; i < 3; i++) {
      int random = 0 + Random().nextInt(29 - 0);
      randomFacts.add(factStr[random]);
    }

    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  radius: 60,
                  child: Image.asset(
                    customIcons['detectionIcon']!,
                  ),
                ),
                CarouselSlider(
                  items: randomFacts
                      .map((e) => SizedBox(
                          width: MediaQuery.of(context).size.width - 60,
                          child: Text(
                            e,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 14),
                          )))
                      .toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    height: 60,
                    viewportFraction: 1,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 200),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    pauseAutoPlayOnTouch: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    DiseaseDetection diseaseDetection = DiseaseDetection(
        cropName: _cropName, imageFile: _imageFile, context: context);

    await diseaseDetection.detectDisease();
  }

  _imgFromGallery() async {
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((value) {
      if (value != null) {
        // _cropImage(File(value.path));
        setState(() {
          _imageFile = File(value.path);
        });
      }
    });
  }

  _imgFromCamera() async {
    await picker
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then((value) {
      if (value != null) {
        // _cropImage(File(value.path));
        setState(() {
          _imageFile = File(value.path);
        });
      }
    });
  }

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Card(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5.2,
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.image,
                            size: 60.0,
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            "gallery".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          )
                        ],
                      ),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.pop(context);
                      },
                    )),
                    Expanded(
                        child: InkWell(
                      child: SizedBox(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.camera_alt,
                              size: 60.0,
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              "camera".tr,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        _imgFromCamera();
                        Navigator.pop(context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 180,
          centerTitle: true,
          leading: SizedBox(
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: Text(
            "disease_detector".tr,
            style: const TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black26,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: SizedBox(
                height: 80.0,
                width: MediaQuery.of(context).size.width - 100,
                child: Text(
                  "disease_det_subtitle".tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                )),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BannerImage(
                image: images['diseaseDetectorBanner']!,
                height: 180 + MediaQuery.of(context).padding.top),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 60,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "select_type".tr,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TapRegion(
                          onTapInside: (e) {
                            setState(() {
                              _cropType = 'kharif';
                              _cropName = '';
                            });
                          },
                          child: Container(
                            width: (MediaQuery.of(context).size.width - 70) / 2,
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                opacity: 0.7,
                                image: AssetImage(images['kharif']!),
                                fit: BoxFit.cover,
                                colorFilter: _cropType == 'kharif'
                                    ? ColorFilter.mode(
                                        Colors.blue.withOpacity(1),
                                        BlendMode.dstATop)
                                    : ColorFilter.mode(
                                        Colors.black.withOpacity(1),
                                        BlendMode.dstATop),
                              ),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.blue[700]!,
                                width: _cropType == 'kharif' ? 4 : 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'kharif'.tr,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          )),
                      TapRegion(
                          onTapInside: (e) {
                            setState(() {
                              _cropType = 'rabi';
                              _cropName = '';
                            });
                          },
                          child: Container(
                            width: (MediaQuery.of(context).size.width - 70) / 2,
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                opacity: 0.7,
                                image: AssetImage(images['rabi']!),
                                fit: BoxFit.cover,
                                colorFilter: _cropType == 'rabi'
                                    ? ColorFilter.mode(
                                        Colors.blue.withOpacity(1),
                                        BlendMode.dstATop)
                                    : ColorFilter.mode(
                                        Colors.black.withOpacity(1),
                                        BlendMode.dstATop),
                              ),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.blue[700]!,
                                width: _cropType == 'rabi' ? 4 : 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'rabi'.tr,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "select_crop".tr,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  _cropType == 'kharif'
                      ? DropdownMenu<String>(
                          initialSelection: '',
                          dropdownMenuEntries: kharifCropEntries,
                          onSelected: (val) {
                            setState(() {
                              _cropName = val.toString();
                            });
                          },
                          width: MediaQuery.of(context).size.width - 60,
                        )
                      : const SizedBox(),
                  _cropType == 'rabi'
                      ? DropdownMenu<String>(
                          initialSelection: '',
                          dropdownMenuEntries: rabiCropEntries,
                          onSelected: (val) {
                            setState(() {
                              _cropName = val.toString();
                            });
                          },
                          width: MediaQuery.of(context).size.width - 60,
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Row(children: [
                    TapRegion(
                      onTapInside: (e) {
                        showImagePicker(context);
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue[50],
                          border: Border.all(
                            color: Colors.blue[700]!,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 12.0,
                            ),
                            Icon(
                              Icons.add_a_photo,
                              color: Colors.blue[700],
                              size: 40.0,
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'add_image'.tr,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[700]),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    _imageFile == null
                        ? const SizedBox()
                        : Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(_imageFile!),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.grey[700]!,
                                width: 1,
                              ),
                            ),
                          )
                  ]),
                  const SizedBox(
                    height: 20.0,
                  ),
                  // _imageFile == null
                  //     ? const SizedBox()
                  //     : Text(
                  //         "Selected Image: ${_imageFile!.path.split('/').last}",
                  //         style: const TextStyle(fontSize: 14)),
                  const SizedBox(
                    height: 40.0,
                  ),
                  _cropName != '' && _imageFile != null
                      ? TextButton(
                          onPressed: (() {
                            _predictDisease();
                          }),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            fixedSize: MaterialStateProperty.all<Size>(Size(
                                MediaQuery.of(context).size.width - 60, 50)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'proceed'.tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ))
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
