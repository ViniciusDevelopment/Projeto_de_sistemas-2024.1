import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servicocerto/Pagescliente/Pagamento.dart';
import 'package:servicocerto/Pagescliente/homePage.dart';
import 'package:servicocerto/index.dart';

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
                                      onPressed: (){ //=>
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => PagamentoPage(service),),
                                          );},
                                          //_confirmarConclusaoServico(service.id,
                                              //service['emailPrestador']),
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
