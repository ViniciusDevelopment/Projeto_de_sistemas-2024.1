import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Importar pacote intl

class ServicosContrados extends StatefulWidget {
  const ServicosContrados({Key? key}) : super(key: key);

  @override
  _ServicosContradosState createState() => _ServicosContradosState();
}

class _ServicosContradosState extends State<ServicosContrados> {
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
            .where('emailPrestador', isEqualTo: currentUserEmail)
            .where('status', isEqualTo: 'Aceita')
            .get();
      } else if (_selectedIndex == 1) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('SolicitacoesServico')
            .where('emailPrestador', isEqualTo: currentUserEmail)
            .where('status', isEqualTo: 'Concluido')
            .get();
      }
      return querySnapshot.docs;
    } else {
      return [];
    }
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
            FutureBuilder<List<DocumentSnapshot>>(
              future: _futureServices,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data!.isEmpty) {
                  return Center(child: Text('Nenhum serviço encontrado'));
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final service = snapshot.data![index];
                        final String categoria =
                            (service['servico'] as Map)['categoria'];
                        final bool isLimpeza = categoria.toLowerCase() ==
                            'limpeza'; // Verifica se é um serviço de limpeza

                        // Converte o Timestamp para DateTime e formata a data
                        final DateTime dateTime =
                            (service['data'] as Timestamp).toDate();
                        final String formattedDate =
                            DateFormat('dd/MM/yyyy').format(dateTime);

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
                                Text('Cliente: ${service['emailCliente']}'),
                                Text(
                                    "Data: $formattedDate     Horário: ${service['hora']}"),
                                Text(
                                    'Valor Proposto: R\$${service['valorcliente']}'),
                                if (isLimpeza)
                                  Text('Cômodos: ${service['comodos']}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}
