import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GasAnalyzer extends StatefulWidget {
  final String title;
  final String dataParameter2;

  const GasAnalyzer(
      {super.key, required this.title, required this.dataParameter2});

  @override
  State<GasAnalyzer> createState() => _GasAnalyzerState();
}

class _GasAnalyzerState extends State<GasAnalyzer> {
  late List<LiveData> chartData;
  late Map<String, dynamic> dailyJsonResponse;
  List<HistoryData> fullData = [];
  List<HistoryData> dailyData = [];
  List<HistoryData> weeklyData = [];
  List<HistoryData> monthlyData = [];
  List<HistoryData> historyData = [];
  late ChartSeriesController _chartSeriesController;
  bool timerOff = false;
  String avgConcentration = '';
  String date = '';

  late String greeting;
  late int len;
  late Map<String, dynamic> jsonResponse;
  late String url;

  late String resistance = "";
  int concentration = 0;
  String humidity = '0';
  String temperature = '0';
  String mq135 = '0';
  String mq2 = '0';
  late Timer _timer;
  int lastConcentration = 0;
  int time = 11;
  int j = 0;
  Future<void> updatingHistoryData() async {
    List months = [
      " ",
      "Jan",
      "Feb",
      "Mar",
      "April",
      "May",
      "June",
      "July",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    if (widget.dataParameter2 == "field1") {
      url =
          "https://thingspeak.com/channels/2009308/field/1.json?average=daily&round=0";
    } else if (widget.dataParameter2 == "field2") {
      url =
          "https://thingspeak.com/channels/2009308/field/2.json?average=daily&round=0";
    } else {
      url =
          "https://thingspeak.com/channels/2009308/field/3.json?average=daily&round=0";
    }
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      dailyJsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      int length = dailyJsonResponse["feeds"].length;
      if (kDebugMode) {
        print('length = $length');
      }
      for (int i = 9; i >= 0; i--) {
        if (dailyJsonResponse["feeds"][length - 1 - i][widget.dataParameter2] !=
            null) {
          setState(() {
            resistance = dailyJsonResponse["feeds"][length - 1 - i]
                [widget.dataParameter2];
            concentration = int.parse(resistance);
          });
        } else {
          concentration = 0;
        }

        DateTime date = DateTime.parse(
            dailyJsonResponse["feeds"][length - 1 - i]["created_at"]);
        dailyData.add(
            HistoryData('${date.day} ${months[date.month]}', concentration));
      }
      for (int i = 70; i > 0; i = i - 7) {
        int avgVal = 0;
        for (int j = i; j > i - 7 && j > 0; j--) {
          int myValue = 0;

          if (dailyJsonResponse["feeds"][length - j][widget.dataParameter2] !=
              null) {
            setState(() {
              resistance =
                  dailyJsonResponse["feeds"][length - j][widget.dataParameter2];
            });

            myValue = int.parse(resistance);
          }
          avgVal += myValue;
        }
        int weeklyAvg = (avgVal / 7).round();
        weeklyData.add(HistoryData('${i / 7} Week', weeklyAvg));
      }

      int currentMonth = 0, monthCount = 0, avgValue = 0;
      for (int k = 0; k < length; k++) {
        int myValue1 = 0;
        DateTime date =
            DateTime.parse(dailyJsonResponse["feeds"][k]["created_at"]);
        int month = date.month;

        if (dailyJsonResponse["feeds"][k][widget.dataParameter2] != null) {
          setState(() {
            resistance = dailyJsonResponse["feeds"][k][widget.dataParameter2];
          });

          myValue1 = int.parse(resistance);
        }

        if (k == 0) {
          currentMonth = month;
        } else if (currentMonth != month || k == length - 1) {
          int monthlyAvg = (avgValue / monthCount).round();
          monthCount = 0;
          avgValue = 0;
          monthlyData.add(HistoryData('${months[currentMonth]}', monthlyAvg));
          currentMonth = month;
        }
        avgValue += myValue1;
        monthCount++;
      }
    }
  }

  @override
  void initState() {
    if (kDebugMode) {
      print(widget.dataParameter2);
    }
    updatingHistoryData();
    chartData = getChartData();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
     _loadData();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void showAlert() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      text: "Warning_msg".tr,
      title: "Warning".tr,
      titleColor: Colors.red,
      confirmBtnText: 'Okay'.tr,
      //confirmBtnColor: Colors.green
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
              width: MediaQuery.of(context).size.width * 0.3,
              child: FloatingActionButton.extended(
                heroTag: "btn1",
                elevation: 10.0,
                onPressed: () {
                  setState(() {
                    temperature = '0';
                    humidity = '0';
                    time = 11;
                    concentration = 0;
                    chartData = [
                      LiveData(0, 0),
                      LiveData(1, 0),
                      LiveData(2, 0),
                      LiveData(3, 0),
                      LiveData(4, 0),
                      LiveData(5, 0),
                      LiveData(6, 0),
                      LiveData(7, 0),
                      LiveData(8, 0),
                      LiveData(9, 0),
                      LiveData(10, 0),
                    ];
                  });
                },
                icon: const Icon(
                  Icons.update,
                  color: Color.fromARGB(255, 68, 158, 115),
                ),
                label: Text(
                  'Update',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 68, 158, 115),
                      fontFamily: 'JosefinSans',
                      fontSize: MediaQuery.of(context).size.height * 0.018),
                ),
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              timerOff = true;
            });

            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.title.tr,
          style:
              TextStyle(fontSize: MediaQuery.of(context).size.height * 0.025),
        ),
        backgroundColor: const Color.fromARGB(255, 68, 158, 115),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              "Concentration".tr,
              style: const TextStyle(
                  fontSize: 25.0,
                  color: Color.fromARGB(255, 68, 158, 115),
                  fontFamily: 'JosefinSans',
                  letterSpacing: 2.0),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: SfRadialGauge(
              enableLoadingAnimation: true,
              axes: <RadialAxis>[
                RadialAxis(
                  tickOffset: 5.0,
                  majorTickStyle: const MajorTickStyle(
                      color: Color.fromARGB(255, 116, 116, 116)),
                  minimum: 0.0,
                  maximum: 200.00,
                  interval: 20.0,
                  axisLabelStyle:
                      const GaugeTextStyle(fontWeight: FontWeight.w900),
                  ranges: <GaugeRange>[
                    GaugeRange(
                      startValue: 0.00,
                      endValue: 40,
                      rangeOffset: -5.0,
                      startWidth: 20,
                      endWidth: 20,
                      label: "Pure".tr,
                      labelStyle: const GaugeTextStyle(color: Colors.white),
                      gradient: const SweepGradient(colors: [
                        Colors.greenAccent,
                        Color.fromARGB(255, 70, 164, 119),
                      ]),
                    ),
                    GaugeRange(
                      startValue: 40,
                      endValue: 80,
                      startWidth: 20,
                      endWidth: 20,
                      rangeOffset: -5.0,
                      label: "Good".tr,
                      labelStyle: const GaugeTextStyle(color: Colors.white),
                      gradient: const SweepGradient(colors: [
                        Color.fromARGB(255, 70, 164, 119),
                        Color.fromARGB(255, 133, 207, 83),
                      ]),
                    ),
                    GaugeRange(
                      label: 'Moderate'.tr,
                      labelStyle: const GaugeTextStyle(color: Colors.white),
                      startValue: 80,
                      endValue: 120,
                      startWidth: 20,
                      endWidth: 20,
                      rangeOffset: -5.0,
                      gradient: const SweepGradient(colors: [
                        Color.fromARGB(255, 133, 207, 83),
                        Color.fromARGB(255, 193, 206, 98),
                      ]),
                    ),
                    GaugeRange(
                      label: 'Unhealthy'.tr,
                      labelStyle: const GaugeTextStyle(color: Colors.white),
                      startValue: 120,
                      endValue: 160,
                      startWidth: 20,
                      endWidth: 20,
                      rangeOffset: -5.0,
                      gradient: const SweepGradient(colors: [
                        Color.fromARGB(255, 193, 206, 98),
                        Color.fromARGB(255, 225, 175, 48),
                      ]),
                    ),
                    GaugeRange(
                      label: 'Hazardous'.tr,
                      labelStyle: const GaugeTextStyle(color: Colors.white),
                      startValue: 160,
                      endValue: 200,
                      startWidth: 20,
                      endWidth: 20,
                      rangeOffset: -5.0,
                      gradient: const SweepGradient(colors: [
                        Color.fromARGB(255, 225, 175, 48),
                        Color.fromARGB(255, 240, 72, 72),
                      ]),
                    ),
                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(
                      value: concentration * 1.00,
                      enableAnimation: true,
                    )
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Text(
                        '$concentration PPM',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 52, 106, 80)),
                      ),
                      positionFactor: 0.5,
                      angle: 90,
                    )
                  ],
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width * 0.45,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 68, 158, 115),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Center(
                  child: Text(
                    'Humidity : $humidity RH%',
                    style: const TextStyle(
                        color: Colors.white, fontFamily: 'JosefinSans'),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width * 0.45,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 68, 158, 115),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Center(
                  child: Text(
                    'Temperature : $temperature °C',
                    style: const TextStyle(
                        color: Colors.white, fontFamily: 'JosefinSans'),
                  ),
                ),
              )
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width * 0.9,
            // margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15.0)),
            child: SfCartesianChart(
                title: ChartTitle(
                  text: "Graph",
                  textStyle: const TextStyle(
                      fontSize: 15.0,
                      color: Color.fromARGB(255, 68, 158, 115),
                      fontFamily: 'JosefinSans',
                      letterSpacing: 2.0),
                ),
                enableAxisAnimation: true,
                series: <LineSeries<LiveData, int>>[
                  LineSeries<LiveData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController = controller;
                    },
                    dataSource: chartData,
                    color: const Color.fromARGB(255, 68, 158, 115),
                    xValueMapper: (LiveData sales, _) => sales.time,
                    yValueMapper: (LiveData sales, _) => sales.conc,
                  )
                ],
                primaryXAxis: NumericAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    interval: 1,
                    title: AxisTitle(
                        text: 'Time (Sec)',
                        textStyle: const TextStyle(
                            fontSize: 12.0,
                            color: Color.fromARGB(255, 68, 158, 115),
                            fontFamily: 'JosefinSans'))),
                primaryYAxis: NumericAxis(
                    interval: 10,
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                    title: AxisTitle(
                        text: 'Concentration(PPM)',
                        textStyle: const TextStyle(
                            fontSize: 12.0,
                            color: Color.fromARGB(255, 68, 158, 115),
                            fontFamily: 'JosefinSans')))),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: FloatingActionButton.extended(
                heroTag: "btn2",
                elevation: 10.0,
                onPressed: () {
                  updatingHistoryData();
                  setState(() {
                    historyData = dailyData;
                  });
                  var index = 0;
                  String xAxisTitle = "Date";
                  showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return SimpleDialog(
                            title: const Text(
                              "History",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 68, 158, 115),
                                  fontFamily: 'JosefinSans'),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextButton(
                                        style: TextButton.styleFrom(
                                            elevation: 6.0,
                                            shadowColor: const Color.fromARGB(
                                                255, 144, 142, 142),
                                            // disabledBackgroundColor:
                                            //     const Color.fromARGB(255, 68, 158, 115),
                                            backgroundColor: index == 0
                                                ? const Color.fromARGB(
                                                    255, 68, 158, 115)
                                                : const Color.fromARGB(
                                                    255, 255, 255, 255)),
                                        onPressed: () {
                                          setState(() {
                                            xAxisTitle = "Date";
                                            index = 0;
                                            historyData = dailyData;
                                          });
                                        },
                                        child: Text(
                                          "Daily",
                                          style: TextStyle(
                                              color: (index == 0)
                                                  ? const Color.fromARGB(
                                                      255, 255, 255, 255)
                                                  : const Color.fromARGB(
                                                      255, 68, 158, 115),
                                              fontFamily: 'JosefinSans',
                                              fontWeight: FontWeight.w200),
                                        )),
                                    TextButton(
                                        style: TextButton.styleFrom(
                                            elevation: 6.0,
                                            shadowColor: const Color.fromARGB(
                                                255, 144, 142, 142),
                                            // disabledBackgroundColor:
                                            //     const Color.fromARGB(255, 68, 158, 115),
                                            backgroundColor: (index == 1)
                                                ? const Color.fromARGB(
                                                    255, 68, 158, 115)
                                                : const Color.fromARGB(
                                                    255, 255, 255, 255)),
                                        onPressed: () {
                                          setState(() {
                                            xAxisTitle = "Past Weeks";
                                            index = 1;
                                            historyData = weeklyData;
                                          });
                                        },
                                        child: Text(
                                          "Weekly",
                                          style: TextStyle(
                                              color: (index == 1)
                                                  ? const Color.fromARGB(
                                                      255, 255, 255, 255)
                                                  : const Color.fromARGB(
                                                      255, 68, 158, 115),
                                              fontFamily: 'JosefinSans',
                                              fontWeight: FontWeight.w200),
                                        )),
                                    TextButton(
                                        style: TextButton.styleFrom(
                                            elevation: 6.0,
                                            shadowColor: const Color.fromARGB(
                                                255, 144, 142, 142),
                                            // disabledBackgroundColor:
                                            //     const Color.fromARGB(255, 68, 158, 115),
                                            backgroundColor: (index == 2)
                                                ? const Color.fromARGB(
                                                    255, 68, 158, 115)
                                                : const Color.fromARGB(
                                                    255, 255, 255, 255)),
                                        onPressed: () {
                                          setState(() {
                                            xAxisTitle = "Past Months";
                                            index = 2;
                                            historyData = monthlyData;
                                          });
                                        },
                                        child: Text(
                                          "Monthly",
                                          style: TextStyle(
                                              color: (index == 2)
                                                  ? const Color.fromARGB(
                                                      255, 255, 255, 255)
                                                  : const Color.fromARGB(
                                                      255, 68, 158, 115),
                                              fontFamily: 'JosefinSans',
                                              fontWeight: FontWeight.w200),
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
                                  child: SfCartesianChart(
                                    primaryXAxis: CategoryAxis(
                                        labelRotation: -90,
                                        interval: 1.0,
                                        title: AxisTitle(
                                            text: xAxisTitle,
                                            textStyle: const TextStyle(
                                                fontSize: 12.0,
                                                color: Color.fromARGB(
                                                    255, 68, 158, 115),
                                                fontFamily: 'JosefinSans'))),
                                    primaryYAxis: NumericAxis(
                                        interval: 5.0,
                                        title: AxisTitle(
                                            text: 'Average Concentration (PPM)',
                                            textStyle: const TextStyle(
                                                fontSize: 12.0,
                                                color: Color.fromARGB(
                                                    255, 68, 158, 115),
                                                fontFamily: 'JosefinSans'))),
                                    series: <ChartSeries>[
                                      StackedColumnSeries<HistoryData, String>(
                                          color: const Color.fromARGB(
                                              255, 68, 158, 115),
                                          dataSource: historyData,
                                          xValueMapper:
                                              (HistoryData history, _) =>
                                                  history.date,
                                          yValueMapper:
                                              (HistoryData history, _) =>
                                                  history.concentration)
                                    ],
                                  )),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                    left:
                                        MediaQuery.of(context).size.width * 0.5,
                                    right: 15),
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                        elevation: 8.0,
                                        shadowColor: const Color.fromARGB(
                                            255, 144, 142, 142),
                                        // disabledBackgroundColor:
                                        //     const Color.fromARGB(255, 68, 158, 115),
                                        backgroundColor: const Color.fromARGB(
                                            255, 68, 158, 115)),
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      "Okay",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontFamily: 'JosefinSans',
                                          fontWeight: FontWeight.w400),
                                    )),
                              )
                            ],
                          );
                        });
                      });
                },
                icon: const Icon(Icons.calendar_month, color: Colors.white),
                label: const Text(
                  'History',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'JosefinSans',
                      fontSize: 15.0),
                ),
                backgroundColor: const Color.fromARGB(255, 68, 158, 115)),
          ),
        ],
      ),
    );
  }

  Future<void> _loadData() async {
    url = "https://api.thingspeak.com/channels/2009308/feeds.json?results";

      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200 && timerOff == false) {
        jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        int length = jsonResponse["feeds"].length;

        try {
          if (jsonResponse["feeds"][length - 1][widget.dataParameter2] !=
              null) {
            setState(() {
              resistance =
                  jsonResponse["feeds"][length - 1][widget.dataParameter2];
              concentration = int.parse(resistance);
            });
          } else {
            setState(() {
              concentration = lastConcentration;
            });
            if (kDebugMode) {
              print("Null value from Thingspeak: ");
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }

        if (jsonResponse["feeds"][length - 1]["field4"] != null) {
          setState(() {
            temperature = jsonResponse["feeds"][length - 1]["field4"];
          });
        } else {
          if (kDebugMode) {
            print("Null value from Thingspeak: ");
          }
        }

        if (jsonResponse["feeds"][length - 1]["field5"] != null) {
          setState(() {
            humidity = jsonResponse["feeds"][length - 1]["field5"];
          });
        } else {
          if (kDebugMode) {
            print("Null value from Thingspeak: ");
          }
        }

        if (jsonResponse["feeds"][length - 1][widget.dataParameter2] != null) {
          setState(() {
            mq135 = jsonResponse["feeds"][length - 1][widget.dataParameter2];
          });
        } else {
          if (kDebugMode) {
            print("Null value from Thingspeak: ");
          }
        }

        if (jsonResponse["feeds"][length - 1][widget.dataParameter2] != null) {
          setState(() {
            mq2 = jsonResponse["feeds"][length - 1][widget.dataParameter2];
          });
        } else {
          if (kDebugMode) {
            print("Null value from Thingspeak: ");
          }
        }

        if (concentration >= 100 &&
            timerOff == false &&
            lastConcentration != concentration) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            padding: const EdgeInsets.all(16.0),
            content: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 90,
                  // MediaQuery.of(context).size.height * 0.10,
                  // width: MediaQuery.of(context).size.width * 0.80,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 217, 25, 25),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 4,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 50.0, top: 12),
                            child: Text(
                              "Warning!",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, top: 8),
                            child: Text(
                              "The concentration is in hazardous range",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20)),
                    child: SvgPicture.asset(
                      'assets/images/bubbles.svg',
                      height: 48,
                      width: 40,
                    ),
                  ),
                ),
                Positioned(
                  top: -20,
                  left: 0,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/fail.svg",
                        height: 45,
                      ),
                      Positioned(
                        top: 12,
                        child: SvgPicture.asset("assets/images/close.svg",
                            height: 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ));
        }
        lastConcentration = concentration;

        chartData.add(LiveData(time++, concentration));
        chartData.removeAt(0);
        _chartSeriesController.updateDataSource(
            addedDataIndex: chartData.length - 1, removedDataIndex: 0);
        // to not display warning if concentration does not change
      }
  }

  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, 0),
      LiveData(1, 0),
      LiveData(2, 0),
      LiveData(3, 0),
      LiveData(4, 0),
      LiveData(5, concentration),
      LiveData(6, concentration),
      LiveData(7, concentration),
      LiveData(8, concentration),
      LiveData(9, concentration),
      LiveData(10, concentration),
    ];
  }
}

class LiveData {
  LiveData(this.time, this.conc);
  final int time;
  final int conc;
}

class HistoryData {
  HistoryData(this.date, this.concentration);
  final String date;
  final int concentration;
}
