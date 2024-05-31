import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import necessário para FilteringTextInputFormatter
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:servicocerto/Controller/ServiceController.dart'; // Import corrigido para minúsculas
import 'package:servicocerto/Controller/UserController.dart';
import 'package:servicocerto/DTO/Request/ServiceDTO.dart';
import 'package:servicocerto/Models/Service.dart'; // Import corrigido para minúsculas
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servicocerto/Models/SolicitarServico.dart';
import 'package:servicocerto/Models/User.dart';
import 'package:servicocerto/Pagescliente/cleaning.dart';
import 'package:servicocerto/Services/notification_service.dart';

class ContratarServicoPage extends StatefulWidget {
  final String email;

  const ContratarServicoPage(
      {super.key, required this.email}); // Adicionado key

  @override
  _ContratarServicoPageState createState() => _ContratarServicoPageState();
}

class _ContratarServicoPageState extends State<ContratarServicoPage> {
  final NotificationService notificationService = NotificationService();
  late String emailCliente;
  final _db = FirebaseFirestore.instance;
  final _dataController = TextEditingController();
  final _horaController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _valorclienteController = TextEditingController();
  late UserModel? _userData;

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
  }

  void _contratarServico(SolicitarServico solicitarServico,
      NotificationService notificationService) async {
    if (solicitarServico.data.isEmpty || solicitarServico.hora.isEmpty) {
      Get.snackbar(
        'Erro',
        'Preencha todos os campos',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection('SolicitacoesServico')
          .add(solicitarServico.toJson());

      notificationService.showLocalNotification(
        CustomNotification(
          id: DateTime.now()
              .millisecondsSinceEpoch, // Usar timestamp como ID único
          title: 'Serviço Solicitado',
          body: 'Novo Serviço solicitado.',
          payload:
              '', // Pode ser utilizado para abrir uma tela específica se necessário
        ),
      );
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
            name: userData['Name'] ?? '', // Adicionando verificação de nulidade
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
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
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
              child: IntrinsicHeight(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 5, 8, 5),
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
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                        child: Container(
                          width: 110,
                          height: 110,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            'https://picsum.photos/seed/34/600',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: Text(
                                _userData!.name,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5, 0, 0, 0),
                                    child: Text(
                                      'Sem avaliações',
                                      style: TextStyle(
                                        fontFamily: 'Readex Pro',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
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
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    "Erro ao carregar serviços: ${snapshot.error}"));
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                                child: Text("Nenhum serviço encontrado"));
                          }
                          List<ServiceModelDTO> services = snapshot.data!;

                          return Container(
                            height: MediaQuery.of(context).size.height *
                                0.5, // Ajusta a altura do ListView
                            child: ListView.builder(
                              itemCount: services.length,
                              itemBuilder: (context, index) {
                                ServiceModelDTO service = services[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(
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
                                        SizedBox(
                                            height:
                                                8), // Espaço entre os textos e o botão
                                        ElevatedButton(
                                          onPressed: () {
                                            if (service.categoria ==
                                                'Limpeza') {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CleaningPage(service: service, emailCliente: emailCliente),
                                                ),
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Contratar Serviço'),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            'Você deseja contratar este serviço?'),
                                                        TextFormField(
                                                          controller:
                                                              _dataController,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText: 'Data',
                                                          ),
                                                          onTap: () async {
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    FocusNode());
                                                            DateTime? picked =
                                                                await showDatePicker(
                                                              context: context,
                                                              initialDate:
                                                                  DateTime
                                                                      .now(),
                                                              firstDate:
                                                                  DateTime(
                                                                      2020),
                                                              lastDate:
                                                                  DateTime(
                                                                      2030),
                                                            );
                                                            if (picked !=
                                                                null) {
                                                              _dataController
                                                                  .text = DateFormat(
                                                                      'dd-MM-yyyy')
                                                                  .format(
                                                                      picked);
                                                            }
                                                          },
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              _horaController,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Horário',
                                                          ),
                                                          onTap: () async {
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    FocusNode());
                                                            TimeOfDay? picked =
                                                                await showTimePicker(
                                                              context: context,
                                                              initialTime:
                                                                  TimeOfDay
                                                                      .now(),
                                                            );
                                                            if (picked !=
                                                                null) {
                                                              _horaController
                                                                      .text =
                                                                  picked.format(
                                                                      context);
                                                            }
                                                          },
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              _descricaoController, // Controlador de descrição
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Descrição do serviço', // Rótulo do campo
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              _valorclienteController, // Controlador de descrição
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Valor que deseja pagar', // Rótulo do campo
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Cancelar'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          SolicitarServico
                                                              solicitarServico =
                                                              SolicitarServico(
                                                            servico: service,
                                                            data:
                                                                _dataController
                                                                    .text,
                                                            hora:
                                                                _horaController
                                                                    .text,
                                                            descricao:
                                                                _descricaoController
                                                                    .text,
                                                            valorcliente:
                                                                _valorclienteController
                                                                    .text,
                                                            emailPrestador:
                                                                service.email,
                                                            emailCliente:
                                                                emailCliente,
                                                            status:
                                                                "Solicitação enviada",
                                                          );
                                                          _contratarServico(
                                                              solicitarServico,
                                                              notificationService);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            Text('Contratar'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          child: Text('Contratar'),
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
