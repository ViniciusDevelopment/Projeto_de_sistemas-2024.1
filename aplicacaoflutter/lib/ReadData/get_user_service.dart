import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetUserService extends StatelessWidget {
  final String email;

  const GetUserService({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference servicos = FirebaseFirestore.instance.collection('Servicos');

    return StreamBuilder<QuerySnapshot>(
      stream: servicos.where('email', isEqualTo: email).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Carregando...');
        }
        if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('Nenhum serviço encontrado');
        }
        
        final servicosData = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        return ListView.builder(
          shrinkWrap: true,
          itemCount: servicosData.length,
          itemBuilder: (context, index) {
            final servico = servicosData[index];
            return ListTile(
              title: Text('Descrição: ${servico['descricao']}'),
              subtitle: Text('Disponibilidade: ${servico['disponibilidade']} \nValor: ${servico['valor']}'),
            );
          },
        );
      },
    );
  }
}
