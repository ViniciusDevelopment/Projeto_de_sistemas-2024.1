import 'package:cloud_firestore/cloud_firestore.dart'; // Adicione esta linha

class ServiceModel {
  String descricao;
  double valor;
  String disponibilidade;

  ServiceModel({
    required this.descricao,
    required this.valor,
    required this.disponibilidade,
  });

  factory ServiceModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return ServiceModel(
      descricao: doc['descricao'],
      valor: doc['valor'],
      disponibilidade: doc['disponibilidade'],
    );
  }
}
