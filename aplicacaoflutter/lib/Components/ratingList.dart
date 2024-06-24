import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingList extends StatelessWidget {
  final String emailPrestador;
  const RatingList({super.key, required this.emailPrestador});

  Future<List<Map<String, dynamic>>> _getAvaliacoes() async {
    // Print para verificação do emailPrestador
    print('Email do Prestador: $emailPrestador');

    final CollectionReference ratingServices =
        FirebaseFirestore.instance.collection('AvaliacoesServico');
    final QuerySnapshot querySnapshotServices = await ratingServices
        .where('emailPrestador', isEqualTo: emailPrestador)
        .get();

    if (querySnapshotServices.docs.isNotEmpty) {
      final List<Map<String, dynamic>> avaliacoes = [];

      for (var doc in querySnapshotServices.docs) {
        Map<String, dynamic> avaliacao = doc.data() as Map<String, dynamic>;
        String clienteEmail = avaliacao['emailCliente'];
        Map<String, dynamic> clienteInfo = await _getUserInfo(clienteEmail);
        avaliacao['clienteInfo'] = clienteInfo;
        avaliacoes.add(avaliacao);
      }

      // Print para verificação da lista de avaliações
      print('Avaliações encontradas: $avaliacoes');
      return avaliacoes;
    }

    // Print caso não haja avaliações
    print('Nenhuma avaliação encontrada para o prestador $emailPrestador');
    return [];
  }

  Future<Map<String, dynamic>> _getUserInfo(String emailCliente) async {
    // Print para verificação do emailCliente
    print('Email do Cliente: $emailCliente');

    final CollectionReference usersRef =
        FirebaseFirestore.instance.collection('Users');
    final QuerySnapshot querySnapshot =
        await usersRef.where('Email', isEqualTo: emailCliente).get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data() as Map<String, dynamic>;
    }

    // Print caso não haja informações do cliente
    print('Nenhuma informação encontrada para o cliente $emailCliente');
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getAvaliacoes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhuma avaliação encontrada'));
        } else {
          final avaliacoes = snapshot.data!;

          // Print para verificação dos dados dentro do builder
          print('Avaliações no FutureBuilder: $avaliacoes');

          return ListView.builder(
            itemCount: avaliacoes.length,
            itemBuilder: (context, index) {
              final avaliacao = avaliacoes[index];
              final clienteInfo = avaliacao['clienteInfo'];

              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white, // Define a cor de fundo branca
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.white,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                width: 80,
                                height: 80,
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: clienteInfo != null &&
                                        clienteInfo['photoURL'] != null
                                    ? Image.network(
                                        clienteInfo['photoURL']!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        'https://firebasestorage.googleapis.com/v0/b/servicocerto-2dbd7.appspot.com/o/user_profiles%2FLd665bCE4mUm9iByxcfiWoj59Vp2.jpg?alt=media&token=66283b00-cd30-4052-8c98-66de951a136f',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5, left: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      clienteInfo != null
                                          ? clienteInfo['Name'] ??
                                              'Nome não disponível'
                                          : 'Nome não disponível',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          'Avaliação: ${(avaliacao['rating'] as num).toDouble()}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 5),
                                        RatingBarIndicator(
                                          rating: (avaliacao['rating'] as num)
                                              .toDouble(),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 20.0,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    if (avaliacao['comment'] != null &&
                                        avaliacao['comment'].isNotEmpty)
                                      Text(
                                        'Comentário: ${avaliacao['comment']}',
                                        style: const TextStyle(
                                            color: Colors.black54),
                                      ),
                                    if (avaliacao['comment'] == null ||
                                        avaliacao['comment'].isEmpty)
                                      const Text(
                                        'Sem comentário',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Data: ${avaliacao['date'].toDate()}',
                                      style: const TextStyle(
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
