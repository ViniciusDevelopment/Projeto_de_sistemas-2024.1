import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:servicocerto/Models/User.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user, {String? photoURL}) async {
    final userRef = _db
        .collection("Users")
        .doc(user.email); // Use o e-mail como ID do documento

    await userRef.set({
      ...user.toJson(),
      'photoURL': photoURL,
    }).then((_) {
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

  Future<File?> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<String?> uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef =
          storageRef.child("profileImages/${image.path.split('/').last}");
      await imageRef.putFile(image);
      return await imageRef.getDownloadURL();
    } catch (e) {
      Get.snackbar("Erro", "Não foi possível fazer upload da imagem",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      return null;
    }
  }

  Future<List<UserModel>?> getUser(String email) async {
    try {
      final QuerySnapshot userQuery = await _db
          .collection("Users")
          .where("Email", isEqualTo: email)
          .where('TipoUser', isEqualTo: 'Prestador')
          .get();

      final user = userQuery.docs.map((doc) {
        return UserModel(
          cpf: doc['Cpf'],
          email: doc['Email'],
          endereco: doc['Endereco'],
          name: doc['Name'],
          password: doc['Password'],
          telefone: doc['Telefone'],
          tipoUser: doc['TipoUser'],
        );
      }).toList();

      return user;
        } catch (error) {
      return null;
    }
  }
}
