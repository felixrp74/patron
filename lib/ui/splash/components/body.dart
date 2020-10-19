import 'package:flutter/material.dart';
import 'package:patron/size_config.dart'; 
 
 
import '../../../constantes_ui.dart';
import '../components/splash_content.dart'; 

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text":
          "Realiza tus compras por internet mas rápido.\nCompra Lima Gas con garantía y seguridad.",
      "image": "assets/images/img_pedionline.png"
    },
    {
      "text": "Reparto a domicilio y\nasistencia técnica.",
      "image": "assets/images/img_servlimagas.png"
    },
    // {
    //   "text": "We show the easy way to shop. \nJust stay at home with us",
    //   "image": "assets/images/splash_3.png"
    // },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        // width: 100,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]["image"],
                  text: splashData[index]['text'],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    Spacer(flex: 3),
                    // DefaultButton(
                    //   text: "Siguiente",
                    //   press: () {
                        // Navigator.pushNamed(context, SignInScreen.routeName);
                    //   },
                    // ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
