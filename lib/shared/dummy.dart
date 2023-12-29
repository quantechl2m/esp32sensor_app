import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DummyContent extends StatelessWidget {
  final String text;
  const DummyContent({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
              fontFamily: 'JosefinSans'),
        ),
        backgroundColor: const Color.fromARGB(255, 78, 181, 131),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(children: <Widget>[
          const SizedBox(height: 20),
          //  construction image
          Image.network(
          'https://pngimg.com/uploads/under_construction/under_construction_PNG37.png',
            height: 200,
            width: 200,
          ),
          const SizedBox(height: 20),
          Text(
            '$text Page is under construction!',
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                fontFamily: 'JosefinSans'),
          )
        ]),
      ),
    );
  }
}
