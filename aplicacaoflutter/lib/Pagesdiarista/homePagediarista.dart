import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:servicocerto/Controller/authCheck.dart';
import 'package:servicocerto/Pagescliente/calendarPage.dart';
import 'package:servicocerto/Pagesdiarista/ProfilePage.dart';

// Importe a classe CalendarPage

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

  int _selectedIndex = 1; // Defina o índice inicial como 1 (tela inicial)

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
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   centerTitle: true,
      //   title: const Text(
      //     "Início",
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   actions: <Widget>[
      //     Container(
      //       padding: const EdgeInsets.only(right: 24),
      //       child: _userMenuButton(context),
      //     )
      //   ],
      // ),
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                // Tela do Calendário
                const CalendarPage(),
                HomePageContent(userData: widget.userData),
                ProfilePage(userData: widget.userData),
                // DiaristaProfilePage(userData: widget.userData),
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

  const HomePageContent({super.key, required this.userData});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}



class _HomePageContentState extends State<HomePageContent> {
  bool isDark = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding:
              const EdgeInsets.only(top: 15, bottom: 45, left: 80, right: 80),
          alignment: Alignment.center,
          color: Theme.of(context).colorScheme.surface,
        
        ),
       SearchAnchor(
  builder: (BuildContext context, SearchController controller) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff0095FF)), // Adiciona uma borda azul
        borderRadius: BorderRadius.circular(8.0), // Define a borda arredondada
        color: Colors.white, // Define o fundo como branco
      ),
      child: SearchBar(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
        controller: controller,
        padding: const WidgetStatePropertyAll<EdgeInsets>(
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
  suggestionsBuilder: (BuildContext context, SearchController controller) {
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


        // Container(
        //   color: Theme.of(context).colorScheme.background,
        //   child: TextField(
        //     decoration: InputDecoration(
        //       prefixIcon: Icon(Icons.search),
        //       hintText: 'Pesquisar...',
        //     ),
        //     onTap: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => PesquisapageWidget()),
        //       );
        //     },
        //   ),
        // ),
        Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Solicitações de Serviços:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
