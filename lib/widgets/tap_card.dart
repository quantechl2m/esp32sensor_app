import 'package:flutter/material.dart';

class TapCard extends StatelessWidget {
  final String title;
  final String icon;
  final Object route;
  final Color? color;
  final String? orientation;

  const TapCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.route,
      required this.color,
      this.orientation});

  @override
  Widget build(BuildContext context) {
    if (orientation == 'landscape') {
      return Container(
          padding: const EdgeInsets.all(8),
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                fixedSize: Size(MediaQuery.of(context).size.width - 60, 120),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => route as Widget),
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(icon),
                      minRadius: 10,
                      maxRadius: 30,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Title(
                    color: Colors.black,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color),
                    ),
                  ),
                ],
              )));
    } else {
      return Container(
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => route as Widget),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircleAvatar(
                    foregroundImage: AssetImage(icon),
                  ),
                ),
                const SizedBox(height: 10),
                 Title(
                    color: Colors.black,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color),
                    ),
                  ),
                const SizedBox(height: 5),
              ],
            ),
          ));
    }
  }
}
