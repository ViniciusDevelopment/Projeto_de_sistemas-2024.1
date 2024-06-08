import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servicocerto/Models/ratingService.dart';
import 'package:servicocerto/Controller/ServiceController.dart';
import 'package:servicocerto/Models/ratingService.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ServicosContradosCliente extends StatefulWidget {
  const ServicosContradosCliente({Key? key}) : super(key: key);

  @override
  _ServicosContradosClienteState createState() =>
      _ServicosContradosClienteState();
}

class _ServicosContradosClienteState extends State<ServicosContradosCliente> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  late Future<List<DocumentSnapshot>> _futureServices;

  @override
  void initState() {
    super.initState();
    _futureServices = _fetchServices();
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

  void _confirmarConclusaoServico(String serviceId, String emailPrestador) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmação"),
          //content:
          //buildRatingPage(context, emailPrestador, serviceId),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Confirmar"),
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
            ),
          ],
        );
      },
    );
  }

  void _showRatingDialog(String serviceId, String emailPrestador) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Avalie o Serviço"),
          content: buildRatingPage(context, emailPrestador, serviceId),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static const photoUrl =
      'https://www.google.com/url?sa=i&url=https%3A%2F%2Fflowgames.gg%2Fdestiny-2-a-forma-final-tem-novos-detalhes-e-data%2F&psig=AOvVaw18da4vkKJizXQ85YToSCh9&ust=1717427108102000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCJCPttiYvYYDFQAAAAAdAAAAABAE';
  Widget buildRatingPage(
      BuildContext context, String emailPrestador, String serviceId) {
    TextEditingController _commentController = TextEditingController();
    double _rating = 3.0;

    void _sendReview() async {
      try {
        String comment = _commentController.text;
        RatingServiceModel service = RatingServiceModel(
          rating: _rating,
          comment: comment,
          date: DateTime.now(),
          emailCliente: FirebaseAuth.instance.currentUser?.email,
          emailPrestador: emailPrestador,
          serviceID: serviceId,
        );

        await RatingServiceController.instance.rateService(service);

        // Mostra um SnackBar com a mensagem de confirmação após o envio da avaliação
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Avaliação enviada com sucesso!'),
          ),
        );

        // Navega para a mesma página atualizada após enviar a avaliação
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => ServicosContradosCliente(),
          ),
        );
      } catch (error) {
        print('Erro ao enviar avaliação: $error');
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AVALIE O SERVIÇO! (OPCIONAL)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Center(
          child: RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              _rating = rating;
              print(rating);
            },
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _commentController,
          decoration: const InputDecoration(
            labelText: 'Deixe um comentário',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () {
              _sendReview;
              Navigator.of(context).pop();
            },
            child: const Text('Enviar Avaliação'),
          ),
        ),
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
      ),
      body: Column(
        children: [
          SizedBox(height: 15),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Serviços Contratados",
              style: TextStyle(fontSize: 24, color: Colors.blue),
            ),
          ),
          SizedBox(height: 20),
          ToggleButtons(
            borderRadius: BorderRadius.circular(10),
            selectedColor: Colors.white,
            fillColor: Colors.blue,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text("Agendados"),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text("Anteriores"),
              ),
            ],
            isSelected: [_selectedIndex == 0, _selectedIndex == 1],
            onPressed: (index) {
              setState(() {
                _selectedIndex = index;
                _futureServices =
                    _fetchServices(); // Atualiza a lista de serviços quando o botão é pressionado
              });
            },
          ),
          SizedBox(height: 20),
          if (_selectedIndex == 0 || _selectedIndex == 1)
            Expanded(
              child: FutureBuilder<List<DocumentSnapshot>>(
                future: _futureServices,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.data!.isEmpty) {
                    return Center(child: Text('Nenhum serviço encontrado'));
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
                            padding: EdgeInsets.all(8.0),
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
                                      onPressed: () =>
                                          _confirmarConclusaoServico(service.id,
                                              service['emailPrestador']),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            Colors.blue, // Texto branco
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      child: Text("Serviço foi concluído"),
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
