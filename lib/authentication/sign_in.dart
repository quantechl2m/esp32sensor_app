import 'package:esp32sensor/authentication/forgot_password.dart';
import 'package:esp32sensor/services/auth.dart';
import 'package:flutter/material.dart';

import '../utils/constants/constants.dart';
import '../shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;
  bool hidePassword = true;
  //text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ?  Loading(size: 40,)
        : Scaffold(
            appBar: AppBar(
              leading: null,
              title: const Text(
                "Sign-In",
                style: TextStyle(
                  fontFamily: 'JosefinSans',
                  fontSize: 25.0,
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: FloatingActionButton.extended(
                    elevation: 10.0,
                    onPressed: () async {
                      widget.toggleView(false);
                    },
                    icon: const Icon(
                      Icons.app_registration,
                      color: Color.fromARGB(255, 68, 158, 115),
                    ),
                    label: const Text(
                      'Register',
                      style: TextStyle(
                          color: Color.fromARGB(255, 68, 158, 115),
                          fontFamily: 'JosefinSans'),
                    ),
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                )
              ],
              backgroundColor: const Color.fromARGB(255, 68, 158, 115),
            ),
            body: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 30.0),
                child: Form(
                    key: _formKey,
                    child: ListView(children: [
                      Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Email';
                              } else if (!value.contains('@')) {
                                return 'Please Enter Valid Email';
                              }
                              return null;
                            },
                            decoration: textInputDecoration.copyWith(
                                labelText: 'Email',
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Color.fromARGB(255, 68, 158, 115),
                                ),
                                hintText: 'Enter Your Email'),
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                            initialValue: email,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: 'Password',
                                hintText: 'Enter Your Password',
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
                            // (val) => val!.length < 6
                            //     ? 'Password must have more than 6 characters'
                            //     : null,
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                            obscureText: hidePassword,
                            initialValue: password,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPassword()));
                                },
                                child: const Text(
                                  "Forgot Password ?",
                                  style: TextStyle(
                                      fontFamily: 'JosefinSans',
                                      fontWeight: FontWeight.w700),
                                )),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 68, 158, 115),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });

                                dynamic result = await AuthService()
                                    .signInWithEmailAndPassword(
                                        email, password);

                                if (result['user'] != null) {
                                  setState(() {
                                    loading = false;
                                    error = '';
                                  });
                                } else {
                                  setState(() {
                                    loading = false;
                                    error = result['error'];
                                  });
                                }
                              }
                            },
                            child: const Text(
                              'Sign in',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14.0),
                          )
                        ],
                      ),
                    ]))),
          );
  }
}
