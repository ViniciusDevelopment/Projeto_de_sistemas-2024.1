import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RatingList extends StatelessWidget {
  final String searchTerm;
  final List<Map<String, dynamic>> avaliacoes;

  const RatingList(
      {Key? key, required this.searchTerm, required this.avaliacoes})
      : super(key: key);

  Future<List<Map<String, dynamic>>> _getAvaliacoes() async {
    final CollectionReference ratingServices =
        FirebaseFirestore.instance.collection('AvaliacoesServico');
    final QuerySnapshot querySnapshotServices = await ratingServices
        .where('emailPrestador', isEqualTo: searchTerm)
        .get();
    if (querySnapshotServices.docs.isNotEmpty) {
      return querySnapshotServices.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getAvaliacoes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhuma avaliação encontrada'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final avaliacao = snapshot.data![index];
              return ListTile(
                title: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Avaliação: ${avaliacao['avaliacao']}'),
                      Text('Prestador: ${avaliacao['emailPrestador']}'),
                      Text('Data: ${avaliacao['data']}'),
                      Text('Hora: ${avaliacao['hora']}'),
                      Text('Valor: ${avaliacao['valor']}'),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
