import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servicocerto/Controller/ServiceController.dart';
import 'package:servicocerto/Controller/authCheck.dart';
import 'package:servicocerto/Pagescliente/SearchPage.dart';
import 'package:servicocerto/PagesCommon/calendarPage.dart';
import 'package:servicocerto/PagesCommon/ProfilePage.dart';
import 'package:servicocerto/ReadData/get_user_name.dart';
import 'package:servicocerto/Pagescliente/UserInfoPage.dart';

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
                CalendarPage(),
                HomePageContent(userData: widget.userData),
                ProfilePage(userData: widget.userData),
              ],
            ),
          ),
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.blue,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: 'Calendário',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Início Diarista',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.6),
            iconSize: 24,
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
          .collection('SolicitacaoServico')
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
                border: Border.all(
                    color: Color(0xff0095FF)),
                borderRadius:
                    BorderRadius.circular(8.0),
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
              .collection('SolicitacaoServico')
              .where('emailPrestador', isEqualTo: FirebaseAuth.instance.currentUser!.email)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              } else {
                final List<DocumentSnapshot> documents = snapshot.data!.docs;
                return documents.isNotEmpty
                    ? ListView.builder(
  itemCount: documents.length,
  itemBuilder: (context, index) {
    final Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;
    return ListTile(
      title: Text('Serviço: ${data['descricao']}'),
      subtitle: Text('Detalhes:\n Cliente: ${data['emailCliente']}\n Data: ${data['data']}\n Horário: ${data['horario']}\n Endereço: ${data['endereco']}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            

            onPressed: () async {
   
    final documentReference = FirebaseFirestore.instance
        .collection('SolicitacaoServico')
        .doc(documents[index].id);

    try {
     
      final DocumentSnapshot documentSnapshot = await documentReference.get();
      final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

      
      await FirebaseFirestore.instance
          .collection('Servicos')
          .add(data);

      
      await documentReference.delete();

      
      setState(() {});
    } catch (e) {
      
      print('Erro ao aceitar o serviço: $e');
    }
  },
            style: ElevatedButton.styleFrom(
             backgroundColor: Colors.green,
            ),
            child: const Text(style:TextStyle(color: Colors.white),'Aceitar'),
          ),
          SizedBox(width: 8), 
          ElevatedButton(
            
              onPressed: () async {
    
    final documentReference = FirebaseFirestore.instance
        .collection('SolicitacaoServico')
        .doc(documents[index].id); 

    try {
      
      await documentReference.delete();
      
     
      setState(() {});
    } catch (e) {
      
      print('Erro ao excluir o documento: $e');
    }
  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(style:TextStyle(color: Colors.white),'Recusar'),
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

