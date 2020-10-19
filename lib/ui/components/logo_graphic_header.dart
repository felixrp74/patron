import 'package:flutter/material.dart';
import 'package:patron/controllers/controllers.dart';

class LogoGraphicHeader extends StatelessWidget {
  LogoGraphicHeader();
  final ThemeController themeController = ThemeController.to;

  // @override
  Widget build(BuildContext context) {
    // String _imageLogo = 'assets/images/default.png';
    String _imageLogo = 'images/logo.jpg';
    if (themeController.isDarkModeOn == true) {
      // _imageLogo = 'assets/images/defaultDark.png';
      _imageLogo = 'images/logo.jpg';
    }
    return Hero(
      tag: 'App Logo',
      child: CircleAvatar(
          foregroundColor: Colors.blue,
          backgroundColor: Colors.transparent,
          radius: 60.0,
          child: ClipOval(
            child: Image.asset(
              _imageLogo,
              fit: BoxFit.cover,
              width: 120.0,
              height: 120.0,
            ),
          )),
    );
  }
}