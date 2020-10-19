import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:get/get.dart';

import 'package:geocoding/geocoding.dart';
import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';
import 'package:patron/controllers/controllers.dart';

import 'components/components.dart';

// import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';

class MapaUI extends StatefulWidget {
  @override
  _MapaUIState createState() => _MapaUIState();
}

class _MapaUIState extends State<MapaUI> {
  StreamSubscription<Position> _positionStream;

  MapboxMapController mapController;
  MapboxMap mapbox;
  // String _error;
  double latitud = -15.8226492;
  double longitud = -69.9891691;
  Position _position = Position(latitude: -15.8226492, longitude: -69.9891691);

  String sateliteStyle =
      "mapbox://styles/fenix95linux/ckfvubens1vpb19qp0hwehpsx"; //0
  String oscuroStyle =
      "mapbox://styles/fenix95linux/ckfvu7p7e1rhx19omc2ty9acy"; //1
  String calleStyle =
      "mapbox://styles/fenix95linux/ckfvtzppr3zn819p5i5gukqxs"; //2

  String estiloSeleccionado =
      "mapbox://styles/fenix95linux/ckfvubens1vpb19qp0hwehpsx"; //1

  int index = 0;

  double zoom = 14;

  String domicilioGlobal = "";

  void initState() {
    super.initState();

    _positionStream = getPositionStream(
            desiredAccuracy: LocationAccuracy.best,
            distanceFilter: 1,
            timeInterval: 1000)
        .listen((Position position) {
      setState(() {
        print(
            "==============================${position}=============================");
        // moverCamara(); // nuevo, mover la visibilidad mientras localiza
        _position = position;
      });
    });
  }

  void dispose() {
    super.dispose();
    _positionStream.cancel();
  }

  void moverCamara() async {
    print("MOVER CAMARA");

    setState(() {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 270.0,
            target: LatLng(_position?.latitude, _position?.longitude),
            tilt: 30.0,
            zoom: zoom,
          ),
        ),
      );

      mapController.addSymbol(SymbolOptions(
        geometry: LatLng(_position?.latitude, _position?.longitude),
        iconSize: 3,
        iconImage: 'attraction-15',
        textField: 'Delivery',
        textOffset: Offset(0, 2),
      ));

      // double distanceInMeters = distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);

      // print("distancia: ===========> $distanceInMeters");

      // mapController.updateMyLocationTrackingMode(  )

      //     mapbox.addMarker(new MarkerOptions()
      // .position(new LatLng(48.85819, 2.29458))
      // .title("Eiffel Tower"));
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _position?.latitude, _position?.longitude);
      print("======placemark=====$placemarks==========");
    } on NoResultFoundException {
      print("// Implement behaviour on no results");
      rethrow;
    }
  }

  void Function(Point<double>, LatLng) obtenerCoordenadas(LatLng latLng) {
    // void Function(Point<double>, LatLng)

    print(" flaca no me claves : $latLng ");
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    // controller.addImage(name, bytes)
  }

  void getDomcilio(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng?.latitude, latLng?.longitude);
      Placemark placeMark = placemarks[0];
      String name = placeMark.name;
      String subLocality = placeMark.subLocality;
      String locality = placeMark.locality;
      String administrativeArea = placeMark.administrativeArea;
      String postalCode = placeMark.postalCode;
      String country = placeMark.country;
      String direccion =
          "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";

      print(direccion);

      // return direccion;
      domicilioGlobal = direccion;
    } on NoResultFoundException {
      print("// Implement behaviour on no results");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapController>(
      init: MapController(),
      initState: (_) {},
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Esporti es la prueba de geolocator"),
          ),
          // floatingActionButton: FloatingActionButton.extended(
          //   label: Text("Buscar"),
          //   icon: Icon(Icons.search),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => BuscarPage()),
          //     );
          //   },

          // ),
          body:
              // Text('limon')

          MapboxMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(_position?.latitude, _position?.longitude),
              zoom: zoom,
            ),
            // void Function(Point<double>, LatLng) onMapClick
            onMapClick: (a, b) async {
              print("coordenadas del click:  ");

              // getDomcilio(b);
              // ======================================
              try {
                List<Placemark> placemarks =
                    await placemarkFromCoordinates(b?.latitude, b?.longitude);
                Placemark placeMark = placemarks[0];
                String name = placeMark.name;
                String calle = placeMark.street;
                String subLocality = placeMark.subLocality;
                String locality = placeMark.locality;
                String administrativeArea = placeMark.administrativeArea;
                String postalCode = placeMark.postalCode;
                String country = placeMark.country;
                String direccion = " $name, $calle, $subLocality, $locality , $country";

                print(direccion);

                // return direccion;
                domicilioGlobal = direccion;
              } on NoResultFoundException {
                print("// Implement behaviour on no results");
                rethrow;
              }
              // ==================================

              // print("domicilio global: ");
            },
          ),
          
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: moverCamara,
                    tooltip: 'My Localizacion',
                    child: Icon(Icons.my_location),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      // Get.to(PedidoUI(), argument: )
                      if (domicilioGlobal != "") {
                        _.mostrarDetalle(domicilioGlobal);
                      } else {
                        print("ERROR");
                      }
                    },
                    tooltip: 'Siguiente',
                    child: Icon(Icons.navigate_next),
                  )
                ],
              ),
            )
          );
      },
    );
  }
}
