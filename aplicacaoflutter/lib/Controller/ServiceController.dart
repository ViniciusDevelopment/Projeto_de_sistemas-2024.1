import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servicocerto/Models/Service.dart';
import 'package:get/get.dart';

class ServiceController extends GetxController {
  static ServiceController get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> createService(ServiceModel service) async {
    try {
      // Obter o usuário atualmente autenticado
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("Nenhum usuário está logado");
      }

      // Criar um novo documento na coleção "Servicos"
      await _db.collection("Servicos").add({
        "uid": user.uid, // Vincular o UID do usuário ao serviço
        "descricao": service.descricao,
        // Adicionar mais campos do serviço conforme necessário
      });

      // Exibir mensagem de sucesso
      Get.snackbar(
        "Sucesso",
        "Seu serviço foi vinculado ao seu usuário",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.withOpacity(0.1),
        colorText: Colors.blue,
      );
    } catch (error) {
      // Exibir mensagem de erro em caso de falha
      Get.snackbar(
        "Error",
        "Algo deu errado. Tente novamente",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      print("Erro ao criar serviço: $error");
    }
  }
}
