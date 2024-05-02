import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servicocerto/Controller/ServiceController.dart';
import 'package:servicocerto/Controller/authCheck.dart';
import 'package:servicocerto/Pagescliente/CadastrarservicoPage.dart';
import 'package:servicocerto/Pagescliente/SearchPage.dart';
import 'package:servicocerto/ReadData/get_user_name.dart';
import 'package:servicocerto/Pagescliente/UserInfoPage.dart';

import 'calendarPage.dart'; // Importe a classe CalendarPage

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Authentication().currentUser;

  Future<void> signOut() async {
    await Authentication().signOut();
  }

  int _selectedIndex = 1; // Defina o índice inicial como 1 (tela inicial)

  final List<Widget> _screens = [
    CalendarPage(), // Tela do Calendário
    HomePageContent(),
    UserInfoPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _userId() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text('Sign Out'));
  }

  void _cadastrarServico() {
    // Navegar para a página de cadastro de serviço quando o botão for pressionado
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ServiceRegistrationPage()),
    );
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
          PopupMenuItem(
            child: ElevatedButton(
              onPressed: _cadastrarServico,
              child: const Text('Cadastrar serviço'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Início",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 24),
            child: _userMenuButton(context),
          )
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
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
            label: 'Início',
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
    );
  }
}

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 15, bottom: 45, left: 80, right: 80),
          alignment: Alignment.center,
          color: Theme.of(context).colorScheme.background,
          child: const Text(
            'Bem Vindo',
            style: TextStyle(color: Colors.blue, fontSize: 24),
          ),
        ),
        Container(
          color: Theme.of(context).colorScheme.background,
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Pesquisar...',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PesquisapageWidget()),
              );
            },
          ),
        ),
        Container(
          color: Theme.of(context).colorScheme.background,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Recomendações:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: FirebaseFirestore.instance.collection('Users').get(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final List<String> docIDs =
                  snapshot.data!.docs.map((doc) => doc.id).toList();
              return ListView.builder(
                itemCount: docIDs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: GetUserName(documentId: docIDs[index]),
                        tileColor: Color.fromARGB(255, 252, 252, 252),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}