import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Import necessário para FilteringTextInputFormatter
import 'package:intl/intl.dart';
// Import corrigido para minúsculas
import 'package:servicocerto/DTO/Request/ServiceDTO.dart';
import 'package:servicocerto/DTO/Response/UserImageDTO.dart';
// Import corrigido para minúsculas
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servicocerto/Models/SolicitarServico.dart';
import 'package:servicocerto/Models/User.dart';
import 'package:servicocerto/Pagescliente/cleaning.dart';
import 'package:servicocerto/Services/notification_service.dart';

class ContratarServicoPage extends StatefulWidget {
  final String email;

  const ContratarServicoPage({super.key, required this.email});

  @override
  _ContratarServicoPageState createState() => _ContratarServicoPageState();
}

class _ContratarServicoPageState extends State<ContratarServicoPage> {
  UserImageDTO? _simpleSearchResults;
  final NotificationService notificationService = NotificationService();
  late String emailCliente;
  final _db = FirebaseFirestore.instance;
  final _dataController = TextEditingController();
  final _horarioController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  late UserModel? _userData;

  DateTime _parseDate(String dateStr) {
  try {
    return DateFormat('dd-MM-yyyy').parse(dateStr);
  } catch (e) {
    print('Invalid date format: $e');
    //retornar dia de hoje
    return DateTime.now();
  }
}

DateTime _parseTime(String timeStr) {
  try {
    return DateFormat('HH:mm').parse(timeStr);
  } catch (e) {
    print('Invalid time format: $e');
      return DateTime.now();

  }
}

  void _getEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emailCliente = user.email!;
    }
  }

  Stream<List<ServiceModelDTO>> getServices(email) {
    return _db
        .collection("Servicos")
        .where("email", isEqualTo: email)
        .snapshots()
        .map((QuerySnapshot query) {
      List<ServiceModelDTO> services = [];
      for (var doc in query.docs) {
        services.add(ServiceModelDTO.fromDocumentSnapshot(doc));
      }
      return services;
    });
  }

  @override
  void initState() {
    super.initState();
    _getEmail();
    _fetchUserData();
    _performSearch(widget.email);
  }

  void _contratarServico(SolicitarServico solicitarServico,
      NotificationService notificationService) async {
    try {
      await FirebaseFirestore.instance
          .collection('SolicitacoesServico')
          .add(solicitarServico.toJson());

      // notificationService.showLocalNotification(
      //   CustomNotification(
      //     id: DateTime.now().millisecondsSinceEpoch,
      //     title: 'Serviço Solicitado',
      //     body: 'Novo Serviço solicitado.',
      //     payload: '',
      //   ),
      // );
    } catch (error) {
      print('Erro ao contratar o serviço: $error');
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection("Users")
          .where("Email", isEqualTo: widget.email)
          .where('TipoUser', isEqualTo: 'Prestador')
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userData = userQuery.docs.first.data() as Map<String, dynamic>;
        setState(() {
          _userData = UserModel(
            name: userData['Name'] ?? '',
            email: userData['Email'] ?? '',
            cpf: userData['Cpf'] ?? '',
            telefone: userData['Telefone'] ?? '',
            password: userData['Password'] ?? '',
            endereco: userData['Endereco'] ?? '',
            tipoUser: userData['TipoUser'] ?? '',
          );
        });
      }
    } catch (error) {
      print("Error fetching user data: $error");
    }
  }

  Future<void> _performSearch(String searchTerm) async {
    try {
      final CollectionReference usersRef =
          FirebaseFirestore.instance.collection('Users');

      final QuerySnapshot querySnapshot = await usersRef
          .where('Email', isEqualTo: searchTerm)
          .where('TipoUser', isEqualTo: 'Prestador')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        final user = UserImageDTO.fromJson(userData);

        print("!@@@#####&&&&&");
        print(user);

        setState(() {
          _simpleSearchResults = user;
        });
      } else {
        print('Nenhum usuário encontrado.');
      }
    } catch (error) {
      print("Erro ao buscar dados do usuário: $error");
      setState(() {
        _simpleSearchResults = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
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
      ),
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IntrinsicHeight(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(0, 2),
                      )
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          width: 110,
                          height: 110,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: _simpleSearchResults != null
                              ? (_simpleSearchResults!.photoURL != null
                                  ? Image.network(
                                      _simpleSearchResults!.photoURL!,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      'https://www.shutterstock.com/image-vector/blank-avatar-photo-place-holder-600nw-1095249842.jpg',
                                      fit: BoxFit.cover,
                                    ))
                              : Image.network(
                                  'https://www.shutterstock.com/image-vector/blank-avatar-photo-place-holder-600nw-1095249842.jpg',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _simpleSearchResults != null
                                    ? _simpleSearchResults!.name
                                    : 'Nenhum usuário encontrado.',
                                style: const TextStyle(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Sem avaliações 1',
                                      style: TextStyle(
                                        fontFamily: 'Readex Pro',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 10),
              child: Container(
                decoration: BoxDecoration(
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder<List<ServiceModelDTO>>(
                        stream: getServices(widget.email),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    "Erro ao carregar serviços: ${snapshot.error}"));
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text("Nenhum serviço encontrado"));
                          }
                          List<ServiceModelDTO> services = snapshot.data!;

                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: ListView.builder(
                              itemCount: services.length,
                              itemBuilder: (context, index) {
                                ServiceModelDTO service = services[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ListTile(
                                    title: Text(service.descricao),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Valor: R\$ ${service.valor.toString()}'),
                                        Text(
                                            'Disponibilidade: ${service.disponibilidade}'),
                                        Text('Categoria: ${service.categoria}'),
                                        const SizedBox(height: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (service.categoria ==
                                                'Limpeza') {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CleaningPage(
                                                          service: service,
                                                          emailCliente:
                                                              emailCliente),
                                                ),
                                              );
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Dialog(
                                                      backgroundColor:
                                                          Colors.white,
                                                      insetPadding:
                                                          const EdgeInsets.all(0),
                                                      child: Column(
                                                        children: [
                                                          AppBar(
                                                            title: const Text(
                                                                'Contratar Serviço'),
                                                            backgroundColor:
                                                                const Color(
                                                                    0xff0095FF),
                                                            automaticallyImplyLeading:
                                                                false,
                                                            actions: [
                                                              IconButton(
                                                                icon: const Icon(Icons
                                                                    .close),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                          Expanded(
                                                            child:
                                                                SingleChildScrollView(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        16.0),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Text(
                                                                        'Você deseja contratar este serviço?'),
                                                                    const SizedBox(
                                                                        height:
                                                                            16),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              20.0),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          const Text(
                                                                            "Data",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Colors.black87,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 5),
                                                                          TextField(
                                                                            controller:
                                                                                _dataController,
                                                                            obscureText:
                                                                                false,
                                                                            onTap:
                                                                                () async {
                                                                              FocusScope.of(context).requestFocus(FocusNode());
                                                                              DateTime? picked = await showDatePicker(
                                                                                context: context,
                                                                                initialDate: DateTime.now(),
                                                                                firstDate: DateTime(2020),
                                                                                lastDate: DateTime(2030),
                                                                              );
                                                                              _dataController.text = DateFormat('dd-MM-yyyy').format(picked!);
                                                                                                                                                        },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: Colors.grey[400]!),
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                              ),
                                                                              border: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: Colors.grey[400]!),
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 10),
                                                                          const Text(
                                                                            "Horário",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Colors.black87,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 5),
                                                                          TextField(
                                                                            controller:
                                                                                _horarioController,
                                                                            obscureText:
                                                                                false,
                                                                            onTap:
                                                                                () async {                                                                          
                                                                              FocusScope.of(context).requestFocus(FocusNode());
                                                                              TimeOfDay? picked = await showTimePicker(
                                                                                context: context,
                                                                                initialTime: TimeOfDay.now(),
                                                                              );
                                                                              if (picked != null) {
                                                                                _horarioController.text = picked.format(context);
                                                                              }
                                                                            },
                                                                            decoration:
                                                                                InputDecoration(
                                                                              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: Colors.grey[400]!),
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                              ),
                                                                              border: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: Colors.grey[400]!),
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 10),
                                                                          const Text(
                                                                            "Descrição",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Colors.black87,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 5),
                                                                          TextField(
                                                                            controller:
                                                                                _descricaoController,
                                                                            obscureText:
                                                                                false,
                                                                            onTap:
                                                                                () async {},
                                                                            decoration:
                                                                                InputDecoration(
                                                                              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: Colors.grey[400]!),
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                              ),
                                                                              border: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: Colors.grey[400]!),
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 10),
                                                                          const Text(
                                                                            "Valor que deseja pagar",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Colors.black87,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 5),
                                                                          TextField(
                                                                            controller:
                                                                                _valorController,
                                                                            obscureText:
                                                                                false,
                                                                            onTap:
                                                                                () async {},
                                                                            decoration:
                                                                                InputDecoration(
                                                                              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: Colors.grey[400]!),
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                              ),
                                                                              border: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: Colors.grey[400]!),
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: const Text(
                                                                      'Cancelar'),
                                                                ),
                                                                const SizedBox(
                                                                    width: 8),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    DateTime dataSelecionada = _parseDate(_dataController.text);
    // DateTime horaSelecionada = _parseTime(_horarioController.text);

                                                                    SolicitarServico
                                                                        solicitarServico =
                                                                        SolicitarServico(
                                                                      servico:
                                                                          service,
                                                                      data:
                                                                          dataSelecionada,
                                                                      hora:
                                                                          _horarioController.text,
                                                                      descricao:
                                                                          _descricaoController
                                                                              .text,
                                                                      valorcliente:
                                                                          _valorController
                                                                              .text,
                                                                      emailPrestador:
                                                                          widget
                                                                              .email,
                                                                      emailCliente:
                                                                          emailCliente,
                                                                      status:
                                                                          "Solicitação enviada",
                                                                    );
                                                                    _contratarServico(
                                                                        solicitarServico,
                                                                        notificationService);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: const Text(
                                                                      'Contratar'),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            }
                                          },
                                          child: const Text('Contratar'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
