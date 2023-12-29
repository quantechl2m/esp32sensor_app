import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esp32sensor/video/video_player.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      width: 20.0,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('video').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return VideoPage(
            snap: snapshot.data!.docs[0].data(),
          );
        },
      ),
    );
  }
}
