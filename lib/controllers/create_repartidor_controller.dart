

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patron/models/repartidor_model.dart';

class CreateRepartidorController extends GetxController {

  TextEditingController repartidorCelularController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Rx<User> firebaseUser = Rx<User>();
  Rx<RepartidorModel> firestoreRepartidor = Rx<RepartidorModel>();
  final RxBool admin = false.obs;
  
  @override
  void onReady() async {
    //run every time auth state changes
    ever(firebaseUser, handleAuthChanged);
    firebaseUser.value = await getUser;
    firebaseUser.bindStream(user);
    super.onInit();
  }

  @override
  void onClose() {
    repartidorCelularController?.dispose();
    super.onClose();
  }
  
  handleAuthChanged(_firebaseUser) async {
    //get user data from firestore
    if (_firebaseUser?.uid != null) {
      firestoreRepartidor.bindStream(streamFirestoreUser());
      await isAdmin();
    }

    // if (_firebaseUser == null) {
    //   Get.offAll(SignInUI());
    // } else {
    //   Get.offAll(HomeUI());
    // }
  }

  // Firebase user one-time fetch
  Future<User> get getUser async => _auth.currentUser;

  // Firebase user a realtime stream
  Stream<User> get user => _auth.authStateChanges();

  
  //Streams the firestore user from the firestore collection
  Stream<RepartidorModel> streamFirestoreUser() {
    print('streamFirestoreUser()');
    if (firebaseUser?.value?.uid != null) {
      return _db
          .doc('/users/${firebaseUser.value.uid}')
          .snapshots()
          .map((snapshot) => RepartidorModel.fromMap(snapshot.data()));
    }

    return null;
  }

  //check if user is an admin user
  isAdmin() async {
    await getUser.then((user) async {
      DocumentSnapshot adminRef =
          await _db.collection('admin').doc(user?.uid).get();
      if (adminRef.exists) {
        admin.value = true;
      } else {
        admin.value = false;
      }
      update();
    });
  }



}
