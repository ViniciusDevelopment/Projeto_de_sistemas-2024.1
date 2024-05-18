import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:servicocerto/Controller/authCheck.dart';
import 'package:servicocerto/PagesCommon/AddPhotoPage.dart';
import 'package:servicocerto/Pagescliente/CadastrarservicoPage.dart';
import 'package:servicocerto/Pagescliente/EditPage.dart';
import 'package:servicocerto/Pagescliente/homePage.dart';
import 'package:servicocerto/Pagesdiarista/MeusServicosPage.dart';
import 'package:servicocerto/Pagesdiarista/profile_list_item.dart';

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
        // Envolve a Column em um Center para centralizar horizontalmente
        child: Container(
          // Envolve o Expanded em um Container
          width: double.infinity, // Define a largura do Container
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .center, // Alinha os elementos horizontalmente
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
                                  builder: (context) => AddPhotoPage()));
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
                      )
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
                  userData['Email'] ?? 'email do Usuário',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color(0xFF212121),
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Navega para a página "EditarPerfil.dart" quando o contêiner for clicado
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditPage()),
                    );
                  },
                  child: Container(
                    height: 40,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xff0095FF),
                    ),
                    child: Center(
                      child: Text(
                        'Editar Perfil',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
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
                        icon: LineAwesomeIcons.history,
                        text: 'Excluir conta',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ServiceRegistrationPage()),
                          );
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
