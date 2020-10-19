

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patron/models/todo_model.dart';
import 'package:patron/models/user_model.dart';
import 'package:patron/ui/auth/auth.dart';
import 'package:patron/ui/ui.dart';


class TodoController extends GetxController { 
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Rx<User> firebaseUser = Rx<User>();
  Rx<UserModel> firestoreUser = Rx<UserModel>();

  Rx<List<TodoModel>> todoList = Rx<List<TodoModel>>(); //nuevo
  List<TodoModel> get todos => todoList.value; //nuevo

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print("similar a initstate");

    
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    print("on ready ------------------");

    //ejecutar cada vez que cambie el estado de autenticación
    ever(firebaseUser, handleAuthChanged);    
    firebaseUser.value = await getUser;
    print("ON READY  ===========${firebaseUser.value.uid} =============");
    firebaseUser.bindStream(user);

    
    // inyeccion de dependecias : stream coming from firebase
    todoList.bindStream(todoStream()); 
  
  }


  handleAuthChanged(_firebaseUser)  {
    // obtener datos de usuario de firestore
     
    if (_firebaseUser?.uid != null) {
      firestoreUser.bindStream(streamFirestoreUser());
      print("========HANDLE  CHANGED========");
      // await isAdmin();
    }

    if (_firebaseUser == null) {
      print("SIGN IN ========================");
      Get.offAll(SignInUI());
    } else {
      
      // print("HOME  ===========$_firebaseUser =============");
      Get.off(TodoUI()); 
    }
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
  //Repartidor CRUD
  //=====================================  

  Future<void> addTodo(String content) async {
    
    // if (firebaseUser?.value?.uid != null) {
      // print("ADD TO DO ====================${firebaseUser}=============");
    print("MIS INSTIINTOS DE ${_auth.currentUser.uid}");
    try {
      await _db
              .collection("users")
              .doc(_auth.currentUser.uid)
              .collection("todos")
              .add({
                'dateCreated': Timestamp.now(),
                'content': content,
                'done': false,
              });
    } catch (e) {
      print("ERROR ADD TO DO=========> $e");
      rethrow;
    }
    // }else{
    //   print("====================NO EXISTE USUARIO");
    // }
  }

  Stream<List<TodoModel>> todoStream() {
    print("============== STREAMCITO *** ${_auth.currentUser.uid} ===============");
    try { 
        return _db
        .collection("users")
        .doc(_auth.currentUser.uid)
        .collection("todos")
        .orderBy("dateCreated", descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
          List<TodoModel> retVal = List();
          print("------***----- $query ------***-------");
          query.docs.forEach((element) {
            retVal.add(TodoModel.fromDocumentSnapshot(element));
            
          });
          
          return retVal;
        });
    } catch (e){
      print("ERROR STREAM : $e");
    }
  
  }

  Future<void> updateTodo(bool newValue, String todoId) async {
    try {
      print("====${_auth.currentUser.uid}=====$todoId====$newValue====bay no baby no");
        _db
          .collection("users")
          .doc(_auth.currentUser.uid)
          .collection("todos")
          .doc(todoId)
          .update({"done": newValue});
    } catch (e) {
      print("me rehuso a darte un ultimo beso ===== $e");
      rethrow;
    }
  }

}