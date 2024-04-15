import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:servicocerto/Controller/authCheck.dart';
import 'package:servicocerto/ReadData/get_user_name.dart';
import 'package:servicocerto/pages/UserInfoPage.dart';


class HomePage extends StatefulWidget {
   HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}



    /*CircleAvatar(
      radius: 20,
      backgroundColor: Colors.white,
      child: IconButton(
        icon: const Icon(
          Icons.person,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserInfoPage()),
          );
        },
        
      ),
    );*/
  

class _HomePageState extends State<HomePage> {

  final User? user = Authentication().currentUser;

  


  Future<void> signOut() async {
    await Authentication().signOut();
  }

  

  Widget _userId() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text('Sign Out'));

  }

  
    // Função para ir para a página do perfil
  Widget _myProfile(BuildContext context) {
      return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserInfoPage()),
          );
        },
        child: const Text('Meu Perfil'),
      );
    }


  Widget _userMenuButton(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.white,
      child: PopupMenuButton(
        icon: const Icon(
          Icons.person,
          color: Colors.black,
        ),
        
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          //IR PARA O PERFIL
           PopupMenuItem(child: _myProfile(context)),

          //DESLOGAR
           PopupMenuItem(child: _signOutButton())
          
        ],
      ),
    );
  }


  
  //DOCUMENTAR OS IDS
  List<String> docIDs = [];

  //PEGAR OS IDS
  Future getDocId() async{
    await FirebaseFirestore.instance.collection('Users').get().then(
      (snapshot) => snapshot.docs.forEach((document) {
        docIDs.add(document.reference.id);
      }
    )
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //BARRA SUPERIOR
      appBar: AppBar(
        backgroundColor: Colors.blue,

        //TEXTO
        centerTitle: true,
        title: const Text("Início", style: TextStyle(color: Colors.white)),

        //FOTO DE PERFIL MENU
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 24),
            child: _userMenuButton(context),
            
          )],
      ),


      //CORPO DA TELA INICIAL
      body: Column(
        children: [
         
        //MENSAGEM DE BEM VINDO
          Container(
            padding: const EdgeInsets.only(top: 15, bottom: 45, left: 80, right: 80),
            alignment: Alignment.center,
            color: Theme.of(context).colorScheme.background,
            
            child: const Text(
              'Bem Vindo', 
              style: TextStyle(
                color: Colors.blue, 
                fontSize: 16
               
                ),
                 )),




            //BARRA DE PESQUISA
            /*




            */
          
          //RECOMENDAÇÕES DE PERFIL
          Container(
            color: Theme.of(context).colorScheme.background, // Cor de fundo do Container
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            alignment: Alignment.centerLeft ,
            child: const Text(
              'Recomendações:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(future: getDocId(), builder: ((context, snapshot) {
              
              return ListView.builder(
              itemCount: docIDs.length,
              itemBuilder: (context, index) {
                return 
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 15),
                   child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                     child: ListTile(
                        leading: const Icon(Icons.person),
                        title: GetUserName(documentId: docIDs[index]),
                        tileColor: const Color.fromARGB(255, 242, 145, 180),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.black)
                        ),
                        
                        
                      ),
                   ),
                 );
                },
              );
            }))
            ),
    
          ],
      ),
        );
 
  }
}