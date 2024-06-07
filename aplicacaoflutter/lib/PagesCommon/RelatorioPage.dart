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
        automaticallyImplyLeading: false, // Remove o botão de voltar
        backgroundColor: Colors.white, // Define o fundo como branco
        title: const Text('Relatorio',
            style: TextStyle(color: Colors.black)), // Define o título da página
      ),
      body: Column(
        children: [
          Expanded(
            child:
                Text("Relatório", style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
