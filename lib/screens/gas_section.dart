import 'dart:async';
import 'dart:convert';
import 'package:esp32sensor/screens/gas_analyzer.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class GasPage extends StatefulWidget {
  const GasPage({Key? key}) : super(key: key);

  @override
  State<GasPage> createState() => _GasPageState();
}

class _GasPageState extends State<GasPage> {
  String avgConcentration = '';
  String date = '';

  late String greeting;
  late int len;
  late Map<String, dynamic> jsonResponse;
  late String url;

  late String resistance = "";
  int concentration = 0;
  String butane = '0';
  String carbonDioxide = '0';
  String humidity = '0';
  String temperature = '0';
  late Timer _timer;
  int time = 11;
  @override
  void initState() {
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

  Future<void> _loadData() async {
    url = "https://api.thingspeak.com/channels/2009308/feeds.json?results";

      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200 && _timer.isActive) {

        jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

        int length = jsonResponse["feeds"].length;

        if (jsonResponse["feeds"][length - 1]["field1"] != null) {
          setState(() {
            resistance = jsonResponse["feeds"][length - 1]["field1"];
            concentration = int.parse(resistance);
          });
        } else {
          setState(() {
            concentration = 0;
          });
          if (kDebugMode) {
            print('Error: No data found for field1');
          }
        }

        if (jsonResponse["feeds"][length - 1]["field2"] != null) {
          setState(() {
            butane = jsonResponse["feeds"][length - 1]["field2"];
          });
        } else {
          setState(() {
            butane = '0';
          });
          if (kDebugMode) {
            print('Error: No data found for field2');
          }
        }

        if (jsonResponse["feeds"][length - 1]["field3"] != null) {
          setState(() {
            carbonDioxide = jsonResponse["feeds"][length - 1]["field3"];
          });
        }
        else {
          setState(() {
            carbonDioxide = '0';
          });
          if (kDebugMode) {
            print('Error: No data found for field3');
          }
        }

        if (jsonResponse["feeds"][length - 1]["field4"] != null) {
          setState(() {
            temperature = jsonResponse["feeds"][length - 1]["field4"];
          });
        }
        else {
          setState(() {
            temperature = '0';
          });
          if (kDebugMode) {
            print('Error: No data found for field4');
          }
        }

        if (jsonResponse["feeds"][length - 1]["field5"] != null) {
          setState(() {
            humidity = jsonResponse["feeds"][length - 1]["field5"];
          });
        }
        else {
          setState(() {
            humidity = '0';
          });
          if (kDebugMode) {
            print('Error: No data found for field5');
          }
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: SizedBox(
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: Text(
            "gas".tr,
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.height * 0.03),
          ),
          backgroundColor: const Color.fromARGB(255, 78, 181, 131),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Container(
          alignment: Alignment.center,
          color: const Color.fromARGB(255, 232, 241, 236),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text(
              //   "message_gas".tr,
              //   style: TextStyle(
              //       fontFamily: 'JosefinSans',
              //       color: const Color.fromARGB(255, 78, 181, 131),
              //       fontSize: MediaQuery.of(context).size.height * 0.05),
              // ),

              Padding(
                padding: const EdgeInsets.all(5),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.56,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 8, 86, 50),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.10,
                            width: MediaQuery.of(context).size.width * 0.70,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/gasindustry.png"),
                                    fit: BoxFit.contain)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(10.0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 233, 231, 231),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              '$temperature °C',
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 40, 132, 90),
                                                  fontFamily: 'JosefinSans',
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.018),
                                            ),
                                            Text(
                                              '$humidity RH%',
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 40, 132, 90),
                                                  fontFamily: 'JosefinSans',
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.018),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        'Temp. and RH%',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'JosefinSans',
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.018),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(10.0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Text(
                                          '$concentration PPM',
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 40, 132, 90),
                                              fontFamily: 'JosefinSans',
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.023),
                                        ),
                                      ),
                                    ),
                                    RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'JosefinSans',
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                            children: [
                                          const TextSpan(text: 'NO'),
                                          WidgetSpan(
                                            child: Transform.translate(
                                              offset: const Offset(0.0, 3.0),
                                              child: Text(
                                                '2',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'JosefinSans',
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.015),
                                              ),
                                            ),
                                          ),
                                        ]))
                                    // Text(
                                    //   'No2',
                                    //   style: TextStyle(
                                    //       color: Colors.white,
                                    //       fontFamily: 'JosefinSans',
                                    //       fontSize: MediaQuery.of(context)
                                    //               .size
                                    //               .height *
                                    //           0.02),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(10.0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 40, 132, 90),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Text(
                                          '$butane PPM',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'JosefinSans',
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.021),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Butane',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'JosefinSans',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(10.0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 68, 158, 115),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Text(
                                          '$carbonDioxide PPM',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'JosefinSans',
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.021),
                                        ),
                                      ),
                                    ),
                                    RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'JosefinSans',
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                            children: [
                                          const TextSpan(text: 'CO'),
                                          WidgetSpan(
                                            child: Transform.translate(
                                              offset: const Offset(0.0, 3.0),
                                              child: Text(
                                                '2',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'JosefinSans',
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.015),
                                              ),
                                            ),
                                          ),
                                        ]))
                                    // Text(
                                    //   'Co2',
                                    //   style: TextStyle(
                                    //       color: Colors.white,
                                    //       fontFamily: 'JosefinSans',
                                    //       fontSize: MediaQuery.of(context)
                                    //               .size
                                    //               .height *
                                    //           0.02),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: (() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              GasAnalyzer(title: 'NO2'.tr, dataParameter2: "field1")));
                    }),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.075,
                      width: MediaQuery.of(context).size.width * 0.9,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: Text(
                        "NO2".tr,
                        style: TextStyle(
                            fontFamily: 'JosefinSans',
                            color: const Color.fromARGB(255, 8, 86, 50),
                            fontSize:
                                MediaQuery.of(context).size.height * 0.021,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: (() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => GasAnalyzer(
                                title: 'CO2'.tr,
                                dataParameter2: "field3",
                              )));
                    }),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.075,
                      width: MediaQuery.of(context).size.width * 0.9,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: Text(
                        "CO2".tr,
                        style: TextStyle(
                            fontFamily: 'JosefinSans',
                            color: const Color.fromARGB(255, 8, 86, 50),
                            fontSize:
                                MediaQuery.of(context).size.height * 0.021,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: (() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const GasAnalyzer(
                                title: 'Butane',
                                dataParameter2: "field2",
                              )));
                    }),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.075,
                      width: MediaQuery.of(context).size.width * 0.9,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: Text(
                        'Butane',
                        style: TextStyle(
                            fontFamily: 'JosefinSans',
                            color: const Color.fromARGB(255, 8, 86, 50),
                            fontSize:
                                MediaQuery.of(context).size.height * 0.021,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
