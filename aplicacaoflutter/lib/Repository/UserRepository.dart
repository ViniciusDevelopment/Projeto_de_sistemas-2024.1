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
      );

      // Adicionar o prestador à lista
      listaDeUsuarios.add(prestador);
    }

    notifyListeners();

    return listaDeUsuarios;
  } catch (e) {
    print('Erro ao buscar usuários: $e');
    return [];
  }
}

}
