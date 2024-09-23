import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:esp32sensor/utils/pojo/disease.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:esp32sensor/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:esp32sensor/widgets/banner_image.dart';
import 'package:esp32sensor/widgets/product_card.dart';

class DiseasePage extends StatefulWidget {
  final String diseaseCode;
  final Disease diseaseObject;

  const DiseasePage(
      {super.key, required this.diseaseCode, required this.diseaseObject});

  @override
  State<DiseasePage> createState() => _DiseasePageState();
}

class _DiseasePageState extends State<DiseasePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex1 = 0;
  int _currentIndex2 = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {}

  String getDownloadURL(String file) {
    String fileName = file.split('/').last;
    String downloadURL =
        'https://firebasestorage.googleapis.com/v0/b/esp32sensor-10e27.appspot.com/o/assets%2Fimages%2F$fileName?alt=media&token=7695511b-e4dc-441f-95fe-3b17aae34329';
    return downloadURL;
  }

  List<int> bytes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 180,
        title: Text(widget.diseaseObject.diseaseName,
            softWrap: true,
            style: TextStyle(
                fontSize:
                    widget.diseaseObject.diseaseName.length > 20 ? 20 : 25,
                fontWeight: FontWeight.bold,
              color: Colors.white
            )),
        centerTitle: true,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: SizedBox(
                height: 55,
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: TabBar(
                       indicatorPadding: const EdgeInsets.symmetric(horizontal: -7,vertical: 5),
                        controller: _tabController,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue.shade400),
                        tabs: [
                          Tab(
                              height: 45,
                              child: Text('Prediction'.tr,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))),
                          Tab(
                              height: 45,
                              child: Text('Suggestions'.tr,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                  ],
                ))),
        backgroundColor: Colors.black26,
      ),
      body: Column(
        children: [
          BannerImage(
            image: images['diseaseDetectorBanner']!,
            height: 180 + MediaQuery.of(context).padding.top,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 20.0),
                          child: Text('reasons'.tr,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        Column(
                          children: widget.diseaseObject.description
                              .map((item) => ListTile(
                                    horizontalTitleGap: 0.0,
                                    minVerticalPadding: 10.0,
                                    leading: SvgPicture.asset(
                                     customIcons['seedlingIcon']!,
                                      width: 20,
                                      height: 20,
                                    ),
                                    title: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                      softWrap: true,
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 20.0),
                          child: Text('measures'.tr,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        Column(
                          children: widget.diseaseObject.measures
                              .map((item) => ListTile(
                                    horizontalTitleGap: 0.0,
                                    minVerticalPadding: 10.0,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 24.0),
                                    leading: SvgPicture.asset(
                                     customIcons['seedlingIcon']!,
                                      width: 20,
                                      height: 20,
                                    ),
                                    title: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                      softWrap: true,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    )
                  ],
                ),
                ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Text('commercial_solutions'.tr.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CarouselSlider(
                      items: widget.diseaseObject.suggestions.commercial
                          .map(
                            (item) => ProductCard(
                                title: item.title,
                                image: getDownloadURL(item.image),
                                link: item.link),
                          )
                          .toList(),
                      options: CarouselOptions(
                        height: 200.0,
                        viewportFraction: 0.8,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex1 = index;
                          });
                        },
                      ),
                    ),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.diseaseObject.suggestions.commercial
                            .map((e) => Container(
                                  width: 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 2.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: widget.diseaseObject.suggestions
                                                  .commercial
                                                  .indexOf(e) ==
                                              _currentIndex1
                                          ? Colors.black54
                                          : Colors.grey[300]),
                                ))
                            .toList()),

                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Text('home_remedies'.tr.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 200.0,
                        viewportFraction: 0.8,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex2 = index;
                          });
                        },
                      ),
                      items: widget.diseaseObject.suggestions.household
                          .map((item) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            getDownloadURL(item.image)),
                                        fit: BoxFit.cover
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 15),
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        item.text,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )));
                          },
                        );
                      }).toList(),
                      //   make carousel indicator
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    //   make carousel indicator dots
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.diseaseObject.suggestions.household
                            .map((e) => Container(
                                  width: 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 2.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: widget.diseaseObject.suggestions
                                                  .household
                                                  .indexOf(e) ==
                                              _currentIndex2
                                          ? Colors.black54
                                          : Colors.grey[300]),
                                ))
                            .toList())
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
