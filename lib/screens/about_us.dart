import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About Us",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
              fontFamily: 'JosefinSans'),
        ),
        backgroundColor: const Color.fromARGB(255, 78, 181, 131),
      ),
      body: Container(
          alignment: Alignment.center,
          child: const Text(
            "Emergency Number: 123456789",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
                fontFamily: 'JosefinSans'),
          )),
    );
  }
}
