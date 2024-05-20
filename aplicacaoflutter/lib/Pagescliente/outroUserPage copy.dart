// Este é o código da página que exibe o perfil de outro usuário,
// baseado no email fornecido.

// Importações necessárias
import '../Components/DeleteAccountButton.dart';
import '../Components/EditButton.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Widget Stateful para a página do perfil do outro usuário
class outroUserPage extends StatefulWidget {
  final String email; // Email do usuário a ser exibido

  const outroUserPage({Key? key, required this.email}) : super(key: key);

  @override
  _outroUserPageState createState() => _outroUserPageState();
}

class _outroUserPageState extends State<outroUserPage> {
  late List<Record>
      _simpleSearchResults; // Lista para armazenar os resultados da busca

  @override
  void initState() {
    super.initState();
    _simpleSearchResults = [];
    _performSearch(widget.email); // Executa a busca ao inicializar a página
  }

  // Função para buscar os dados do usuário no Firestore
  Future<void> _performSearch(String searchTerm) async {
    final CollectionReference usersRef =
        FirebaseFirestore.instance.collection('Users');

    final QuerySnapshot querySnapshot = await usersRef
        .where('Email', isEqualTo: searchTerm)
        .where('TipoUser', isEqualTo: 'Prestador')
        .get();

    // Atualize o estado com os resultados da consulta
    setState(() {
      _simpleSearchResults = querySnapshot.docs.map((doc) {
        return Record(
          Name: doc['Name'],
          Telefone: doc['Telefone'],
          Email: doc['Email'],
          Endereco: doc['Endereco'],
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: AlignmentDirectional(0, 0),
          child: Text(
            "Perfil do Prestador",
            style: TextStyle(
              fontFamily: 'Outfit',
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 0,
            ),
          ),
        ),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
        actions: [],
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Exibição dos dados do usuário
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration:
                  const BoxDecoration(color: Color.fromARGB(26, 192, 188, 188)),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Exibição da foto de perfil
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                    child: Container(
                      width: 100,
                      height: 100,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network('https://picsum.photos/seed/34/600',
                          fit: BoxFit.cover),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Text(
                            _simpleSearchResults.isNotEmpty
                                ? _simpleSearchResults[0].Name
                                : '',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                          child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5, 0, 0, 0),
                                  child: Text(
                                    '50 avaliações',
                                    style: TextStyle(
                                      fontFamily: 'Readex Pro',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ])),
                    ],
                  )
                ],
              ),
            ),
            // Botões de ação (Contratar, Serviços)
            Container(
                width: double.infinity,
                height: 122,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(26, 192, 188, 188)),
                child: const Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 1),
                        child: ElevatedButton(
                          onPressed: null,
                          style: ButtonStyle(
                            minimumSize: MaterialStatePropertyAll(
                                Size(double.infinity, 60)),
                            padding: MaterialStatePropertyAll(
                                EdgeInsets.symmetric(horizontal: 24)),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue),
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.white),
                            textStyle: MaterialStatePropertyAll(
                              TextStyle(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          child: Text("Contratar",
                              style: TextStyle(
                                color: Colors
                                    .white, // Define a cor do texto como branco
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                        )),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 1),
                          child: ElevatedButton(
                              onPressed: null,
                              style: ButtonStyle(
                                minimumSize: MaterialStatePropertyAll(
                                    Size(double.infinity, 60)),
                                padding: MaterialStatePropertyAll(
                                    EdgeInsets.symmetric(horizontal: 24)),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.blue),
                                textStyle: MaterialStatePropertyAll(
                                  TextStyle(
                                      fontFamily: 'Readex Pro',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                side: MaterialStatePropertyAll(
                                  BorderSide(
                                    color: Colors.blue, // Cor da borda
                                    width: 2, // Largura da borda
                                  ),
                                ),
                              ),
                              child: Text(
                                "Serviços",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )),
                        )
                      ],
                    )
                  ],
                )),
            // Exibição dos serviços prestados pelo usuário
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
              child: Container(
                width: double.infinity,
                height: 433,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(26, 192, 188, 188)),
                child: ListView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 5, 8, 5),
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 4,
                                color: Color(0x33000000),
                                offset: Offset(0, 2))
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: const AlignmentDirectional(0, -1),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1575467678930-c7acd65d6470?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw2fHxob3VzZWtlZXBlcnxlbnwwfHx8fDE3MTM1NjY3MDN8MA&ixlib=rb-4.0.3&q=80&w=1080',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 5, 0, 0),
                                    child: Text(
                                      'Sandra',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: 'Readex Pro',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //adicionar avaliações
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 0),
                                          child: Text(
                                            'avaliação',
                                            style: TextStyle(
                                              fontFamily: 'Readex Pro',
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                    child: Text(
                                      'Data: Segunda, 08/04',
                                      style: TextStyle(
                                        fontFamily: 'Readex Pro',
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 5),
                                    child: Text(
                                      'Cliente: Dona Maria',
                                      style: TextStyle(
                                        fontFamily: 'Readex Pro',
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Função de busca no Firestore
Future<void> _performSearch(String email) async {
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('Users');

  final QuerySnapshot querySnapshot =
      await usersRef.where('Email', isEqualTo: email).get();
}

// Classe para armazenar os dados do usuário
class Record {
  final String Name;
  final String Telefone;
  final String Email;
  final String Endereco;

  Record({
    required this.Name,
    required this.Telefone,
    required this.Email,
    required this.Endereco,
  });
}
//testeeeee