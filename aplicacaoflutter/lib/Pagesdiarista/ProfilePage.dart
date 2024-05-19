import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:servicocerto/Controller/authCheck.dart';
import 'package:servicocerto/PagesCommon/AddPhotoPage.dart';
import 'package:servicocerto/Pagescliente/CadastrarservicoPage.dart';
import 'package:servicocerto/Pagescliente/EditPage.dart';
import 'package:servicocerto/Pagesdiarista/MeusServicosPage.dart';
import 'package:servicocerto/Pagesdiarista/profile_list_item.dart';
import '../main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servicocerto/Pagescliente/EditButton.dart';

final User? user = Authentication().currentUser;

Future<void> signOut() async {
  await Authentication().signOut();
}

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ProfilePage({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? photoUrl = userData['photoURL'] as String?;
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 15),
              Container(
                height: 100,
                width: 100,
                margin: EdgeInsets.only(top: 30),
                child: Stack(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                          ? NetworkImage(photoUrl)
                          : AssetImage('assets/images/avatar.png')
                              as ImageProvider,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddPhotoPage()),
                        );
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Color(0xff0095FF),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              LineAwesomeIcons.pen,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                userData['Name'] ?? 'Nome do Usuário',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(height: 5),
              Text(
                userData['Email'] ?? 'Email do Usuário',
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xFF212121),
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w100,
                ),
              ),
              SizedBox(height: 20),
              EditButton(userData: userData), // Adicione o botão de edição aqui
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ProfileListItem(
                      icon: LineAwesomeIcons.user_shield,
                      text: 'Meus Serviços',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MeusServicosPage()),
                        );
                      },
                    ),
                    ProfileListItem(
                      icon: LineAwesomeIcons.alternate_trash,
                      text: 'Excluir conta',
                      onTap: () {
                        showDeleteAccountDialog(context);
                      },
                    ),
                    ProfileListItem(
                      icon: LineAwesomeIcons.question_circle,
                      text: 'Ajuda e Suporte',
                    ),
                    ProfileListItem(
                      icon: LineAwesomeIcons.cog,
                      text: 'Configurações',
                    ),
                    ProfileListItem(
                      icon: LineAwesomeIcons.alternate_sign_out,
                      text: 'Sair',
                      hasNavigation: false,
                      isLastItemRed: true,
                      onTap: () {
                        signOut(); // Executa a função signOut() quando o item "Sair" for clicado
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//função para mostrar a mensagem de confirmação de exclusão

void showDeleteAccountDialog(BuildContext context) {
  final TextEditingController _controller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
            'Para confirmação de apagamento de conta, digite "Apagar Conta":'),
        content: TextField(
          controller: _controller,
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Enviar'),
            onPressed: () async {
              if (_controller.text == 'Apagar Conta') {
                try {
                  // Exclua o documento do usuário no Firestore
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(user!.email)
                      .delete();

                  // Exclua a conta de autenticação do usuário no Firebase
                  await user.delete();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Conta apagada com sucesso!')),
                  );

                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                      (Route<dynamic> route) => false,
                    );
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao apagar conta: $e')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Texto digitado incorreto. Tente novamente.')),
                );
              }
            },
          ),
        ],
      );
    },
  );
}
