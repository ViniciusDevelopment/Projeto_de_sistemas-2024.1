import 'package:cloud_firestore/cloud_firestore.dart'; // Adicione esta linha

class ServiceModel {
  String descricao;
  double valor;
  String disponibilidade;
  String email;

  ServiceModel({
    required this.descricao,
    required this.valor,
    required this.disponibilidade,
    required this.email,
  });

  factory ServiceModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return ServiceModel(
      descricao: doc['descricao'],
      valor: doc['valor'],
      disponibilidade: doc['disponibilidade'],
      email: doc['email']
    );
  }
}

class ServiceRequestModel {
  String descricao;
  String data;
  String horario;
  String endereco;
  String emailCliente;
  String emailPrestador;

  ServiceRequestModel({
    required this.descricao,
    required this.data,
    required this.horario,
    required this.endereco,
    required this.emailPrestador,
    required this.emailCliente,
  });

  String get email => emailCliente;

  factory ServiceRequestModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return ServiceRequestModel(
      descricao: doc['descricao'],
      data: doc['data'],
      horario: doc['horario'],
      endereco: doc['endereco'],
      emailCliente: doc['emailCliente'],
      emailPrestador: doc['emailPrestador']
    );
  }

}
