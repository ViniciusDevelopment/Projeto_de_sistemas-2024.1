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
