import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class RelatorioPage extends StatefulWidget {
 
  const RelatorioPage({
    super.key,
    });

  @override
  State<RelatorioPage> createState() => _RelatorioPageState();
}

class _RelatorioPageState extends State<RelatorioPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Relatorio", style: const TextStyle(color:Colors.white )),
        backgroundColor: Colors.blue,
      ),
      
      body: Column(
        children: [
          //MENSAGENS
          Expanded(
            child: Text("Relatorio", style: const TextStyle(color:Colors.white )),
          ),



        ],
      ),
    );
  }
}