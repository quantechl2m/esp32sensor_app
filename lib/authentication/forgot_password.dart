import 'package:esp32sensor/services/auth.dart';
import 'package:esp32sensor/utils/constants/constants.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  var email = "";
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
            'Reset Password',
            style: TextStyle(
              fontFamily: 'JosefinSans',
              fontSize: 25.0,
            ),
          )),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: const Text(
              'Reset Link will be sent to your email id !',
              style: TextStyle(
                  fontSize: 15.0,
                  color: Color.fromARGB(255, 183, 187, 185),
                  fontFamily: 'JosefinSans'),
            ),
          ),
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
                                labelText: 'Email',
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Color.fromARGB(255, 68, 158, 115),
                                ),
                                hintText: 'Enter Your Email'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Email';
                              } else if (!value.contains('@')) {
                                return 'Please Enter Valid Email';
                              }
                              return null;
                            },
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.1,
                              vertical: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 68, 158, 115),
                            ),
                            onPressed: () async {
                              dynamic result =
                                  await AuthService().resetPassword(email);
                              if (result ==
                                      'Email is being sent please wait for a minute' ||
                                  result == 'Please enter valid email') {
                                setState(() {
                                  error = result;
                                });
                              }
                            },
                            child: const Text(
                              'Send Email',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14.0),
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
