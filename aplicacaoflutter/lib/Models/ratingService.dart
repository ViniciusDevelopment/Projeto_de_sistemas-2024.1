import 'package:cloud_firestore/cloud_firestore.dart'; // Adicione esta linha

class RatingServiceModel {
  double rating; // Use double em vez de Double
  String? comment;
  DateTime date; // Use DateTime para datas
  String? emailCliente;
  String? emailPrestador;
  String? serviceID;

  RatingServiceModel({
    required this.rating,
    required this.comment,
    required this.date,
    this.emailCliente,
    this.emailPrestador,
    required this.serviceID
  });

  factory RatingServiceModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return RatingServiceModel(
      rating: doc['rating'],
      comment: doc['comment'],
      date: doc['date'],
      emailCliente: doc['emailCliente'],
      emailPrestador: doc['emailPrestador'],
      serviceID: doc['serviceID']
    );
  }
}

