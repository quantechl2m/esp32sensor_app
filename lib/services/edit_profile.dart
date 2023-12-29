import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esp32sensor/services/database.dart';
import 'package:esp32sensor/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final String name;
  final String channel;
  final String mobile;
  final String email;
  final String uid;
  const EditProfile(
      {super.key,
      required this.name,
      required this.channel,
      required this.email,
      required this.uid,
      required this.mobile});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final currentUser = FirebaseAuth.instance.currentUser;

  String error = '';

  //text field state
  String name = '';
  String channel = '';
  String mobile = '';

  Future<dynamic> gettingUserData() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();
    setState(() {
      name = (snap.data() as Map<String, dynamic>)["Name"];
      if (kDebugMode) {
        print('name: $name');
      }
      channel = (snap.data() as Map<String, dynamic>)["channel"];
      if (kDebugMode) {
        print('channel: $channel');
      }
      mobile = (snap.data() as Map<String, dynamic>)["mobile"];
      if (kDebugMode) {
        print('mobile: $mobile');
      }
    });
  }

  @override
  void initState() {
    gettingUserData();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontFamily: 'JosefinSans',
            fontSize: 25.0,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 68, 158, 115),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: Form(
              key: _formKey,
              child: ListView(children: [
                Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      initialValue: widget.name,
                      decoration: textInputDecoration.copyWith(
                          labelText: 'Name',
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 68, 158, 115),
                          ),
                          hintText: 'Enter Your Name'),
                      validator: (val) => val!.isEmpty ? 'Enter a name' : null,
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      initialValue: widget.channel,
                      decoration: textInputDecoration.copyWith(
                          labelText: 'Sensor Number',
                          prefixIcon: const Icon(
                            Icons.onetwothree,
                            color: Color.fromARGB(255, 68, 158, 115),
                          ),
                          hintText: 'Enter your sensor number given in box'),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter your sensor number' : null,
                      onChanged: (val) {
                        setState(() {
                          channel = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      initialValue: widget.mobile,
                      decoration: textInputDecoration.copyWith(
                          labelText: 'Mobile Number',
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: Color.fromARGB(255, 68, 158, 115),
                          ),
                          hintText: 'Enter your mobile number'),
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Mobile Number';
                        } else if (value.length < 10) {
                          return 'Please Enter Proper Mobile Number';
                        }
                        return null;
                      }),
                      onChanged: (val) {
                        setState(() {
                          mobile = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 68, 158, 115),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await DatabaseService(uid: widget.uid).updateUserData(
                              widget.uid, name, widget.email, channel, mobile).then((value) => Navigator.pop(context));
                        }
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
              ]))),
    );
  }
}
