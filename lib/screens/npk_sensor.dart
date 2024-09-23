import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esp32sensor/screens/npk_analyzer.dart';
import 'package:esp32sensor/shared/loading.dart';
import 'package:esp32sensor/utils/constants/constants.dart';
import 'package:esp32sensor/utils/functions/formatter.dart';
import 'package:esp32sensor/widgets/banner_image.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/apis/soil_detection.dart';

class NPKSensor extends StatefulWidget {
  const NPKSensor({super.key});

  @override
  State<NPKSensor> createState() => _NPKSensorState();
}

class _NPKSensorState extends State<NPKSensor> {
  String _cropName = '';
  String _cropType = 'kharif';
  String _soilType = '';
  bool _agreed = false;
  String _selectedOption = '';
  bool _soilDetecting = false;
  bool _isSoilTypeFromDetection = false;
  File? _imageFile;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  final List<DropdownMenuEntry<String>> kharifCropEntries =
  <DropdownMenuEntry<String>>[
    DropdownMenuEntry(value: '', label: 'choose_kharif'.tr),
    DropdownMenuEntry(value: 'Soyabean', label: 'soyabean'.tr),
    DropdownMenuEntry(value: 'Maize', label: 'maize'.tr, enabled: false),
    DropdownMenuEntry(value: 'Rice', label: 'rice'.tr, enabled: false),
  ];

  final List<DropdownMenuEntry<String>> rabiCropEntries =
  <DropdownMenuEntry<String>>[
    DropdownMenuEntry(value: '', label: 'choose_rabi'.tr),
    DropdownMenuEntry(value: 'Potato', label: 'potato'.tr),
    DropdownMenuEntry(value: 'Wheat', label: 'wheat'.tr, enabled: false),
    DropdownMenuEntry(value: 'Gram', label: 'gram'.tr, enabled: false),
  ];

  Future<void> _detectSoil() async {
    setState(() {
      _soilDetecting = true;
    });
    SoilDetection soilDetection =
    SoilDetection(context: context, imageFile: _imageFile);
    await soilDetection.detectSoil();
    if (soilDetection.soilType == '') {
      setState(() {
        _soilType = '';
        _isSoilTypeFromDetection = false;
      });
    } else {
      setState(() {
        _soilType = soilDetection.soilType;
        _isSoilTypeFromDetection = true;
      });
    }
    setState(() {
      _soilDetecting = false;
    });
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
        _detectSoil();
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
        _detectSoil();
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

  Widget cropContent() => SizedBox(
    width: MediaQuery.of(context).size.width - 60,
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
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
                          Colors.blue.withOpacity(1), BlendMode.dstATop)
                          : ColorFilter.mode(Colors.black.withOpacity(1),
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
                          Colors.blue.withOpacity(1), BlendMode.dstATop)
                          : ColorFilter.mode(Colors.black.withOpacity(1),
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
          initialSelection: _cropName,
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
          initialSelection: _cropName,
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
          height: 20.0,
        ),
      ],
    ),
  );

  Widget soilContent() => Column(
    children: [
      DropdownMenu<String>(
        dropdownMenuEntries: [
          DropdownMenuEntry(value: '', label: 'select_soil_type'.tr),
          DropdownMenuEntry(value: 'Red', label: 'red_soil'.tr),
          DropdownMenuEntry(value: 'Black', label: 'black_soil'.tr),
          DropdownMenuEntry(value: 'Alluvial', label: 'alluvial_soil'.tr),
        ],
        onSelected: (val) {
          setState(() {
            _soilType = val.toString();
          });
        },
        initialSelection: _soilType,
        width: MediaQuery.of(context).size.width - 60,
      ),
      const SizedBox(
        height: 30.0,
      ),
      Align(
        alignment: Alignment.center,
        child: Text(
          "add_img".tr,
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ),
      const SizedBox(
        height: 20.0,
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width - 60,
        child: Row(children: [
          TapRegion(
            onTapInside: (e) {
              showImagePicker(context);
            },
            child: Container(
              width: 90,
              height: 90,
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
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          _imageFile == null
              ? const SizedBox()
              : Container(
            width: 90,
            height: 90,
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
          ),
          const SizedBox(
            width: 5.0,
          ),
          SizedBox(
            width: 100,
            child: _imageFile != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _soilDetecting
                    ? SizedBox(
                  height: 50,
                  width: 50,
                  child: Loading(
                    color: Colors.blue,
                    size: 30,
                  ),
                )
                    : _soilType == ''
                    ? Column(
                  children: [
                    const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 20.0,
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'no_soil_detected'.tr,
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.redAccent),
                    ),
                    TextButton(
                      onPressed: () {
                        _detectSoil();
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.refresh,
                            color: Colors.blue,
                            size: 20.0,
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'try_again'.tr,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                    : Column(
                  children: [
                    const Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 30.0,
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      '$_soilType Soil'.tr.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green),
                    ),
                  ],
                )
              ],
            )
                : const SizedBox(),
          )
        ]),
      ),
      const SizedBox(
        height: 20.0,
      ),
    ],
  );

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
            "npk_sensor".tr,
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
                  "npk_subtitle".tr,
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
                image: images['npkSensorBanner']!,
                height: 180 + MediaQuery.of(context).padding.top),
            const SizedBox(
              height: 20.0,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "has_crop".tr,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: RadioListTile(
                    title: Text("yes".tr),
                    value: 'Has Crop',
                    groupValue: _selectedOption,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedOption = newValue.toString();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: RadioListTile(
                    title: Text('no'.tr),
                    value: 'No Crop',
                    groupValue: _selectedOption,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedOption = newValue.toString();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _selectedOption == 'Has Crop'
                ? cropContent()
                : _selectedOption == 'No Crop'
                ? soilContent()
                : Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                      Colors.white, BlendMode.saturation),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage(
                        customIcons['npkSensorIcon']!.toString()),
                  ),
                ),
              ],
            ),
            _selectedOption == ''
                ? const SizedBox()
                : (_cropName != '' && _selectedOption == 'Has Crop') ||
                (_soilType != '' && _selectedOption == 'No Crop')
                ? Column(
              children: [
                CheckboxListTile(
                  title: Text(
                    'tick_box'.tr,
                    style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.black54),
                  ),
                  value: _agreed,
                  onChanged: (newValue) {
                    setState(() {
                      _agreed = newValue!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity
                      .leading, //  <-- leading Checkbox
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 60,
                    child: TextButton(
                      onPressed: (() {
                        if (_agreed) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NPKAnalyzer(
                                    key: const Key('NPKAnalyzer'),
                                    value:
                                    _selectedOption == 'Has Crop'
                                        ? _cropName
                                        : _soilType,
                                    isCrop: _selectedOption ==
                                        'Has Crop')),
                          );
                        }
                      }),
                      style: ButtonStyle(
                        backgroundColor: _agreed
                            ? MaterialStateProperty.all<Color>(
                            Colors.blue)
                            : MaterialStateProperty.all<Color>(
                            Colors.grey),
                        splashFactory: NoSplash.splashFactory,
                        overlayColor:
                        MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        fixedSize: MaterialStateProperty.all<Size>(
                            Size(
                                MediaQuery.of(context).size.width -
                                    60,
                                50)),
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
                      ),
                    ),
                  ),
                ),
              ],
            )
                : const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
