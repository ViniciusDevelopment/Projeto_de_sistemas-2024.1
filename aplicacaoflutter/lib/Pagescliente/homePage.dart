import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:servicocerto/Controller/authCheck.dart';
import 'package:servicocerto/DTO/Request/MenuItem.dart';
import 'package:servicocerto/PagesCommon/ChatListPage.dart';
import 'package:servicocerto/PagesCommon/ProfilePage.dart';
import 'package:servicocerto/PagesCommon/RelatorioPage.dart';
import 'package:servicocerto/Pagescliente/CategoriaPage.dart';
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
                  padding: EdgeInsets.only(
                      bottom: 4), // Adicionando espaçamento inferior ao ícone
                  child: Icon(Iconsax.calendar),
                ),
                label: 'Calendário',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(
                      bottom: 4), // Adicionando espaçamento inferior ao ícone
                  child: Icon(Iconsax.home),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(
                      bottom: 4), // Adicionando espaçamento inferior ao ícone
                  child: Icon(Iconsax.wallet),
                ),
                label: 'Relatórios',
              ),
               BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4), // Adicionando espaçamento inferior ao ícone
                  child: Icon(Iconsax.message),
                ), 
                label: 'Conversas',
                ),

              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(
                      bottom: 4), // Adicionando espaçamento inferior ao ícone
                  child: Icon(Iconsax.user),
                ),
                label: 'Perfil',
              ),
            ],
            selectedItemColor: Colors.blue, // Cor dos itens selecionados
            unselectedItemColor:
                Colors.grey[700], // Cor dos itens não selecionados
            iconSize: 24,
            selectedFontSize: 14, // Tamanho da fonte dos itens selecionados
            unselectedFontSize:
                14, // Tamanho da fonte dos itens não selecionados
            showSelectedLabels: true, // Mostrar rótulos dos itens selecionados
            showUnselectedLabels:
                true, // Mostrar rótulos dos itens não selecionados
            selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily:
                    'Roboto'), // Estilo do rótulo dos itens selecionados
            unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily:
                    'Roboto'), // Estilo do rótulo dos itens não selecionados
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

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);

    final firstCurve = Offset(0, size.height - 20);
    final lastCurve = Offset(30, size.height - 20);
    path.quadraticBezierTo(
        firstCurve.dx, firstCurve.dy, lastCurve.dx, lastCurve.dy);

    final secondFirstCurve = Offset(0, size.height - 20);
    final secondLastCurve = Offset(size.width - 30, size.height - 20);
    path.quadraticBezierTo(secondFirstCurve.dx, secondFirstCurve.dy,
        secondLastCurve.dx, secondLastCurve.dy);

    final thirdFirstCurve = Offset(size.width, size.height - 20);
    final thirdLastCurve = Offset(size.width, size.height);
    path.quadraticBezierTo(thirdFirstCurve.dx, thirdFirstCurve.dy,
        thirdLastCurve.dx, thirdLastCurve.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; // Não é necessário recalcular o clipper
  }
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  void initState() {
    super.initState();
    context.read<UserRepository>().fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final List<MenuItem> menuItems = [
      MenuItem(Iconsax.location, 'Limpeza'),
      MenuItem(Iconsax.home, 'Alimentação'),
      MenuItem(Iconsax.wallet, 'Cuidados Pessoais'),
      MenuItem(Iconsax.user, 'Jardinagem'),
      // Adicione mais itens conforme necessário
    ];

    void _onItemTapped(BuildContext context, String name) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategoriaPage(nome: name)),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ClipPath(
            clipper: MyCustomClipper(),
            child: Container(
              color: Colors.blue,
              padding: const EdgeInsets.all(0),
              child: SizedBox(
                height: 400,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 400,
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(400),
                        color: Colors.blue,
                      ),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Appbar

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 45, horizontal: 16.0),
                            child: Text("Olá, João Diarista",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold)),
                          ),

                          // const SizedBox(height: 40),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search,
                                    color: Colors.blue),
                                hintText: 'Pesquisar...',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.all(16.0),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PesquisapageWidget()),
                                );
                              },
                            ),
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text("Categorias",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  height: MediaQuery.of(context).size.width *
                                      0.20, // Defina uma altura suficiente para o ListView.builder
                                  child: ListView.builder(
                                    scrollDirection: Axis
                                        .horizontal, // Define a rolagem horizontal
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 0),
                                    itemCount: menuItems.length,
                                    itemBuilder: (context, index) {
                                      final item = menuItems[index];
                                      return GestureDetector(
                                        onTap: () =>
                                            _onItemTapped(context, item.name),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.10,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.10,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Center(
                                                  child: Icon(item.icon,
                                                      color: Colors.blue,
                                                      size: 30),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                item.name,
                                                style: TextStyle(
                                                  color: Colors
                                                      .white, //Deve ser branco sempre
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // SearchBar
                          // Categorias
                        ]),
                  ],
                ),
              ),
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
                          title: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    user.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(width: 5),
                              Row(children: [
                                Text(
                                  '${user.rating}',
                                  style: TextStyle(
                                    color: Colors
                                        .amber, // Cor amarela para o rating
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                              ])
                            ],
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
