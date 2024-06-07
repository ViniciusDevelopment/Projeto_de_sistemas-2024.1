import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:servicocerto/DTO/Response/UserListImageDTO.dart';

class UserRepository extends ChangeNotifier {
  List<UserListImageDTO> listaDeUsuarios = [];
  UserRepository();

  Future<List<UserListImageDTO>> fetchUsers() async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot prestadoresSnapshot = await firestore
        .collection('Users')
        .where('TipoUser', isEqualTo: 'Prestador')
        .get();

    Map<String, List<Map<String, dynamic>>> prestadoresServicos = {};
    Map<String, double> prestadoresRating = {};

    // Obter avaliações de cada prestador
    for (QueryDocumentSnapshot prestadorDocument in prestadoresSnapshot.docs) {
      String email = prestadorDocument['Email'];

      QuerySnapshot servicosSnapshot = await FirebaseFirestore.instance
          .collection('Servicos')
          .where('email', isEqualTo: email)
          .get();

      List<Map<String, dynamic>> servicos = [];

      for (QueryDocumentSnapshot servicoDocument in servicosSnapshot.docs) {
        servicos.add(servicoDocument.data() as Map<String, dynamic>);
      }

      prestadoresServicos[email] = servicos;

      // Calcular a média das avaliações
      QuerySnapshot avaliacoesSnapshot = await firestore
          .collection('AvaliacaoPrestador')
          .where('email', isEqualTo: email)
          .get();

      double totalRating = 0;
      int ratingCount = 0;

      for (QueryDocumentSnapshot avaliacaoDocument in avaliacoesSnapshot.docs) {
        totalRating += avaliacaoDocument['rating'];
        ratingCount++;
      }

      double averageRating = ratingCount > 0 ? totalRating / ratingCount : 0;
      prestadoresRating[email] = averageRating;
    }

    listaDeUsuarios.clear();

    for (QueryDocumentSnapshot prestadorDocument in prestadoresSnapshot.docs) {
      String email = prestadorDocument['Email'];
      Map<String, dynamic> data = prestadorDocument.data() as Map<String, dynamic>;

      List<Map<String, dynamic>>? servicos = prestadoresServicos[email];

       num totalValor = 0;

       if (servicos != null && servicos.isNotEmpty) {
          for (var servico in servicos) {
            totalValor += servico['valor'] as num;
          }
        }


      UserListImageDTO prestador = UserListImageDTO(
        name: data['Name'],
        email: data['Email'],
        tipoUser: data['TipoUser'],
        photoURL: data.containsKey('photoURL') ? data['photoURL'] : null,
        descricao: servicos != null && servicos.isNotEmpty
            ? servicos.map((servico) => servico['descricao']).join(', ')
            : "Sem descrição disponível",
        disponibilidade: servicos != null && servicos.isNotEmpty
            ? servicos.map((servico) => servico['disponibilidade']).join(', ')
            : "Sem disponibilidade",
        valor: totalValor,
        rating: prestadoresRating[email] ?? 0, // Usando a média de rating calculada
      );

      // Adicionar o prestador à lista
      listaDeUsuarios.add(prestador);
    }

     listaDeUsuarios.sort((a, b) {
      if (a.rating != null && b.rating != null) {
        return b.rating!.compareTo(a.rating!);
      } else if (a.rating == null && b.rating != null) {
        return 1; // Se a.rating for nulo, b.rating vem primeiro
      } else if (a.rating != null && b.rating == null) {
        return -1; // Se b.rating for nulo, a.rating vem primeiro
      } else {
        return 0; // Se ambos forem nulos, são considerados iguais
      }
    });

    notifyListeners();

    return listaDeUsuarios;
  } catch (e) {
    print('Erro ao buscar usuários: $e');
    return [];
  }
}


}
