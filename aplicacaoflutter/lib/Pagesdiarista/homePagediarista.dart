import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';
import 'package:servicocerto/Controller/ServiceController.dart';
import 'package:servicocerto/Controller/authCheck.dart';
import 'package:servicocerto/PagesCommon/RelatorioPage.dart';
import 'package:servicocerto/Pagescliente/SearchPage.dart';
import 'package:servicocerto/PagesCommon/calendarPage.dart';
import 'package:servicocerto/PagesCommon/ProfilePage.dart';
import 'package:servicocerto/ReadData/get_user_name.dart';
import 'package:servicocerto/PagesCommon/ChatPage.dart';
import 'package:servicocerto/PagesCommon/ChatListPage.dart';
import 'package:intl/intl.dart'; // Importar pacote intl

class HomePagediarista extends StatefulWidget {
  final Map<String, dynamic> userData;

  const HomePagediarista({Key? key, required this.userData}) : super(key: key);

  @override
  State<HomePagediarista> createState() => _HomePagediaristaState();
}

class _HomePagediaristaState extends State<HomePagediarista> {
  final User? user = Authentication().currentUser;

  Future<void> signOut() async {
    await Authentication().signOut();
  }

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _userId() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text('Sair'));
  }

  Widget _userMenuButton(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.white,
      child: PopupMenuButton(
        icon: const Icon(
          Icons.person,
          color: Colors.black,
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          PopupMenuItem(child: _signOutButton()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                CalendarPage(key: UniqueKey()),
                HomePageContent(userData: widget.userData),
                ChatListPage(),
                ProfilePage(userData: widget.userData),
              ],
            ),
          ),
          BottomNavigationBar(
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.white,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Iconsax.calendar),
                ),
                label: 'Calendário',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Iconsax.home),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Iconsax.message),
                ),
                label: 'Conversas',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Iconsax.user),
                ),
                label: 'Perfil',
              ),
            ],
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey[700],
            iconSize: 24,
            selectedFontSize: 14,
            unselectedFontSize: 14,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle:
                TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
            unselectedLabelStyle:
                TextStyle(fontWeight: FontWeight.normal, fontFamily: 'Roboto'),
          ),
        ],
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  final Map<String, dynamic> userData;

  const HomePageContent({Key? key, required this.userData}) : super(key: key);

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  bool isDark = false;
  bool _isCurrentUserAuthorized = false;
  String _searchQuery = '';
  Map<String, String> clientNames = {}; // Armazena nomes dos clientes

  @override
  void initState() {
    super.initState();
    _checkCurrentUserAuthorization();
  }

  Future<void> _checkCurrentUserAuthorization() async {
    final String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    if (currentUserEmail != null) {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('SolicitacoesServico')
          .where('emailPrestador', isEqualTo: currentUserEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Pré-carregar os nomes dos clientes
        await _preloadClientNames(querySnapshot.docs);
        setState(() {
          _isCurrentUserAuthorized = true;
        });
      } else {
        setState(() {
          _isCurrentUserAuthorized = false;
        });
      }
    } else {
      setState(() {
        _isCurrentUserAuthorized = false;
      });
    }
  }

  Future<void> _preloadClientNames(List<DocumentSnapshot> docs) async {
    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final clientEmail = data['emailCliente'] ?? '';

      if (!clientNames.containsKey(clientEmail)) {
        final clientName = await _getClientName(clientEmail);
        clientNames[clientEmail] = clientName;
      }
    }
  }

  Future<String> _getClientName(String clientEmail) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Email', isEqualTo: clientEmail)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first['Name'];
    } else {
      return 'Nome não encontrado';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 15, bottom: 15, left: 80, right: 80),
          alignment: Alignment.center,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xff0095FF)),
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar cliente',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            ),
            onChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Solicitações de Serviços:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: _isCurrentUserAuthorized
              ? FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('SolicitacoesServico')
                      .where('emailPrestador',
                          isEqualTo: FirebaseAuth.instance.currentUser!.email)
                      .where('status', isEqualTo: 'Solicitação enviada')
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.hasError) {
                        return Center(child: Text('Erro: ${snapshot.error}'));
                      } else {
                        final List<DocumentSnapshot> documents =
                            snapshot.data!.docs;
                        final filteredDocuments = documents.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final clientEmail = data['emailCliente'] ?? '';
                          final clientName = clientNames[clientEmail] ?? '';

                          return clientName
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase());
                        }).toList();

                        return filteredDocuments.isNotEmpty
                            ? ListView.builder(
                                itemCount: filteredDocuments.length,
                                itemBuilder: (context, index) {
                                  final Map<String, dynamic> data =
                                      filteredDocuments[index].data()
                                          as Map<String, dynamic>;
                                  final Map<String, dynamic> servico =
                                      data['servico'];
                                  final String descricao =
                                      servico['descricao'] ?? '';
                                  final String clientEmail =
                                      data['emailCliente'] ?? '';
                                  final String clientName =
                                      clientNames[clientEmail] ?? '';
                                  final DateTime dateTime =
                                      (data['data'] as Timestamp).toDate();
                                  final String formattedDate =
                                      DateFormat('dd/MM/yyyy').format(dateTime);

                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4.0,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Serviço: $descricao'),
                                        Text(
                                          'Cliente: $clientName (${data['emailCliente']})\nData: $formattedDate\nHorário: ${data['hora']}\nDescrição: ${data['descricao']}\nValor do serviço: ${data['valorcliente']}',
                                        ),
                                        if ((data['servico']
                                                as Map)['categoria'] ==
                                            'Limpeza') // Verifique a categoria
                                          Text(
                                              'Cômodos: ${(data['comodos'] as Map).entries.map((e) => "${e.key}: ${e.value}").join(", ")}'),
                                        SizedBox(height: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatPage(
                                                            receiverUserEmail: data[
                                                                "emailCliente"],
                                                          )),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 174, 174, 174),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  side: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 174, 174, 174),
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                              child: const Text(
                                                "Conversar",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            ElevatedButton(
                                              onPressed: () async {
                                                final documentReference =
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'SolicitacoesServico')
                                                        .doc(filteredDocuments[
                                                                index]
                                                            .id);

                                                try {
                                                  final DocumentSnapshot
                                                      documentSnapshot =
                                                      await documentReference
                                                          .get();
                                                  final Map<String, dynamic>
                                                      data =
                                                      documentSnapshot.data()
                                                          as Map<String,
                                                              dynamic>;

                                                  await documentReference
                                                      .update(
                                                          {'status': 'Aceita'});

                                                  final String diaristaEmail =
                                                      FirebaseAuth.instance
                                                          .currentUser!.email!;

                                                  await _createNotification(
                                                      data['emailCliente'],
                                                      'A diarista $diaristaEmail aceitou a sua solicitação');

                                                  setState(() {});

                                                  Flushbar(
                                                    message:
                                                        'Serviço aceito com sucesso!',
                                                    backgroundColor:
                                                        Colors.green,
                                                    duration:
                                                        Duration(seconds: 3),
                                                    margin: EdgeInsets.all(8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    flushbarPosition:
                                                        FlushbarPosition.TOP,
                                                    flushbarStyle:
                                                        FlushbarStyle.FLOATING,
                                                    forwardAnimationCurve:
                                                        Curves.easeOut,
                                                    reverseAnimationCurve:
                                                        Curves.easeIn,
                                                  )..show(context);
                                                } catch (e) {
                                                  print(
                                                      'Erro ao aceitar o serviço: $e');
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  side: BorderSide(
                                                    color: Colors.green,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                              child: const Text(
                                                'Aceitar',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            ElevatedButton(
                                              onPressed: () async {
                                                final documentReference =
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'SolicitacoesServico')
                                                        .doc(filteredDocuments[
                                                                index]
                                                            .id);

                                                try {
                                                  final DocumentSnapshot
                                                      documentSnapshot =
                                                      await documentReference
                                                          .get();
                                                  final Map<String, dynamic>
                                                      data =
                                                      documentSnapshot.data()
                                                          as Map<String,
                                                              dynamic>;

                                                  await documentReference
                                                      .update({
                                                    'status': 'Recusado'
                                                  });

                                                  final String diaristaEmail =
                                                      FirebaseAuth.instance
                                                          .currentUser!.email!;

                                                  await _createNotification(
                                                      data['emailCliente'],
                                                      'A diarista $diaristaEmail recusou a sua solicitação');

                                                  setState(() {});

                                                  Flushbar(
                                                    message:
                                                        'Serviço recusado!',
                                                    backgroundColor: Colors.red,
                                                    duration:
                                                        Duration(seconds: 3),
                                                    margin: EdgeInsets.all(8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    flushbarPosition:
                                                        FlushbarPosition.TOP,
                                                    flushbarStyle:
                                                        FlushbarStyle.FLOATING,
                                                    forwardAnimationCurve:
                                                        Curves.easeOut,
                                                    reverseAnimationCurve:
                                                        Curves.easeIn,
                                                  )..show(context);
                                                } catch (e) {
                                                  print(
                                                      'Erro ao recusar o serviço: $e');
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  side: BorderSide(
                                                    color: Colors.red,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                              child: const Text(
                                                'Recusar',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  'Nenhuma solicitação encontrada.',
                                  style: TextStyle(fontSize: 16),
                                ),
                              );
                      }
                    }
                  },
                )
              : Center(
                  child: Text(
                    'Usuário não autorizado para ver as solicitações.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
        ),
      ],
    );
  }

  Future<void> _createNotification(
      String userEmail, String notificationMessage) async {
    final CollectionReference notificationsCollection =
        FirebaseFirestore.instance.collection('Notifications');

    await notificationsCollection.add({
      'userEmail': userEmail,
      'message': notificationMessage,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
