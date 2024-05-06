/*import 'Controller/authCheck.dart';
import 'PagesCliente/loginPage.dart';
import 'package:flutter/material.dart';
import 'Pagesdiarista/homePagediarista.dart';
import 'PagesCliente/homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Authentication().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final user = Authentication().currentUser;
        if (user != null) {
          print("Usuário autenticado: ${user.email}");
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('Users')
                .doc(user.email)
                .get(),
            builder: (context, documentSnapshot) {
              if (documentSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (documentSnapshot.hasData &&
                  documentSnapshot.data != null &&
                  documentSnapshot.data!.exists) {
                final tipoUser = documentSnapshot.data!['TipoUser'];
                print("Tipo de usuário: $tipoUser");
                if (tipoUser == 'Prestador') {
                  return const HomePagediarista();
                } else {
                  return const HomePage();
                }
              } else {
                // Usuário não encontrado no Firestore, você pode tratar isso de acordo com sua lógica
                print("Usuário não encontrado no Firestore");
                return const LoginPage(); // ou outro tratamento que você preferir
              }
            },
          );
        } else {
          // Nenhum usuário autenticado
          print("Nenhum usuário autenticado");
          return const LoginPage();
        }
      },
    );
  }
}
*/

/*import 'package:servicocerto/Pagesdiarista/homePagediarista.dart';

import 'Controller/authCheck.dart';
import 'Pagescliente/homePage.dart';
import 'Pagescliente/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Authentication().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final user = Authentication().currentUser;
          if (user != null) {
            return FutureBuilder<DocumentSnapshot>(
              future:
                  FirebaseFirestore.instance.collection('Users').doc().get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (userSnapshot.hasError) {
                  return Text('Error: ${userSnapshot.error}');
                } else {
                  final userData = userSnapshot.data?.data();
                  final Map<String, dynamic>? userDataMap = userData as Map<
                      String,
                      dynamic>?; // Convertendo para Map<String, dynamic>
                  final userType = userDataMap?['TipoUser'];
                  final usercel = userDataMap?['telefone'];
                  print("Tipo de usuário:  ${userType}");
                  print("Telefone de usuario: ${usercel}");
                  if (userType == 'Prestador') {
                    return HomePagediarista();
                  } else {
                    return HomePage();
                  }
                }
              },
            );
          }
        }
        return LoginPage();
      },
    );
  }
}*/

/*import 'Controller/authCheck.dart';
import 'PagesCliente/loginPage.dart';
import 'package:flutter/material.dart';
import 'Pagesdiarista/homePagediarista.dart';
import 'PagesCliente/homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Authentication().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final user = Authentication().currentUser;
        if (user != null) {
          print("Usuário autenticado: ${user.email}");
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('Users')
                .doc(user.email)
                .get(),
            builder: (context, documentSnapshot) {
              if (documentSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (documentSnapshot.hasData &&
                  documentSnapshot.data != null &&
                  documentSnapshot.data!.exists) {
                final tipoUser = documentSnapshot.data!['TipoUser'];
                print("Tipo de usuário: $tipoUser");
                if (tipoUser == 'Prestador') {
                  return const HomePagediarista();
                } else {
                  return const HomePage();
                }
              } else {
                // Usuário não encontrado no Firestore, você pode tratar isso de acordo com sua lógica
                print("Usuário não encontrado no Firestore");
                return const LoginPage(); // ou outro tratamento que você preferir
              }
            },
          );
        } else {
          // Nenhum usuário autenticado
          print("Nenhum usuário autenticado");
          return const LoginPage();
        }
      },
    );
  }
}
*/
/*
import 'package:servicocerto/Pagesdiarista/homePagediarista.dart';

import 'Controller/authCheck.dart';
import 'Pagescliente/homePage.dart';
import 'Pagescliente/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Authentication().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final user = Authentication().currentUser;
          if (user != null) {
            return FutureBuilder<DocumentSnapshot>(
              future:
                  FirebaseFirestore.instance.collection('Users').doc().get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (userSnapshot.hasError) {
                  return Text('Error: ${userSnapshot.error}');
                } else {
                  final userData = userSnapshot.data?.data();
                  final Map<String, dynamic>? userDataMap = userData as Map<
                      String,
                      dynamic>?; // Convertendo para Map<String, dynamic>
                  final userType = userDataMap?['TipoUser'];
                  final usercel = userDataMap?['Telefone'];
                  final username = userDataMap?['Name'];
                  print("Usuario logado: ${Authentication().currentUser}");
                  print("Tipo de usuário:  ${userType}");
                  print("Telefone de usuario: ${usercel}");
                  print("Nome do usuario: ${username}");

                  if (userType == 'Prestador') {
                    return HomePagediarista();
                  } else {
                    return HomePage();
                  }
                }
              },
            );
          }
        }
        return LoginPage();
      },
    );
  }
}*/

import 'package:servicocerto/Pagesdiarista/homePagediarista.dart';
import 'package:servicocerto/Pagescliente/homePage.dart';
import 'package:servicocerto/Pagescliente/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user.email) // Use o e-mail como ID do documento
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (userSnapshot.hasError) {
                  return Text('Error: ${userSnapshot.error}');
                } else {
                  if (userSnapshot.hasData && userSnapshot.data!.exists) {
                    final userData =
                        userSnapshot.data!.data() as Map<String, dynamic>;
                    print("Dados do usuário: $userData");
                    final userType = userData['TipoUser'];
                    print("Tipo de usuário: $userType");

                    if (userType == 'Prestador') {
                      return HomePagediarista(userData: userData);
                    } else {
                      return HomePage(userData: userData);
                    }
                  } else {
                    print("Dados do usuário são nulos");
                    return LoginPage();
                  }
                }
              },
            );
          }
        }
        return LoginPage(); // Adicionado um return para evitar o erro
      },
    );
  }
}
