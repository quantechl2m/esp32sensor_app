import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String image;
  final String link;
  // String price;

  const ProductCard({
    super.key,
    required this.title,
    required this.image,
    required this.link,
    // required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.all(8),
        // padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 4,
            ),
          ],
        ),
        child: FilledButton(
            onPressed: () async {
              await launchUrlString(link);
            },
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.transparent,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          fontSize: title.length > 20 ? 12 : 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // const Text(
                      //   'Click to buy',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     fontSize: 12,
                      //     fontWeight: FontWeight.bold,
                      //     color: Colors.grey,
                      //   ),
                      // )
                    ],
                  ),
                ])));
  }
}
