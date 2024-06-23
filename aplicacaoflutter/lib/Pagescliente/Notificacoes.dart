import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key});

  @override
  _NotificacoesPageState createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  late Future<List<Map<String, dynamic>>> _notificacoesFuture;

  @override
  void initState() {
    super.initState();
    _notificacoesFuture = _fetchNotificacoes();
  }

  Future<List<Map<String, dynamic>>> _fetchNotificacoes() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Notificacoes')
              .where('emailCliente', isEqualTo: user.email)
              .get();

      // Converte os documentos em uma lista de mapas e inverte a ordem
      List<Map<String, dynamic>> notificacoes =
          querySnapshot.docs.map((doc) => doc.data()).toList();
      notificacoes = notificacoes.reversed.toList();

      return notificacoes;
    } catch (e) {
      print('Erro ao carregar notificações: $e');
      throw Exception('Erro ao carregar notificações');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _notificacoesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar notificações'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma notificação disponível'));
          }

          final notificacoes = snapshot.data!;

          return ListView.builder(
            itemCount: notificacoes.length,
            itemBuilder: (context, index) {
              final notificacao = notificacoes[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    leading: const Icon(
                      Icons.notifications,
                      color: Colors.blueAccent,
                      size: 30,
                    ),
                    title: Text(
                      notificacao['titulo'] ?? 'Retorno de solicitação',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(notificacao['mensagem'] ?? 'Sem mensagem'),
                    onTap: () {},
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
