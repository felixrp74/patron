

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patron/models/models.dart';


class DetalleController extends GetxController { 
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Rx<User> firebaseUser = Rx<User>();
  Rx<UserModel> firestoreUser = Rx<UserModel>();

  Rx<List<DetalleModel>> todoList = Rx<List<DetalleModel>>(); //nuevo
  List<DetalleModel> get todos => todoList.value; //nuevo

  
  StreamSubscription <Position> positionStream;
  String _direccion = "";
  String _domicilio ;
  String get domicilio => _domicilio;
  
  String get direccion {
    return _direccion;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

     print("----------GET ARGUMENTS------------: ${Get.arguments}");
    _domicilio = Get.arguments as String;
  
    

    positionStream = getPositionStream(
      desiredAccuracy: LocationAccuracy.best , 
      distanceFilter: 1, 
      timeInterval: 1000
    ).listen((Position position) async { 

      
        // print("==============================${position}=============================");
        
        try{
          List<Placemark> placemarks = await placemarkFromCoordinates(position?.latitude, position?.longitude);
          Placemark placeMark = placemarks[0];
          String name = placeMark.name;
          String subLocality = placeMark.subLocality;
          String locality = placeMark.locality;
          String administrativeArea = placeMark.administrativeArea;
          String postalCode = placeMark.postalCode;
          String country = placeMark.country;
           _direccion = "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";
          
          print(_direccion);

        } on NoResultFoundException {
          print("// Implement behaviour on no results");
          rethrow;
        }
      }
    );


    
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    print("on ready ------------------");

  
  }
  
  void onClose() {
    super.onClose();
    positionStream.cancel();

  }


  handleAuthChanged(_firebaseUser)  { 
    

  }
 
       
  // Recuperación única de usuarios de Firebase
  Future<User> get getUser async => _auth.currentUser;

  
  // Usuario de Firebase una transmisión en tiempo real
  Stream<User> get user => _auth.authStateChanges();


  //Transmite el usuario de Firestore de la colección Firestore
  Stream<UserModel> streamFirestoreUser() {
    print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
    if (firebaseUser?.value?.uid != null) {
      return _db
          .doc('/users/${firebaseUser.value.uid}')
          .snapshots()
          .map((snapshot) => UserModel.fromMap(snapshot.data()));
    }

    return null;
  }

  //=====================================
  //Detalle CRUD
  //=====================================  

  Future<void> addDetalle(int precio, int peso, String domicilio) async {  
    print("ID DE ${_auth.currentUser.email} es ${_auth.currentUser.uid}");
    try {
      await _db
              .collection("users")
              .doc(_auth.currentUser.uid)
              .collection("detalle")
              .add({
                'dateCreated': Timestamp.now(),
                'precio': precio,
                'peso': peso,
                'domicilio': domicilio, 
              });
    } catch (e) {
      print("ERROR ADD EN LA COLECCION DETALLE $e");
      rethrow;
    }
  }


  // Stream<List<DetalleModel>> todoStream() {
  //   print("============== STREAMCITO *** ${_auth.currentUser.uid} ===============");
  //   try { 
  //       return _db
  //       .collection("users")
  //       .doc(_auth.currentUser.uid)
  //       .collection("todos")
  //       .orderBy("dateCreated", descending: true)
  //       .snapshots()
  //       .map((QuerySnapshot query) {
  //         List<DetalleModel> retVal = List();
  //         print("------***----- $query ------***-------");
  //         query.docs.forEach((element) {
  //           retVal.add(DetalleModel.fromDocumentSnapshot(element));            
  //         });          
  //         return retVal;
  //       });
  //   } catch (e){
  //     print("ERROR STREAM : $e");
  //   }
  
  // }

  // Future<void> updateTodo(bool newValue, String todoId) async {
  //   try {
  //     print("====${_auth.currentUser.uid}=====$todoId====$newValue====bay no baby no");
  //       _db
  //         .collection("users")
  //         .doc(_auth.currentUser.uid)
  //         .collection("todos")
  //         .doc(todoId)
  //         .update({"done": newValue});
  //   } catch (e) {
  //     print("me rehuso a darte un ultimo beso ===== $e");
  //     rethrow;
  //   }
  // }

}