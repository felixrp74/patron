import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:patron/ui/ui.dart';

import 'google_map_ui.dart';


class HomeUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("bajito"),
        actions: [ 
            IconButton(
                icon: Icon(Icons.map),
                onPressed: () {
                  Get.to(GoogleMapUI());
                }),
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Get.to(SettingsUI());
                }),
          ],
      ),
      // body: floatingActionButton: FloatingActionButton(onPressed: null) 
      // body: ,
      
      
    );
  }
}