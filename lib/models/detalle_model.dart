import 'package:cloud_firestore/cloud_firestore.dart';

class DetalleModel {
  // numero de orden

  // tipo
  // 0 : rosca
  // 1 : presion

  // peso 
  // 10 kilos
  // 20 kilos

  // int orden;
  int precio;
  int peso;
  String domicilio;

  DetalleModel({ precio, peso, domicilio });

  
  DetalleModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}){
    // orden = documentSnapshot.data()["orden"];
    precio = documentSnapshot.data()["precio"];
    peso = documentSnapshot.data()["peso"];
    domicilio = documentSnapshot.data()["domicilio"];
  }

  // DetalleModel.fromJson(Map<String, dynamic> json){
  //     this.orden = json['orden'];
  //     this.tipo = json['tipo'];
  //     this.peso = json['peso'];
  // }

  // Map<String, dynamic> toJson(){
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['tipo'] = this.tipo;
  //   return data;
  // }
}