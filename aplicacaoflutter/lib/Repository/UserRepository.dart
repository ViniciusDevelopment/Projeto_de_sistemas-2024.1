import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:servicocerto/DTO/Response/UserListImageDTO.dart';

class UserRepository extends ChangeNotifier {
  List<UserListImageDTO> listaDeUsuarios = [];
  List<UserListImageDTO> listaDeUsuarios2 = [];
  UserRepository();

  Future<List<UserListImageDTO>> fetchUsers() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot prestadoresSnapshot = await firestore
          .collection('Users')
          .where('TipoUser', isEqualTo: 'Prestador')
          .get();

      listaDeUsuarios.clear();

      for (QueryDocumentSnapshot prestadorDocument
          in prestadoresSnapshot.docs) {
        String email = prestadorDocument['Email'];
        Map<String, dynamic> data =
            prestadorDocument.data() as Map<String, dynamic>;

        // Obter serviços do prestador
        QuerySnapshot servicosSnapshot = await firestore
            .collection('Servicos')
            .where('email', isEqualTo: email)
            .get();

        List<Map<String, dynamic>> servicos = [];

        for (QueryDocumentSnapshot servicoDocument in servicosSnapshot.docs) {
          servicos.add(servicoDocument.data() as Map<String, dynamic>);
        }

        num totalValor = 0;

        if (servicos.isNotEmpty) {
          for (var servico in servicos) {
            totalValor += servico['valor'] as num;
          }
        }

        // Obter avaliações do prestador
        DocumentSnapshot avaliacoesSnapshot =
            await firestore.collection('AvaliacaoPrestador').doc(email).get();

        double averageRating = 0;
        int ratingCount = 0;
        if (avaliacoesSnapshot.exists) {
          averageRating = avaliacoesSnapshot['rating'];
          ratingCount = avaliacoesSnapshot['ratingCount'];
        }

        UserListImageDTO prestador = UserListImageDTO(
          name: data['Name'],
          email: data['Email'],
          tipoUser: data['TipoUser'],
          photoURL: data.containsKey('photoURL') ? data['photoURL'] : null,
          descricao: servicos.isNotEmpty
              ? servicos.map((servico) => servico['descricao']).join(', ')
              : "Sem descrição disponível",
          disponibilidade: servicos.isNotEmpty
              ? servicos.map((servico) => servico['disponibilidade']).join(', ')
              : "Sem disponibilidade",
          valor: totalValor,
          rating: averageRating, // Usando a média de rating do BD
          ratingCount: ratingCount, // Usando o count de rating do BD
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

  Future<List<UserListImageDTO>> fetchUsersCategoria(String categoria) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot prestadoresSnapshot = await firestore
          .collection('Users')
          .where('TipoUser', isEqualTo: 'Prestador')
          .get();

      listaDeUsuarios2.clear();

      for (QueryDocumentSnapshot prestadorDocument
          in prestadoresSnapshot.docs) {
        String email = prestadorDocument['Email'];
        Map<String, dynamic> data =
            prestadorDocument.data() as Map<String, dynamic>;

        // Obter serviços do prestador
        QuerySnapshot servicosSnapshot = await firestore
            .collection('Servicos')
            .where('email', isEqualTo: email)
            .where('categoria', isEqualTo: categoria) // Filtro por categoria
            .get();

        List<Map<String, dynamic>> servicos = [];

        for (QueryDocumentSnapshot servicoDocument in servicosSnapshot.docs) {
          servicos.add(servicoDocument.data() as Map<String, dynamic>);
        }

        if (servicos.isEmpty) {
          continue; // Pular prestadores que não têm serviços na categoria
        }

        num totalValor = 0;

        for (var servico in servicos) {
          totalValor += servico['valor'] as num;
        }

        // Obter avaliações do prestador
        DocumentSnapshot avaliacoesSnapshot =
            await firestore.collection('AvaliacaoPrestador').doc(email).get();

        double averageRating = 0;
        int ratingCount = 0;
        if (avaliacoesSnapshot.exists) {
          averageRating = avaliacoesSnapshot['rating'];
          ratingCount = avaliacoesSnapshot['ratingCount'];
        }

        UserListImageDTO prestador = UserListImageDTO(
          name: data['Name'],
          email: data['Email'],
          tipoUser: data['TipoUser'],
          photoURL: data.containsKey('photoURL') ? data['photoURL'] : null,
          descricao: servicos.map((servico) => servico['descricao']).join(', '),
          disponibilidade:
              servicos.map((servico) => servico['disponibilidade']).join(', '),
          valor: totalValor,
          rating: averageRating, // Usando a média de rating do BD
          ratingCount: ratingCount, // Usando o count de rating do BD
        );

        // Adicionar o prestador à lista
        listaDeUsuarios2.add(prestador);
      }

      listaDeUsuarios2.sort((a, b) {
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

      return listaDeUsuarios2;
    } catch (e) {
      print('Erro ao buscar usuários: $e');
      return [];
    }
  }
}
