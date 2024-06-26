import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  String id;
  String descricao;
  double valor;
  String disponibilidade;
  String? email;
  String categoria;

  ServiceModel({
    required this.id,
    required this.descricao,
    required this.valor,
    required this.disponibilidade,
    this.email,
    required this.categoria,
  });

  factory ServiceModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return ServiceModel(
      id: doc.id,
      descricao: doc['descricao'],
      valor: (doc['valor'] as num).toDouble(),
      disponibilidade: doc['disponibilidade'],
      email: doc['email'],
      categoria: doc['categoria'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'valor': valor,
      'disponibilidade': disponibilidade,
      'email': email,
      'categoria': categoria,
    };
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
      emailPrestador: doc['emailPrestador'],
    );
  }
}
