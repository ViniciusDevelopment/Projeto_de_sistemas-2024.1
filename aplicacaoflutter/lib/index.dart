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
                  final userType = userDataMap?['TipoUser'] ?? '';
                  print("Tipo de usuário:  ${userType}");
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
}






/*-------------------------INDEX ANTIGA-------------------------
import 'Controller/authCheck.dart';
import 'Pages/homePage.dart';
import 'Pages/loginPage.dart';
import 'package:flutter/material.dart';

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
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return const LoginPage();
          }
        });
  }
}*/

/*------------------INDEX TESTE:----------------------
import 'Controller/authCheck.dart';
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
