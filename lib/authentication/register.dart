import 'package:flutter/material.dart';
import '../services/auth.dart';
import '../utils/constants/constants.dart';
import '../shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String error = '';
  bool hidePassword = true;
  bool loading = false;

  //text field state
  String name = '';
  String email = '';
  String password = '';
  String channel = '';
  String mobile = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return loading
        ?  Loading(size: 40,)
        : Scaffold(
            appBar: AppBar(
              leading: null,
              title: const Text(
                "Register",
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
                      widget.toggleView(true);
                    },
                    icon: const Icon(
                      Icons.app_registration,
                      color: Color.fromARGB(255, 68, 158, 115),
                    ),
                    label: const Text(
                      'Sign-In',
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
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'Name',
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Color.fromARGB(255, 68, 158, 115),
                                  ),
                                  hintText: 'Enter Your Name'),
                              validator: (val) =>
                                  val!.isEmpty ? 'Enter a name' : null,
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
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'Sensor Number',
                                  prefixIcon: const Icon(
                                    Icons.onetwothree,
                                    color: Color.fromARGB(255, 68, 158, 115),
                                  ),
                                  hintText:
                                      'Enter your sensor number given in box'),
                              validator: (val) => val!.isEmpty
                                  ? 'Enter your sensor number'
                                  : null,
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
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                              obscureText: hidePassword,
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
                                  setState(() {
                                    loading = true;
                                  });
                                  // () => Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (_) => IntroSliderPage(),
                                  //     ));
                                  dynamic result = await AuthService()
                                      .registerWithEmailAndPassword(
                                          email, password, name, mobile, channel);

                                  if (result == null ||
                                      result == 'Password provided is too weak' ||
                                      result ==
                                          'Email entered is already registered') {
                                    setState(() {
                                      loading = false;
                                      error = result;
                                    });
                                  }
                                }
                              },
                              child: const Text(
                                'Register',
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
