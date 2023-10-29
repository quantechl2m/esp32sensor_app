import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esp32sensor/shared/loading.dart';
import 'package:esp32sensor/utils/constants/constants.dart';
import 'package:esp32sensor/utils/functions/formatter.dart';
import 'package:esp32sensor/utils/pojo/npk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
class NPKAnalyzer extends StatefulWidget {
  final String value;
  final bool isCrop;

  const NPKAnalyzer({super.key, required this.value, required this.isCrop});

  @override
  State<NPKAnalyzer> createState() => _NPKAnalyzerState();
}

class _NPKAnalyzerState extends State<NPKAnalyzer> {
  bool _isLoading = false;
  bool _loading = false;
  List _data = [];
  int _nitrogen = 0;
  int _phosphorus = 0;
  int _potassium = 0;
  int _ph = 0;
  int _conductivity = 0;
  int _temperature = 0;
  int _moisture = 0;
  String _lastUpdatedText = 'Fetching...';
  Map<String, Range> _idealRange = {};
  final List<Crop> _crops = [];

  late StreamSubscription<QuerySnapshot> _eventsSubscription;

  final CollectionReference _currentNPKRef =
      FirebaseFirestore.instance.collection('npk_readings');

  void getCrops() async {
    List<Crop> crops = [];
    setState(() {
      _crops.clear();
    });
    await FirebaseFirestore.instance
        .collection('npk_ideal_ranges')
        .where('type', isEqualTo: 'crop')
        .get()
        .then((e) {
      for (var element in e.docs) {
        Map? data = element.data();
        crops.add(Crop(
          element.id,
          data['image'] ?? 'assets/images/soil.png',
          data['season'] ?? '',
          NPKIdealRange(
            data['N'] ?? '100-150',
            data['P'] ?? '100-150',
            data['K'] ?? '100-150',
            data['pH'] ?? '100-150',
            data['Conductivity'] ?? '100-150',
            data['Temperature'] ?? '100-150',
            data['Moisture'] ?? '100-150',
          ),
        ));
      }

      for (var crop in crops) {
        if (crop.npkIdealRange.isInRange(_nitrogen, _phosphorus, _potassium,_ph,_conductivity,_temperature,_moisture)) {
          setState(() {
            _crops.add(crop);
          });
        }
      }
      if (kDebugMode) {
        print('SUITABLE CROPS:\n $_crops');
      }
    }).onError((error, stackTrace) {
      Get.snackbar('Error', error.toString());
      if (kDebugMode) {
        print('error - getCrops: $error');
      }
    });
  }

  void getIdealRange() {
    setState(() {
      _isLoading = true;
    });
    FirebaseFirestore.instance
        .collection('npk_ideal_ranges')
        .doc(widget.value)
        .get()
        .then((value) {
      String nRange = value.data()?['N'] ?? '100-150';
      String pRange = value.data()?['P'] ?? '100-150';
      String kRange = value.data()?['K'] ?? '100-150';
      String phRange = value.data()?['pH'] ?? '100-150';
      String conductivityRange = value.data()?['Conductivity'] ?? '100-150';
      String temperatureRange = value.data()?['Temperature'] ?? '100-150';
      String moistureRange = value.data()?['Moisture'] ?? '100-150';
      if (kDebugMode) {
        print('NPK IDEAL RANGE FOR ${widget.value}:\n ${value.data()}');
      }
      setState(() {
        _idealRange = {
          'N': Range(
              int.parse(nRange.split('-')[0]), int.parse(nRange.split('-')[1])),
          'P': Range(
              int.parse(pRange.split('-')[0]), int.parse(pRange.split('-')[1])),
          'K': Range(
              int.parse(kRange.split('-')[0]), int.parse(kRange.split('-')[1])),
          'pH': Range(
              int.parse(phRange.split('-')[0]), int.parse(phRange.split('-')[1])),
          'Conductivity': Range(
              int.parse(conductivityRange.split('-')[0]), int.parse(conductivityRange.split('-')[1])),
          'Temperature': Range(
              int.parse(temperatureRange.split('-')[0]), int.parse(temperatureRange.split('-')[1])),
          'Moisture': Range(
              int.parse(moistureRange.split('-')[0]), int.parse(moistureRange.split('-')[1])),
        };
        _isLoading = false;
      });
    }).onError((error, stackTrace) {
      Get.snackbar('Error', error.toString());
      if (kDebugMode) {
        print('error - getIdealRange: $error');
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  void fetchSensorData() {
    // make query for latest doc in npk_readings collection and listen to it
    _eventsSubscription = _currentNPKRef
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        Map? data = event.docs.first.data() as Map?;
        if (kDebugMode) {
          print('CURRENT NPK READING:\n $data');
        }
        setState(() {
          _nitrogen = data?['N'] ?? 0;
          _phosphorus = data?['P'] ?? 0;
          _potassium = data?['K'] ?? 0;
          _ph = data?['pH'] ?? 0;
          _conductivity = data?['Conductivity'] ?? 0;
          _temperature = data?['Temperature'] ?? 0;
          _moisture = data?['Moisture'] ?? 0;
          _lastUpdatedText =
              dateFormatter((data?['timestamp'] as Timestamp).toDate());
        });
        getCrops();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getIdealRange();
    fetchSensorData();
  }

  @override
  void dispose() {
    _eventsSubscription.cancel();
    _currentNPKRef.doc('current').update({
      'N': 0,
      'P': 0,
      'K': 0,
      'pH':0,
      'Conductivity':0,
      'Temperature':0,
      'Moisture':0,
      'timestamp': Timestamp.now(),
      'sensorId': 123456
    });
    super.dispose();
  }
  void openBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        useSafeArea: true,
        showDragHandle: true,
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Column(
            children: [
              Text(
                'reading_history'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Divider(
                height: 5.0,
              ),
              Flexible(
                child: ListView(
                  children: [
                    _data.isEmpty
                        ? Center(
                      heightFactor: 10,
                      child: Text('no_data'.tr),
                    )
                        : Column(
                      children: _data
                          .map((doc) => Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.sensors),
                            title:
                            Text(doc['sensorId'].toString()),
                            subtitle: Text(dateFormatter(
                                doc['timestamp']!.toDate())),
                            // contentPadding:
                            // const EdgeInsets.symmetric(
                            //     horizontal: 20.0,
                            //     vertical: 5.0),
                            // horizontalTitleGap: 0,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'N',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                    Text(doc['N'].toString()),
                                  ],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'P',
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                    Text(doc['P'].toString()),
                                  ],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'K',
                                      style: TextStyle(
                                          color: Colors.purple,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                    Text(doc['K'].toString()),
                                  ],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'pH',
                                      style: TextStyle(
                                          color: Colors.purple,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                    Text(doc['pH'].toString()),
                                  ],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Cond.',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                    Text(doc['Conductivity'].toString()),
                                  ],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Temp.',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                    Text(doc['Temperature'].toString()),
                                  ],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                     Text(
                                      'Moist.',
                                      style: TextStyle(
                                          color: Colors.pink.shade700,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                    Text(doc['Moisture'].toString()),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 5.0,
                          ),
                        ],
                      ))
                          .toList(),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  void showHistory() async {
    setState(() {
      _loading = true;
    });
    await FirebaseFirestore.instance
        .collection('npk_readings')
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) {
      setState(() {
        _data = value.docs.map((doc) => doc.data()).toList();
        _loading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        _loading = false;
        _data = [];
      });
      Get.snackbar('Error', error.toString());
    });
    openBottomSheet();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
         mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'analyzer_heading'.tr,
              style: const TextStyle(fontSize: 15.3),
            ),
            Text('(${widget.value}${widget.isCrop ? "" : " Soil"})',
                style: const TextStyle(fontSize: 12.5, color: Colors.black54)),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.0,
        actions: [
          _loading
              ? Loading(size:40,color:Colors.black,)
              : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.history),
                onPressed: showHistory,
                iconSize: 23,
              ),
              Text(
                'history'.tr,
                style: const TextStyle(fontSize: 10.7, height: 0.2),
              ),
            ],
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: _isLoading
            ? SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.black54,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Fetching ideal range...',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
            children: [
                // make a banner to show last updated status
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.blueAccent,
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Last Updated: ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        _lastUpdatedText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <NPKData>[
                    NPKData('Temperature', 'Temperature', _temperature, Colors.black,
                        _idealRange['Temperature']!.getStatus(_temperature)),
                    NPKData('Moisture', 'Moisture', _moisture, Colors.pink.shade700,
                        _idealRange['Moisture']!.getStatus(_moisture)),
                    NPKData('Nitrogen'.tr, 'N', _nitrogen, Colors.blue,
                        _idealRange['N']!.getStatus(_nitrogen)),
                    NPKData('Phosphorus', 'P', _phosphorus, Colors.orange,
                        _idealRange['P']!.getStatus(_phosphorus)),
                    NPKData('Potassium', 'K', _potassium, Colors.purple,
                        _idealRange['K']!.getStatus(_potassium)),
                    NPKData('PH', 'pH', _ph, Colors.green,
                        _idealRange['pH']!.getStatus(_ph)),
                    NPKData('Conductivity', 'Conductivity', _conductivity, Colors.red,
                        _idealRange['Conductivity']!.getStatus(_conductivity)),

                  ]
                      .map((e) => Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: SfRadialGauge(
                                      enableLoadingAnimation: true,
                                      animationDuration: 1000,
                                      axes: <RadialAxis>[
                                        RadialAxis(
                                          canScaleToFit: true,
                                          minorTicksPerInterval: 10,
                                          majorTickStyle: const MajorTickStyle(
                                              thickness: 1,
                                              length: 10,
                                              color: Color.fromARGB(
                                                  255, 116, 116, 116)),
                                          minorTickStyle: const MinorTickStyle(
                                              thickness: 0.5,
                                              length: 7,
                                              color: Color.fromARGB(
                                                  255, 116, 116, 116)),
                                          minimum: 0.0,
                                          maximum: _idealRange[e.symbol]!
                                                  .start
                                                  .toDouble() +
                                              _idealRange[e.symbol]!
                                                  .end
                                                  .toDouble(),
                                          interval: ((_idealRange[e.symbol]!
                                                          .start
                                                          .toDouble() +
                                                      _idealRange[e.symbol]!
                                                          .end
                                                          .toDouble()) /
                                                  10)
                                              .floorToDouble(),
                                          axisLabelStyle:
                                              const GaugeTextStyle(fontSize: 8),
                                          axisLineStyle: const AxisLineStyle(
                                              thickness: 5, color: Colors.black),
                                          ranges: <NPKRange>[
                                            NPKRange(
                                                'Low'.tr,
                                                0,
                                                _idealRange[e.symbol]!.start,
                                                Colors.red),
                                            NPKRange(
                                                'Ideal'.tr,
                                                _idealRange[e.symbol]!.start,
                                                _idealRange[e.symbol]!.end,
                                                Colors.green),
                                            NPKRange(
                                                'High'.tr,
                                                _idealRange[e.symbol]!.end,
                                                _idealRange[e.symbol]!.start +
                                                    _idealRange[e.symbol]!.end,
                                                Colors.red),
                                          ]
                                              .map((r) => GaugeRange(
                                                    startValue:
                                                        r.start.toDouble(),
                                                    endValue: r.end.toDouble(),
                                                    startWidth: 15,
                                                    endWidth: 15,
                                                    rangeOffset: -5.0,
                                                    label: r.label,
                                                    labelStyle:
                                                        const GaugeTextStyle(
                                                            fontSize: 10,
                                                            color: Colors.white),
                                                    // gradient: SweepGradient(
                                                    //     colors: <Color>[e.color.withOpacity(.6), e.color],
                                                    //     stops: const <double>[0.25, 0.75]),
                                                    color: r.color,
                                                  ))
                                              .toList(),
                                          pointers: <GaugePointer>[
                                            NeedlePointer(
                                              value: e.value * 1.00,
                                              enableAnimation: true,
                                              needleLength: 0.5,
                                              needleStartWidth: 1,
                                              needleEndWidth: 4,
                                            )
                                          ],
                                          annotations: <GaugeAnnotation>[
                                            GaugeAnnotation(
                                              widget: Text(
                                                e.symbol,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: e.color),
                                              ),
                                              positionFactor: 0.5,
                                              angle: 90,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        e.label,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: e.color,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'current_reading'.tr,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            '${e.value}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Ideal Reading: ',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            _idealRange[e.symbol].toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'Status: ',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            e.status.label,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: e.status.color,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ))
                      .toList(),
                ),
                const SizedBox(
                  height: 20,
                ),
                //  make a view for suitable crops list in the current npk range which is inside _crops variable
                const Text(
                  'Suitable Crops',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width - 20,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _crops
                          .map((e) => SizedBox(
                                width: 100,
                                child: Column(
                                  children: [
                                    Image.asset(
                                      e.image,
                                      height: 80,
                                      width: 80,
                                    ),
                                    Text(
                                      e.name,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ))
              ]),
      ),
    );
  }
}
