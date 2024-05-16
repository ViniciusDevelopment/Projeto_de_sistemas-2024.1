import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servicocerto/Pagescliente/DeleteAccountButton.dart';
import 'package:servicocerto/Pagescliente/EditButton.dart';
import 'package:servicocerto/Pagescliente/EditPage.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late User? _currentUser;
  late Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    setState(() {
      _currentUser = currentUser;
    });
    if (_currentUser != null && _currentUser!.email != null) {
      await _getUserData(_currentUser!.email!);
    }
  }

  Future<void> _getUserData(String userEmail) async {
    final userData = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userEmail)
        .get();

    if (userData.exists) {
      setState(() {
        _userData = userData.data() as Map<String, dynamic>;
      });
    } else {
      print('Dados do usuário não encontrados.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: const Text(
          'Informações do Usuário',
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
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Exibir a imagem do usuário
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 70, // Tamanho da imagem do perfil
              backgroundImage: //_userData['photoURL'] != null
                  NetworkImage(
                      'https://media.licdn.com/dms/image/D5603AQFYXD20YWa4Pg/profile-displayphoto-shrink_800_800/0/1673271268827?e=1720656000&v=beta&t=fBk_xn1aHZHpfGs0k4YhnEpYTjmBrpCJXA04WzMSGLE'), // Carrega a imagem do usuário a partir da URL
              //: AssetImage('assets/images/default_profile_image.png'), // Imagem padrão se não houver URL
            ),
            const SizedBox(height: 20),
            Text(
              _userData['Name'] ?? 'Nome do Usuário',
              style: TextStyle(
                fontFamily: 'Readex Pro',
                fontSize: 24,
                letterSpacing: 0,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Mostrar informações do usuário
            _buildUserInfoTile('Telefone', _userData['Telefone']),
            _buildUserInfoTile('Email', _userData['Email']),
            _buildUserInfoTile('Endereco', _userData['Endereco']),
            const SizedBox(height: 20),
            // Botões de edição e exclusão
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: EditButton(),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: DeleteAccountButton(),
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
}
