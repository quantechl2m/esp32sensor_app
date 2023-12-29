import 'package:esp32sensor/authentication/authenticate.dart';
import 'package:esp32sensor/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils/pojo/app_user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    // return either home or authenticate widget
    if (user.uid == '') {
      return const Authenticate();
    } else {
      return const Homepage();
    }
  }
}
