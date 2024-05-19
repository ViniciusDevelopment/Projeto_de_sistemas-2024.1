import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servicocerto/Controller/ServiceController.dart';
import 'package:servicocerto/Models/Service.dart';
import 'package:servicocerto/Pagescliente/CadastrarservicoPage.dart';

final _db = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

Stream<List<ServiceModel>> getUserServices() {
  User? user = _auth.currentUser;
  if (user == null) {
    throw Exception("Nenhum usuário está logado");
  }

  return _db
      .collection("Servicos")
      .where("uid", isEqualTo: user.uid)
      .snapshots()
      .map((QuerySnapshot query) {
    List<ServiceModel> services = [];
    for (var doc in query.docs) {
      services.add(ServiceModel.fromDocumentSnapshot(doc));
    }
    return services;
  });
}


String? getUserEmail() {
  User? user = _auth.currentUser;
  if (user == null) {
    throw Exception("Nenhum usuário está logado");
  }

  return user.email;
}

class MeusServicosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Meus Serviços', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff0095FF),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              // Navega para a página "EditarPerfil.dart" quando o contêiner for clicado
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ServiceRegistrationPage(email: getUserEmail()!)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                // width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xff0095FF),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: Color(0xff0095FF),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Cadastrar Serviço',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          color: Color(0xff0095FF),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<List<ServiceModel>>(
              stream: ServiceController.instance.getUserServices(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Erro ao carregar serviços"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("Nenhum serviço encontrado"));
                }

                List<ServiceModel> services = snapshot.data!;
                return ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    ServiceModel service = services[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        title: Text(service.descricao),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Valor: ${service.valor.toString()} reais'),
                            Text('Disponibilidade: ${service.disponibilidade}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

