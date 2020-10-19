import 'package:flutter/material.dart';
 
import '../../../constantes_ui.dart';
import '../../../size_config.dart'; 

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key key,
    this.text,
    this.image, 
  }) : super(key: key);
  final String text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        const SizedBox(height: 50),
        Text(
          "Lima Gas",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(36),
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          text,
          textAlign: TextAlign.center,
        ),
        Spacer(flex: 2),
        Image.asset(
          image,
          height: getProportionateScreenHeight(300),
          width: getProportionateScreenWidth(300),
        ),
      ],
    );
  }
}
