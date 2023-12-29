import 'package:flutter/cupertino.dart';

class BannerImage extends StatelessWidget {
  final String image;
  final double? height;
  final String? shape;
  const BannerImage({super.key, required this.image, this.height, this.shape});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height ?? 300,
      decoration:   BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
        borderRadius: shape == 'round'? const BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15)): null,
      ),
    );
  }

}