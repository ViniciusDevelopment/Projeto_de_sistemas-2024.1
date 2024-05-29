import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicosContradosCliente extends StatefulWidget {
  const ServicosContradosCliente({Key? key}) : super(key: key);

  @override
  _ServicosContradosClienteState createState() =>
      _ServicosContradosClienteState();
}

class _ServicosContradosClienteState extends State<ServicosContradosCliente> {
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

  void _confirmarConclusaoServico(String serviceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmação"),
          content: Text("Você confirma que o serviço foi prestado?"),
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
                _showRatingDialog(
                    serviceId); // Chama a função para mostrar o popup de avaliação
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

  void _showRatingDialog(String serviceId) {
    double _rating = 0;
    TextEditingController _commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Adicionado StatefulBuilder
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Avaliação (Opcional)"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Por favor, avalie o serviço:"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            // Agora isso atualizará o estado
                            _rating = index + 1.0;
                          });
                        },
                      );
                    }),
                  ),
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Escreva sua avaliação aqui",
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text("Fechar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Enviar"),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('AvaliacoesServico')
                        .add({
                      'serviceId': serviceId,
                      'rating': _rating,
                      'comment': _commentController.text,
                      'date': Timestamp.now(),
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                          _confirmarConclusaoServico(
                                              service.id),
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
