import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:servicocerto/Models/User.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    try {
      await _db.collection("Users").add(user.toJson());
      // Atualize a interface aqui para exibir o tipo de usuário corretamente
      Get.snackbar("Sucesso", "Sua conta foi criada",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue.withOpacity(0.1),
          colorText: Colors.blue);
    } catch (error) {
      Get.snackbar("Error", "Algo deu errado. Tente novamente",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
    }
  }
}
