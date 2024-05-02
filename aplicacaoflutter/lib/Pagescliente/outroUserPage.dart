import 'DeleteAccountButton.dart';
import 'EditButton.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class outroUserPage extends StatefulWidget {
  final String email;

  const outroUserPage({Key? key, required this.email}) : super(key: key);

  @override
  _outroUserPageState createState() => _outroUserPageState();
}

class _outroUserPageState extends State<outroUserPage> {
  @override
  void initState() {
    super.initState();
    _performSearch(widget.email);
  }

  Future<void> _performSearch(String searchTerm) async {
    final CollectionReference usersRef =
        FirebaseFirestore.instance.collection('Users');

    final QuerySnapshot querySnapshot = await usersRef
        .where('Email', isEqualTo: searchTerm)
        .where('TipoUser', isEqualTo: 'Prestador')
        .get();

    // Atualize o estado com os resultados da consulta
    setState(() {
      // Aqui você pode acessar os resultados da consulta, como querySnapshot.docs
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
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration:
                  const BoxDecoration(color: Color.fromARGB(26, 192, 188, 188)),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
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
                  const Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Text(
                            'Dante',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      Padding(
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
/*
Future<void> _performSearch(String email) async {
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('Users');

  final QuerySnapshot querySnapshot =
      await usersRef.where('Email', isEqualTo: email).get();

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
}*/