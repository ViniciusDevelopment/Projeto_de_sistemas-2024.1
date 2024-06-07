import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:servicocerto/PagesCommon/ChatPage.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    if (currentUserEmail == null) {
      return Scaffold(
        body: Center(
          child: Text('Erro: Não foi possível obter o email do usuário atual.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Conversas', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('chat_rooms').get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final chatRooms = snapshot.data!.docs.where((doc) => doc.id.contains(currentUserEmail)).toList();

          if (chatRooms.isEmpty) {
            return Center(child: Text('Nenhuma conversa encontrada'));
          }

          return ListView(
            children: chatRooms.map((DocumentSnapshot document) {
              String roomId = document.id;
              String otherEmail = roomId.replaceAll(currentUserEmail!, '').replaceAll('__', '');
              
              return FutureBuilder(
                future: FirebaseFirestore.instance.collection('Users').doc(otherEmail).get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (userSnapshot.hasError || !userSnapshot.hasData) {
                    return Text('Erro ao carregar dados do usuário');
                  }
                  var user = userSnapshot.data!;
                  return ListTile(
                    leading: 
                    user['photoURL'] != ""
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(user['photoURL']),
                                  radius: 30,
                                )
                              : const CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 30,
                                  child: Icon(Icons.person, color: Colors.white),
                                ),
                    title: Text(
                      user['Name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(otherEmail),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder:(context)=>ChatPage(receiverUserEmail: otherEmail)));
                    },
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
