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

      listaDeUsuarios.clear(); // Limpa a lista antes de adicionar novos dados

      for (QueryDocumentSnapshot prestadorDocument
          in prestadoresSnapshot.docs) {
        UserListImageDTO prestador =
            await _createUserListImageDTO(prestadorDocument, firestore);
        // Verificar se o prestador já está na lista para evitar duplicação
        if (!listaDeUsuarios.any((user) => user.email == prestador.email)) {
          listaDeUsuarios.add(prestador);
        }
      }

      listaDeUsuarios.sort(_compareByRating);
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

      listaDeUsuarios2.clear(); // Limpa a lista antes de adicionar novos dados

      for (QueryDocumentSnapshot prestadorDocument
          in prestadoresSnapshot.docs) {
        UserListImageDTO prestador = await _createUserListImageDTO(
            prestadorDocument, firestore,
            categoria: categoria);
        if (prestador.descricao.isNotEmpty &&
            !listaDeUsuarios2.any((user) => user.email == prestador.email)) {
          listaDeUsuarios2.add(prestador);
        }
      }

      listaDeUsuarios2.sort(_compareByRating);
      notifyListeners();
      return listaDeUsuarios2;
    } catch (e) {
      print('Erro ao buscar usuários: $e');
      return [];
    }
  }

  Future<UserListImageDTO> _createUserListImageDTO(
      QueryDocumentSnapshot prestadorDocument, FirebaseFirestore firestore,
      {String? categoria}) async {
    String email = prestadorDocument['Email'];
    Map<String, dynamic> data =
        prestadorDocument.data() as Map<String, dynamic>;

    QuerySnapshot servicosSnapshot;
    if (categoria != null) {
      servicosSnapshot = await firestore
          .collection('Servicos')
          .where('email', isEqualTo: email)
          .where('categoria', isEqualTo: categoria)
          .get();
    } else {
      servicosSnapshot = await firestore
          .collection('Servicos')
          .where('email', isEqualTo: email)
          .get();
    }

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

    DocumentSnapshot avaliacoesSnapshot =
        await firestore.collection('AvaliacaoPrestador').doc(email).get();
    double averageRating = 0;
    int ratingCount = 0;
    if (avaliacoesSnapshot.exists) {
      averageRating = avaliacoesSnapshot['rating'];
      ratingCount = avaliacoesSnapshot['ratingCount'];
    }

    return UserListImageDTO(
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
      rating: averageRating,
      ratingCount: ratingCount,
    );
  }

  int _compareByRating(UserListImageDTO a, UserListImageDTO b) {
    if (a.rating != null && b.rating != null) {
      return b.rating!.compareTo(a.rating!);
    } else if (a.rating == null && b.rating != null) {
      return 1; // Se a.rating for nulo, b.rating vem primeiro
    } else if (a.rating != null && b.rating == null) {
      return -1; // Se b.rating for nulo, a.rating vem primeiro
    } else {
      return 0; // Se ambos forem nulos, são considerados iguais
    }
  }
}
