import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:servicocerto/Controller/ServiceController.dart';
import 'package:servicocerto/Models/Service.dart';
import 'package:servicocerto/Pagesdiarista/CadastrarservicoPage.dart';
import 'package:servicocerto/Pagesdiarista/ServiceEditPage.dart';

final _auth = FirebaseAuth.instance;

String? getUserEmail() {
  User? user = _auth.currentUser;
  if (user == null) {
    throw Exception("Nenhum usuário está logado");
  }
  return user.email;
}

class MeusServicosPage extends StatelessWidget {
  const MeusServicosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Meus Serviços', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff0095FF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ServiceRegistrationPage(email: getUserEmail()!),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xff0095FF),
                    width: 2,
                  ),
                ),
                child: const Center(
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
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<List<ServiceModel>>(
              stream: ServiceController.instance.getUserServices(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child:
                          Text("Erro ao carregar serviços: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Nenhum serviço encontrado"));
                }

                List<ServiceModel> services = snapshot.data!;
                return ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    ServiceModel service = services[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        title: Text(service.descricao),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Valor: R\$ ${service.valor.toString()}'),
                            Text('Disponibilidade: ${service.disponibilidade}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ServiceEditPage(service: service),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                bool? confirmDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Confirmar Exclusão'),
                                      content: const Text(
                                          'Deseja realmente excluir este serviço?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text('Excluir'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirmDelete == true) {
                                  ServiceController.instance
                                      .deleteService(service.id);
                                }
                              },
                            ),
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
