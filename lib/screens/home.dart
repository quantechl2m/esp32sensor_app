import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esp32sensor/authentication/change_password.dart';
import 'package:esp32sensor/intro_slider.dart';
import 'package:esp32sensor/screens/about_us.dart';
import 'package:esp32sensor/screens/gas_section.dart';
import 'package:esp32sensor/screens/soil_section.dart';
import 'package:esp32sensor/services/auth.dart';
import 'package:esp32sensor/services/edit_profile.dart';
import 'package:esp32sensor/shared/dummy.dart';
import 'package:esp32sensor/utils/constants/constants.dart';
import 'package:esp32sensor/video/videoStream.dart';
import 'package:esp32sensor/widgets/tap_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final box = GetStorage();
  String name = '';
  String email = '';
  String channel = '';
  String mobile = '';
  String uid = '';

  Future<dynamic> gettingUserData() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();
    setState(() {
      name = (snap.data() as Map<String, dynamic>)["Name"];
      if (kDebugMode) {
        print(name);
      }
      channel = (snap.data() as Map<String, dynamic>)["channel"];
      if (kDebugMode) {
        print(channel);
      }
      mobile = (snap.data() as Map<String, dynamic>)["mobile"];
      if (kDebugMode) {
        print(mobile);
      }
      email = currentUser!.email!;
      uid = currentUser!.uid;
    });
  }

  @override
  void initState() {
    super.initState();
    gettingUserData();
    updateLanguage(getCurrentLocale());
  }

  @override
  void dispose() {
    super.dispose();
  }

  final AuthService _auth = AuthService();

  final List languages = const [
    {'name': "ENGLISH", "locale": Locale('en', 'US')},
    {'name': "हिन्दी", "locale": Locale('hi', 'IN')},
    {'name': "ಕನ್ನಡ", "locale": Locale('kan', 'KAR')},
    {'name': "தமிழ்", "locale": Locale('tam', 'TN')},
  ];

  Future updateLanguage(Locale locale) async {
    Get.back();
    box.write('locale', locale.toString());
    Future.delayed(Duration.zero, () {
      Get.updateLocale(locale);
    });
  }

  Locale getCurrentLocale() {
    final box = GetStorage();
    String? localeStr = box.read('locale');

    if (localeStr == null) {
      return const Locale('en', 'US');
    } else {
      return Locale(localeStr.split('_')[0], localeStr.split('_')[1]);
    }
  }

  buildDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text(
              "Choose language".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: "JosefinSans"),
            ),
            content: SizedBox(
              // alignment: Alignment.center,
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onTap: () {
                              updateLanguage(languages[index]['locale']);
                            },
                            child: Text(languages[index]['name'])),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(color: Colors.blue);
                  },
                  itemCount: languages.length),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 78, 181, 131),
              width: double.infinity,
              height: 250,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0, top: 40.0),
                    height: 100,
                    decoration: BoxDecoration(
                        border: Border.all(width: 2.0, color: Colors.white),
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                            image: AssetImage('assets/images/soil.png'))),
                  ),
                  Text(name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      )),
                  Text(
                    email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                children: [
                  {
                    'title': 'edit_profile'.tr,
                    'icon': Icons.edit_note_sharp,
                    'route': EditProfile(
                      name: name,
                      mobile: mobile,
                      channel: channel,
                      email: email,
                      uid: uid,
                    )
                  },
                  {
                    'title': 'change_password'.tr,
                    'icon': Icons.lock_open_sharp,
                    'route': const ChangePassword()
                  },
                  {
                    'title': 'change_language'.tr,
                    'icon': Icons.text_format_outlined,
                    'route': null
                  },
                  {
                    'title': 'how_to_use'.tr,
                    'icon': Icons.question_answer_outlined,
                    'route': const IntroSliderPage()
                  },
                  {
                    'title': 'demo_video'.tr,
                    'icon': Icons.video_camera_front_outlined,
                    'route': const MyWidget()
                  },
                  {
                    'title': 'about_us'.tr,
                    'icon': Icons.info,
                    'route': const AboutUs()
                  },
                  {'title': 'Logout'.tr, 'icon': Icons.logout, 'route': null},
                ]
                    .map((e) => InkWell(
                          onTap: () {
                            if (e['title'] == 'Logout'.tr) {
                              _auth.signOut();
                            } else if (e['title'] == 'Change Language'.tr) {
                              buildDialog(context);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          e['route'] as Widget));
                            }
                          },
                          child: Row(children: [
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30.0, 20, 20, 20),
                                child: Icon(
                                  e['icon'] as IconData?,
                                  size: 25.0,
                                  color: Colors.black54,
                                )),
                            Expanded(
                                child: Text(
                              e['title'] as String,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ))
                          ]),
                        ))
                    .toList(),
              ),
            )
          ],
        )),
      ),
      appBar: AppBar(
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
              size: 25,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        foregroundColor: Colors.black,
        centerTitle: true,
        toolbarHeight: 80,
        title: Text(
          'title'.tr,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
              iconSize: 40,
              icon: Image(
                image: AssetImage(customIcons['translationIcon']!),
              ),
              onPressed: () async {
                buildDialog(context);
              }),
        ],
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 60,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(images['homeBanner']!),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            // Text(
            //   "message".tr,
            //   style: const TextStyle( fontSize: 20),
            // ),
            const Icon(
              Icons.sensors,
              color: Colors.black54,
              size: 50,
            ),
            Wrap(
                spacing: 20,
                runSpacing: 20,
                children: <Map<String, dynamic>>[
                  {
                    'name': 'soil'.tr,
                    'image': customIcons['soilIcon'],
                    'route': const SoilPage()
                  },
                  {
                    'name': 'water'.tr,
                    'image': customIcons['waterIcon'],
                    'route': const DummyContent(
                      text: 'Water',
                    )
                  },
                  {
                    'name': 'gas'.tr,
                    'image': customIcons['gasIcon'],
                    'route': const GasPage()
                  },
                  {
                    'name': 'bio'.tr,
                    'image': customIcons['bioIcon'],
                    'route': const DummyContent(
                      text: 'Bio',
                    )
                  },
                ]
                    .map((e) => TapCard(
                        title: e['name'],
                        icon: e['image'],
                        route: e['route'],
                        color: Colors.black))
                    .toList()),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
