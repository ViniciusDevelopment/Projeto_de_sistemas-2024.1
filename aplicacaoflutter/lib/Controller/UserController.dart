import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:servicocerto/Models/User.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    final userRef = _db
        .collection("Users")
        .doc(user.email); // Use o e-mail como ID do documento

    await userRef.set(user.toJson()).then((_) {
      Get.snackbar("Sucesso", "Sua conta foi criada",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue.withOpacity(0.1),
          colorText: Colors.blue);
    }).catchError((error) {
      Get.snackbar("Error", "Algo deu errado. Tente novamente",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
    });
  }
}
