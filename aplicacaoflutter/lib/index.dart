import 'package:servicocerto/Pagescliente/WelcomePage.dart';
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
                    return WelcomePage();
                    // return LoginPage();
                  }
                }
              },
            );
          }
        }
        return WelcomePage(); // Adicionado um return para evitar o erro
      },
    );
  }
}
