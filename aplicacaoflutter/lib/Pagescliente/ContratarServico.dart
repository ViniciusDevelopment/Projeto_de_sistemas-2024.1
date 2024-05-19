import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import necessário para FilteringTextInputFormatter
import 'package:get/get.dart';
import 'package:servicocerto/Controller/ServiceController.dart'; // Import corrigido para minúsculas
import 'package:servicocerto/Models/Service.dart'; // Import corrigido para minúsculas
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRequestPage extends StatefulWidget {
  final String email;

  const ServiceRequestPage({super.key, required this.email}); // Adicionado key

  @override
  _ServiceRequestPageState createState() => _ServiceRequestPageState();
}

class _ServiceRequestPageState extends State<ServiceRequestPage> {
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _horarioController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();

  late String emailCliente;

  void _getEmail() async {
    // Obtenha o usuário atualmente autenticado
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      emailCliente = user.email!;
      print('Email do usuário atual: $emailCliente');
    } else {
      print('Nenhum usuário está autenticado');
    }
  }


  void _contratarServico() {
    String descricao = _descricaoController.text.trim();
    String data = _dataController.text.trim();
    String horario = _horarioController.text.trim();
    String endereco = _enderecoController.text.trim();

    if (descricao.isNotEmpty &&
        data.isNotEmpty &&
        horario.isNotEmpty && endereco.isNotEmpty) {
      ServiceRequestModel service = ServiceRequestModel(
        descricao: descricao,
        data: data,
        horario: horario,
        endereco: endereco,
        emailCliente: emailCliente,
        emailPrestador: widget.email
      );
      ServiceRequestController.instance.requestService(service);

      Navigator.pop(context);
    } else {
      Get.snackbar(
        "Erro",
        "Por favor, preencha todos os campos.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  //Obter dados do firebase
  late List<Record>
      _simpleSearchResults; // Lista para armazenar os resultados da busca

  @override
  void initState() {
    super.initState();
    _getEmail();
    Get.put(ServiceRequestController());
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
        backgroundColor: const Color.fromARGB(255, 45, 96, 234),
        automaticallyImplyLeading: true,
        actions: const [],
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
              child: IntrinsicHeight(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 5, 8, 5),
                  decoration:
                      BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x33000000),
                            offset: Offset(0, 2))
                        ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Exibição da foto de perfil
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                        child: Container(
                          width: 110,
                          height: 110,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.network('https://picsum.photos/seed/34/600',
                              fit: BoxFit.cover),
                        ),
                      ),
                      Padding(padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                        child: Column(
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
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
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
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ])),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 10), // Adicionado const
              child: Container(
                decoration:
                BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x33000000),
                            offset: Offset(0, 2))
                        ],
                        borderRadius: BorderRadius.circular(15),
                      ), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(padding: const EdgeInsetsDirectional.fromSTEB(40, 10, 40, 5),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: const Center(
                          child: Text(
                            'Contratar Serviço',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 45, 96, 234),
                              fontSize: 16,
                              fontWeight: FontWeight.w800
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: const EdgeInsetsDirectional.fromSTEB(40, 10, 40, 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x33000000),
                              offset: Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: _descricaoController,
                          decoration: const InputDecoration(
                              labelText: 'Descrição do Serviço',
                              labelStyle: TextStyle(
                              color: Colors.grey, // Ajuste a cor conforme necessário
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                            ), 
                        ),
                      ),
                    ),
                    Padding(padding: const EdgeInsetsDirectional.fromSTEB(40, 5, 40, 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x33000000),
                              offset: Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: _dataController,
                          decoration: const InputDecoration(
                              labelText: 'Data',
                              labelStyle: TextStyle(
                              color: Colors.grey, // Ajuste a cor conforme necessário
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                            ), // Adicionado const
                        ),
                      ),
                    ),
                    Padding(padding: const EdgeInsetsDirectional.fromSTEB(40, 5, 40, 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x33000000),
                              offset: Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15),
                        ),
                      child: TextField(
                        controller: _horarioController,
                        decoration: const InputDecoration(
                          labelText: 'Horário',
                          labelStyle: TextStyle(
                            color: Colors.grey, // Ajuste a cor conforme necessário
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        ), 
                            
                            // Adicionado const
                      ),
                    ),
                  ),
                  Padding(padding: const EdgeInsetsDirectional.fromSTEB(40, 10, 40, 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x33000000),
                              offset: Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15),
                        ),
                      child: TextField(
                        controller: _enderecoController,
                        decoration: const InputDecoration(
                            labelText: 'Endereço',
                            labelStyle: TextStyle(
                              color: Colors.grey, // Ajuste a cor conforme necessário
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                            ),
                      ),
                    ),
                  ),
                    const SizedBox(height: 20.0), // Adicionado const
                    Padding(padding: const EdgeInsetsDirectional.fromSTEB(40, 10, 40, 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 45, 96, 234),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x33000000),
                              offset: Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ElevatedButton(
                          onPressed: _contratarServico,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 45, 96, 234), // Cor de fundo
                            foregroundColor: Colors.white, 
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),// Cor do texto
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text('Solicitar'), // Adicionado const
                        ),
                      ),
                    ),
                    Padding(padding: const EdgeInsetsDirectional.fromSTEB(40, 10, 40, 10),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Voltar para a página anterior
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          foregroundColor: Colors.white, // Cor do texto
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // Texto em negrito
                            color: Colors.red, // Cor do texto
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]
        ),
      ),
    );
        
  }
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