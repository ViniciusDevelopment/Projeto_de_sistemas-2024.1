import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart'; // Adicione esta linha
import 'package:servicocerto/Models/Service.dart';

class ServiceController extends GetxController {
  static ServiceController get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> createService(ServiceModel service) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("Nenhum usuário está logado");
      }

      await _db.collection("Servicos").add({
        "uid": user.uid,
        "descricao": service.descricao,
        "valor": service.valor,
        "disponibilidade": service.disponibilidade,
        "email": service.email
      });

      Get.snackbar(
        "Sucesso",
        "Seu serviço foi vinculado ao seu usuário",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.withOpacity(0.1),
        colorText: Colors.blue,
      );
    } catch (error) {
      Get.snackbar(
        "Error",
        "Algo deu errado. Tente novamente",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      // Use uma framework de logging em produção
      print("Erro ao criar serviço: $error");
    }
  }

  Stream<List<ServiceModel>> getUserServices() {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("Nenhum usuário está logado");
    }

    return _db
        .collection("Servicos")
        .where("email", isEqualTo: user.email)
        .snapshots()
        .map((QuerySnapshot query) {
      List<ServiceModel> services = [];
      for (var doc in query.docs) {
        services.add(ServiceModel.fromDocumentSnapshot(doc));
      }
      return services;
    });
  }
}

class ServiceRequestController extends GetxController {
  static ServiceRequestController get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> requestService(ServiceRequestModel service) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("Nenhum usuário está logado");
      }

      await _db.collection("SolicitacaoServico").add({
        "uid": user.uid,
        "descricao": service.descricao,
        "data": service.data,
        "horario": service.horario,
        "endereco": service.endereco,
        "emailCliente": service.emailCliente,
        "emailPrestador": service.emailPrestador,
      });

      Get.snackbar(
        "Sucesso",
        "Sua solicitação foi enviada ao prestador",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.withOpacity(0.1),
        colorText: Colors.blue,
      );
    } catch (error) {
      Get.snackbar(
        "Error",
        "Algo deu errado. Tente novamente",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      // Use uma framework de logging em produção
      print("Erro ao criar serviço: $error");
    }
  }

  Stream<List<ServiceRequestModel>> getUserServices() {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("Nenhum usuário está logado");
    }

    return _db
        .collection("SolicitacaoServico")
        .where("uid", isEqualTo: user.uid)
        .snapshots()
        .map((QuerySnapshot query) {
      List<ServiceRequestModel> services = [];
      for (var doc in query.docs) {
        services.add(ServiceRequestModel.fromDocumentSnapshot(doc));
      }
      return services;
    });
  }
}
