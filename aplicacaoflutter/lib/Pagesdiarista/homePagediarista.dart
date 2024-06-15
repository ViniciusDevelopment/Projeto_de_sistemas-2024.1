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

  Future<void> _createNotification(String clientEmail, String message) async {
    await FirebaseFirestore.instance.collection('Notificacoes').add({
      'emailCliente': clientEmail,
      'mensagem': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 15, bottom: 45, left: 80, right: 80),
          alignment: Alignment.center,
        ),
        SearchAnchor(
          builder: (BuildContext context, SearchController controller) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff0095FF)),
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
              child: SearchBar(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                controller: controller,
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                leading: const Icon(Icons.search),
              ),
            );
          },
          suggestionsBuilder:
              (BuildContext context, SearchController controller) {
            return List<ListTile>.generate(5, (int index) {
              final String item = 'item $index';
              return ListTile(
                title: Text(item),
                onTap: () {
                  setState(() {
                    controller.closeView(item);
                  });
                },
              );
            });
          },
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
                        return documents.isNotEmpty
                            ? ListView.builder(
                                itemCount: documents.length,
                                itemBuilder: (context, index) {
                                  final Map<String, dynamic> data =
                                      documents[index].data()
                                          as Map<String, dynamic>;
                                  final Map<String, dynamic> servico =
                                      data['servico'] as Map<String, dynamic>;
                                  final String descricao = servico['descricao'];

                                  return ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Serviço: $descricao'),
                                        Text(
                                          'Cliente: ${data['emailCliente']}\nData: ${data['data']}\nHorário: ${data['hora']}\nDescrição: ${data['descricao']}\nValor do serviço: ${data['valorcliente']}',
                                        ),
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
                                                        .doc(documents[index]
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
                                                style: TextStyle(
                                                    color: Colors.white),
                                                'Aceitar',
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            ElevatedButton(
                                              onPressed: () async {
                                                final documentReference =
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'SolicitacoesServico')
                                                        .doc(documents[index]
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
                                                style: TextStyle(
                                                    color: Colors.white),
                                                'Recusar',
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
                                child: Text('Nenhuma Solicitação Pendente'),
                              );
                      }
                    }
                  },
                )
              : Center(
                  child: Text('Nenhuma Solicitação Pendente'),
                ),
        ),
      ],
    );
  }
}
