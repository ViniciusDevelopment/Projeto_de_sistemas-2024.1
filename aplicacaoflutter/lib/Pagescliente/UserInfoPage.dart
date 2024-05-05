/*import 'DeleteAccountButton.dart';
import 'EditButton.dart';
import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: const Align(
          alignment: AlignmentDirectional(0, 0),
          child: Text(
            'Informações do Usuário',
            style: TextStyle(
              fontFamily: 'Outfit',
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 0,
            ),
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: AlignmentDirectional(0, 1),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  'https://images.unsplash.com/photo-1525357816819-392d2380d821?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMXx8cHJvZmlsZSUyMGljb258ZW58MHx8fHwxNzEyNTM1NTA2fDA&ixlib=rb-4.0.3&q=80&w=1080',
                  width: 152,
                  height: 152,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const Text(
              'Erasmo Vieira',
              style: TextStyle(
                fontFamily: 'Readex Pro',
                fontSize: 24,
                letterSpacing: 0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              width: 264,
              height: 239,
              decoration: const BoxDecoration(
                color: Colors.white24,
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: AlignmentDirectional(-1, 0),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Telefone: (63)98877-6655',
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(-1, 0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                      child: Text(
                        'Email: erasmo@email.com',
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(-1, 0),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Endereço: 108 Norte Al02 Lt11',
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(children: [
              Padding(
                padding: EdgeInsets.all(40),
                child: EditButton(),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: DeleteAccountButton(),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}*/

/*import 'DeleteAccountButton.dart';
import 'EditButton.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late User _user;
  late DocumentSnapshot _userSnapshot;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_user.uid)
        .get();
    setState(() {
      _userSnapshot = userSnapshot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: const Align(
          alignment: AlignmentDirectional(0, 0),
          child: Text(
            'Informações do Usuário',
            style: TextStyle(
              fontFamily: 'Outfit',
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 0,
            ),
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: AlignmentDirectional(0, 1),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  'https://images.unsplash.com/photo-1525357816819-392d2380d821?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMXx8cHJvZmlsZSUyMGljb258ZW58MHx8fHwxNzEyNTM1NTA2fDA&ixlib=rb-4.0.3&q=80&w=1080', // Assuming you have a photoUrl field
                  width: 152,
                  height: 152,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Text(
              _userSnapshot['Name'] ?? '', // Assuming you have a name field
              style: TextStyle(
                fontFamily: 'Readex Pro',
                fontSize: 24,
                letterSpacing: 0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              width: 264,
              height: 239,
              decoration: const BoxDecoration(
                color: Colors.white24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: AlignmentDirectional(-1, 0),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Telefone: ${_userSnapshot['Telefone'] ?? ''}', // Assuming you have a phone field
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(-1, 0),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                      child: Text(
                        'Email: ${_user.email}', // Use the email from Firebase Auth
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(-1, 0),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Endereço: ${_userSnapshot['Endereco'] ?? ''}', // Assuming you have an address field
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(children: [
              Padding(
                padding: const EdgeInsets.all(40),
                child: EditButton(),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: DeleteAccountButton(),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    if (_currentUser != null) {
      await _getUserData(_currentUser!.uid);
    }
  }

  Future<void> _getUserData(String userId) async {
    final userData =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    setState(() {
      _userData = userData.data() ?? {};
    });
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
            // Adicione sua lógica para mostrar a imagem do usuário
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
                  child: ElevatedButton(
                    onPressed: () {
                      // Lógica para editar o perfil
                    },
                    child: const Text('Editar'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      // Lógica para excluir a conta
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Excluir'),
                  ),
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
