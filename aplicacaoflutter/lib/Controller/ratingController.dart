import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:servicocerto/Models/Service.dart';
import 'package:servicocerto/Models/ratingService.dart';
import 'package:servicocerto/Models/ratingService.dart';

class RatingServiceController extends GetxController {
  static RatingServiceController get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> rateService(RatingServiceModel service) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("Nenhum usuário está logado");
      }

      await _db.collection("AvaliacoesServico").add({
        "comment": service.comment,
        "date": service.date,
        "emailCliente": service.emailCliente,
        "emailPrestador": service.emailPrestador,
        "rating": service.rating,
        "serviceID": service.serviceID,
      });

      // Após adicionar a avaliação de serviço, atualize a avaliação do prestador
      await updatePrestadorRating(service.emailPrestador!);

      Get.snackbar(
        "Sucesso",
        "Sua avaliação foi enviada!",
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

  Future<void> updatePrestadorRating(String emailPrestador) async {
    try {
      // Buscar todas as avaliações do prestador
      QuerySnapshot querySnapshot = await _db
          .collection("AvaliacoesServico")
          .where("emailPrestador", isEqualTo: emailPrestador)
          .get();

      // Calcular a média das avaliações
      double totalRating = 0;
      int count = 0;
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        double rating = doc["rating"];
        totalRating += rating;
        count++;
        print("Rating: $rating, Count: $count, Email: $emailPrestador");
      }
      double averageRating = count > 0 ? totalRating / count : 0;
      print("Final Count: $count, Final Rating: $averageRating, Final Email: $emailPrestador");

      // Atualizar a média na tabela avaliacoesPrestador
      await _db.collection("AvaliacaoPrestador").doc(emailPrestador).set({
        "rating": averageRating,
        "ratingCount": count,
        "email": emailPrestador,
      });

      Get.snackbar(
        "Sucesso",
        "Avaliação do prestador atualizada com sucesso!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.withOpacity(0.1),
        colorText: Colors.blue,
      );
    } catch (error) {
      Get.snackbar(
        "Erro",
        "Ocorreu um erro ao atualizar a avaliação do prestador",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      print("Erro ao atualizar a avaliação do prestador: $error");
    }
  }

  Stream<UserRating?> getUserRating(String emailPrestador) {
    return _db
        .collection("AvaliacaoPrestador")
        .where("emailPrestador", isEqualTo: emailPrestador)
        .snapshots()
        .map((QuerySnapshot query) {
      if (query.docs.isNotEmpty) {
        return UserRating.fromDocumentSnapshot(query.docs.first);
      } else {
        return null;
      }
    });
  }

}
