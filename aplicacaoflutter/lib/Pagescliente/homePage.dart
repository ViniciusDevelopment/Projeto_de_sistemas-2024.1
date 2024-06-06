import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:servicocerto/Controller/authCheck.dart';
import 'package:servicocerto/PagesCommon/ProfilePage.dart';
import 'package:servicocerto/PagesCommon/RelatorioPage.dart';
import 'package:servicocerto/Pagescliente/SearchPage.dart';
import 'package:servicocerto/Repository/UserRepository.dart';
import 'package:servicocerto/PagesCommon/calendarPage.dart';
import 'package:servicocerto/Pagescliente/outroUserPage.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  const HomePage({Key? key, required this.userData}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Authentication().currentUser;

  Future<void> signOut() async {
    await Authentication().signOut();
  }

  int _selectedIndex = 1; // Defina o índice inicial como 1 (tela inicial)

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      CalendarPage(),
      HomePageContent(userData: widget.userData),
      RelatorioPage(),
      ProfilePage(userData: widget.userData),
    ];
  }

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
                RelatorioPage(),
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
        padding: EdgeInsets.only(bottom: 4), // Adicionando espaçamento inferior ao ícone
        child: Icon(Iconsax.calendar),
      ), 
      label: 'Calendário',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 4), // Adicionando espaçamento inferior ao ícone
        child: Icon(Iconsax.home),
      ), 
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 4), // Adicionando espaçamento inferior ao ícone
        child: Icon(Iconsax.wallet),
      ), 
      label: 'Relatórios',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 4), // Adicionando espaçamento inferior ao ícone
        child: Icon(Iconsax.user),
      ), 
      label: 'Perfil',
    ),
  ],
  selectedItemColor: Colors.blue, // Cor dos itens selecionados
  unselectedItemColor: Colors.grey[700], // Cor dos itens não selecionados
  iconSize: 24,
  selectedFontSize: 14, // Tamanho da fonte dos itens selecionados
  unselectedFontSize: 14, // Tamanho da fonte dos itens não selecionados
  showSelectedLabels: true, // Mostrar rótulos dos itens selecionados
  showUnselectedLabels: true, // Mostrar rótulos dos itens não selecionados
  selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto'), // Estilo do rótulo dos itens selecionados
  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'Roboto'), // Estilo do rótulo dos itens não selecionados
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
  @override
  void initState() {
    super.initState();
    context.read<UserRepository>().fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                hintText: 'Pesquisar...',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(16.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PesquisapageWidget()),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Recomendações:',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Consumer<UserRepository>(
              builder: (context, userRepository, child) {
                if (userRepository.listaDeUsuarios.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: userRepository.listaDeUsuarios.length,
                    itemBuilder: (context, index) {
                      final user = userRepository.listaDeUsuarios[index];
                      return Card(
                        elevation: 0,
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: user.photoURL != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(user.photoURL!),
                                  radius: 30,
                                )
                              : const CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 30,
                                  child:
                                      Icon(Icons.person, color: Colors.white),
                                ),
                          title: Text(
                            user.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(user.descricao),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OutroUserPage(email: user.email),
                              ),
                            );
                          },
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
