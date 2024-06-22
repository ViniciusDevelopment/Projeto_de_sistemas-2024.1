import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
<<<<<<< Updated upstream
import 'package:servicocerto/Pagescliente/Pagamento.dart';
import 'package:servicocerto/Pagescliente/homePage.dart';
import 'package:servicocerto/index.dart';
=======
import 'package:servicocerto/Controller/ratingController.dart';
import 'package:servicocerto/Models/ratingService.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rating_dialog/rating_dialog.dart';
>>>>>>> Stashed changes

class ServicosContradosCliente extends StatefulWidget {
  const ServicosContradosCliente({super.key});

  @override
  _ServicosContradosClienteState createState() =>
      _ServicosContradosClienteState();
}

class _ServicosContradosClienteState extends State<ServicosContradosCliente> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  late Future<List<DocumentSnapshot>> _futureServices;
  late Future<Map<String, dynamic>> _futureUserData;

  @override
  void initState() {
    super.initState();
    _futureServices = _fetchServices();
    _futureUserData = _fetchUserData();
  }

  Future<List<DocumentSnapshot>> _fetchServices() async {
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    if (currentUserEmail != null) {
      late QuerySnapshot querySnapshot;
      if (_selectedIndex == 0) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('SolicitacoesServico')
            .where('emailCliente', isEqualTo: currentUserEmail)
            .where('status', isEqualTo: 'Aceita')
            .get();
      } else if (_selectedIndex == 1) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('SolicitacoesServico')
            .where('emailCliente', isEqualTo: currentUserEmail)
            .where('status', isEqualTo: 'Concluido')
            .get();
      }
      return querySnapshot.docs;
    } else {
      return [];
    }
  }

<<<<<<< Updated upstream
  Future<Map<String, dynamic>> _fetchUserData() async {
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    if (currentUserEmail != null) {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserEmail)
          .get();
      return userSnapshot.data() as Map<String, dynamic>;
    } else {
      return {};
    }
=======
  void _confirmarConclusaoServico(String serviceId, String emailPrestador) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmação"),
          //content:
          //buildRatingPage(context, emailPrestador, serviceId),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('SolicitacoesServico')
                    .doc(serviceId)
                    .update({'status': 'Concluido'});
                Navigator.of(context).pop();
                _showRatingDialog(serviceId, emailPrestador);
                setState(() {
                  _futureServices = _fetchServices();
                });
              },
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

TextEditingController commentController = TextEditingController();
double rating = 3.0;
void _showRatingDialog(String serviceId, String emailPrestador) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 400),
            child: AlertDialog(
              title: const Text(
                "Avaliar Serviço",
                style: TextStyle(
                  color: Colors.blue, // Cor azul
                  fontWeight: FontWeight.bold, // Negrito
                ),
                textAlign: TextAlign.center, // Centralizar texto
              ),
              content: buildRatingPage(context, emailPrestador, serviceId),
              actions: [
                Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Pular"),
                    ),
                    Spacer(), // Adiciona um espaço flexível entre os botões
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white
                      ),
                      onPressed: () {
                        sendReview(context, emailPrestador, serviceId);
                        Navigator.of(context).pop();
                      },
                      child: const Text("Enviar"),
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


void sendReview(BuildContext context, String emailPrestador, String serviceId) async {
  try {
    String comment = commentController.text;
    RatingServiceModel service = RatingServiceModel(
      rating: rating,
      comment: comment,
      date: DateTime.now(),
      emailCliente: FirebaseAuth.instance.currentUser?.email,
      emailPrestador: emailPrestador,
      serviceID: serviceId,
    );

    await RatingServiceController.instance.rateService(service);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Avaliação enviada com sucesso!'),
      ),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => const ServicosContradosCliente(),
      ),
    );
  } catch (error) {
    print('Erro ao enviar avaliação: $error');
>>>>>>> Stashed changes
  }
}

Widget buildRatingPage(BuildContext context, String emailPrestador, String serviceId) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 20),
      Center(
        child: RatingBar.builder(
          initialRating: rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (newRating) {
            rating = newRating;
            print(rating);
          },
        ),
      ),
      const SizedBox(height: 20),
      TextField(
        controller: commentController,
        decoration: const InputDecoration(
          labelText: 'Deixe um comentário',
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
      ),
      const SizedBox(height: 20),
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Meus Serviços",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff0095FF),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async {
                    final userData = await _futureUserData;
                    Navigator.pushReplacement(
                       context,
                       MaterialPageRoute(
                        builder: (context) => IndexPage()//HomePage(userData: userData),
                       ),
    );
  },
),
        
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          const Align(
            alignment: Alignment.center,
            child: Text(
              "Serviços Contratados",
              style: TextStyle(fontSize: 24, color: Colors.blue),
            ),
          ),
          const SizedBox(height: 20),
          ToggleButtons(
            borderRadius: BorderRadius.circular(10),
            selectedColor: Colors.white,
            fillColor: Colors.blue,
            isSelected: [_selectedIndex == 0, _selectedIndex == 1],
            onPressed: (index) {
              setState(() {
                _selectedIndex = index;
                _futureServices =
                    _fetchServices(); // Atualiza a lista de serviços quando o botão é pressionado
              });
            },
            children: const [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text("Agendados"),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text("Anteriores"),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_selectedIndex == 0 || _selectedIndex == 1)
            Expanded(
              child: FutureBuilder<List<DocumentSnapshot>>(
                future: _futureServices,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nenhum serviço encontrado'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final service = snapshot.data![index];
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
                                Text('Descrição: ${service['descricao']}'),
                                Text('Prestador: ${service['emailPrestador']}'),
                                Text(
                                    "Data: ${service['data']}     Horário: ${service['hora']}"),
                                Text(
                                    'Valor Proposto: R\$${service['valorcliente']}'),
                                if (_selectedIndex == 0)
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
<<<<<<< Updated upstream
                                      onPressed: (){ //=>
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => PagamentoPage(service),),
                                          );},
                                          //_confirmarConclusaoServico(service.id,
                                              //service['emailPrestador']),
=======
                                      onPressed: () =>
                                          _confirmarConclusaoServico(service.id,
                                            service['emailPrestador']),
>>>>>>> Stashed changes
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            Colors.blue, // Texto branco
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      child: const Text("Serviço foi concluído"),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
