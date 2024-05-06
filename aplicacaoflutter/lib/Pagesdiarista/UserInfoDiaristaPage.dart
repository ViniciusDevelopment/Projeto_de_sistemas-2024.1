import 'dart:js';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servicocerto/PagesCliente/CadastrarservicoPage.dart';
import 'package:servicocerto/Pagescliente/DeleteAccountButton.dart';
import 'package:servicocerto/Pagescliente/EditButton.dart';
import 'package:servicocerto/Pagescliente/EditPage.dart';

class DiaristaProfilePage extends StatelessWidget {

  final Map<String, dynamic> userData;
  const DiaristaProfilePage({Key? key, required this.userData}) : super(key: key);


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: const Text(
          'Meu Perfil - Diarista',
          style: TextStyle(
            fontFamily: 'Outfit',
            color: Colors.white,
            fontSize: 22,
            letterSpacing: 0,
          ),
        ),
        centerTitle: false,
        elevation: 2,
      ),
      body:  SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            

            // Exibir a imagem do usuário
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50, // Tamanho da imagem do perfil
              backgroundImage: //_userData['photoURL'] != null
                  NetworkImage(
                      'https://cdn.pixabay.com/photo/2017/02/13/16/58/signal-2063096_1280.png'), // Carrega a imagem do usuário a partir da URL
              //: AssetImage('assets/images/default_profile_image.png'), // Imagem padrão se não houver URL
            ),




            const SizedBox(height: 20),
            Text(
              userData['Name'] ?? 'Nome do Usuário',
              style: TextStyle(
                fontFamily: 'Readex Pro',
                fontSize: 24,
                letterSpacing: 0,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Mostrar informações do usuário
            _buildUserInfoTile('Telefone', userData['Telefone']),
            _buildUserInfoTile('Email', userData['Email']),
            _buildUserInfoTile('Endereco', userData['Endereco']),
            const SizedBox(height: 20),
            // Botões de edição e exclusão
            Row(
              children: [
                  Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                      style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                            foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white), // Cor do texto branco
                      ),
                      onPressed: () {
                      _cadastrarServico(context); // Passando o contexto
                    },
                      child: const Text('Cadastrar serviço'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: EditButton()
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: DeleteAccountButton()
                ),

              
              ],
            ),
          ],
        ),
      ),
    );
  }




  Widget _buildUserInfoTile(String title, String? value) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Readex Pro',
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        value ?? 'Informação não encontrada',
        style: const TextStyle(
          fontFamily: 'Readex Pro',
          fontSize: 16,
        ),
      ),
    );
  }


  void _cadastrarServico(BuildContext context) {
    // Navegar para a página de cadastro de serviço quando o botão for pressionado
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ServiceRegistrationPage()),
    );
  }
}




