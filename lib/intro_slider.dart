import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

class IntroSliderPage extends StatefulWidget {
  const IntroSliderPage({super.key});

  @override
  State<IntroSliderPage> createState() => _IntroSliderPageState();
}

class _IntroSliderPageState extends State<IntroSliderPage> {
  List<ContentConfig> listContentConfig = [];

  @override
  void initState() {
    super.initState();

    listContentConfig.add(
      const ContentConfig(
        title: "ERASER",
        description:
            "Allow miles wound place the leave had. To sitting subject no improve studied limited",
        pathImage: "images/soil.png",
        backgroundColor: Color(0xfff5a623),
      ),
    );
    listContentConfig.add(
      const ContentConfig(
        title: "PENCIL",
        description:
            "Ye indulgence unreserved connection alteration appearance",
        pathImage: "images/soil.png",
        backgroundColor: Color.fromARGB(96, 0, 255, 68),
      ),
    );
    listContentConfig.add(
      const ContentConfig(
        title: "RULER",
        description:
            "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of",
        pathImage: "images/water.png",
        backgroundColor: Color(0xff9932CC),
      ),
    );
  }

  void onDonePress() {
    log("End of slides");
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
        key: UniqueKey(),
        listContentConfig: listContentConfig,
        onDonePress: () {
          Navigator.pop(context);
        }
        // () async {
        //   dynamic result = await AuthService()
        //       .registerWithEmailAndPassword(widget.email, widget.password);

        );
  }
}
