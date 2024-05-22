import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModelDTO {
  String id;
  String descricao;
  double valor;
  String disponibilidade;
  String email;

  ServiceModelDTO({
    required this.id,
    required this.descricao,
    required this.valor,
    required this.disponibilidade,
    required this.email,
  });

  factory ServiceModelDTO.fromDocumentSnapshot(DocumentSnapshot doc) {
    return ServiceModelDTO(
      id: doc.id, // Usando o ID do documento
      descricao: doc['descricao'],
      valor: doc['valor'],
      disponibilidade: doc['disponibilidade'],
      email: doc['email']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'valor': valor,
      'disponibilidade': disponibilidade,
      'email': email,
    };
  }
}
