import 'package:esp32sensor/services/auth.dart';
import 'package:esp32sensor/utils/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final currentUser = FirebaseAuth.instance.currentUser;

  var email = "";
  bool hidePassword = true;
  bool hideNewPassword = true;
  var newPassword = '';
  var oldPassword = '';
  String error = '';

  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 68, 158, 115),
          title: const Text(
            'Change Password',
            style: TextStyle(
              fontFamily: 'JosefinSans',
              fontSize: 25.0,
            ),
          )),
      body: Column(
        children: [
          Expanded(
              child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    child: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: 'Current Password',
                                hintText: 'Enter Current Password',
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Color.fromARGB(255, 68, 158, 115),
                                ),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (hidePassword == true) {
                                          hidePassword = false;
                                        } else {
                                          hidePassword = true;
                                        }
                                      });
                                    },
                                    child: hidePassword == true
                                        ? const Icon(
                                            Icons.visibility,
                                            color: Color.fromARGB(
                                                255, 123, 123, 123),
                                          )
                                        : const Icon(
                                            Icons.visibility_off,
                                            color: Color.fromARGB(
                                                255, 22, 152, 217),
                                          ))),
                            validator: ((value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Password';
                              } else if (value.length < 6) {
                                return 'Password must have more than 6 characters';
                              }
                              return null;
                            }),
                            onChanged: (val) {
                              setState(() {
                                oldPassword = val;
                              });
                            },
                            obscureText: hidePassword,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: 'New Password',
                                hintText: 'Enter New Password',
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Color.fromARGB(255, 68, 158, 115),
                                ),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (hideNewPassword == true) {
                                          hideNewPassword = false;
                                        } else {
                                          hideNewPassword = true;
                                        }
                                      });
                                    },
                                    child: hideNewPassword == true
                                        ? const Icon(
                                            Icons.visibility,
                                            color: Color.fromARGB(
                                                255, 123, 123, 123),
                                          )
                                        : const Icon(
                                            Icons.visibility_off,
                                            color: Color.fromARGB(
                                                255, 22, 152, 217),
                                          ))),
                            validator: ((value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Password';
                              } else if (value.length < 6) {
                                return 'Password must have more than 6 characters';
                              }
                              return null;
                            }),
                            onChanged: (val) {
                              setState(() {
                                newPassword = val;
                              });
                            },
                            obscureText: hideNewPassword,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.1),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 68, 158, 115),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  email = currentUser!.email!;
                                });
                                try {
                                  var cred = EmailAuthProvider.credential(
                                      email: email, password: oldPassword);
                                  await currentUser!
                                      .reauthenticateWithCredential(cred)
                                      .then((value) {
                                    currentUser!.updatePassword(newPassword);

                                    AuthService().signOut();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            backgroundColor: Color.fromARGB(
                                                255, 68, 158, 115),
                                            content: Text(
                                              'Your Password has been Changed. Login again !',
                                              style: TextStyle(fontSize: 12.0),
                                            )));
                                  });
                                } on FirebaseAuthException catch (e) {
                                  setState(() {
                                    if (e.code == 'wrong-password') {
                                      error = 'Wrong Current Password !';
                                    } else {
                                      error =
                                          'Something Went Wrong, Try Again !';
                                    }
                                  });
                                }
                              }
                            },
                            child: const Text(
                              'Change Password',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              error,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  )))
        ],
      ),
    );
  }
}
