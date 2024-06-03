import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:servicocerto/Components/ChatBubble.dart';
import 'package:servicocerto/Components/MyTextField.dart';
import 'package:servicocerto/Services/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
 
  const ChatPage({
    super.key,
    required this.receiverUserEmail,
    });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  void sendMessage() async {
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverUserEmail, _messageController.text);
      _messageController.clear();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail, style: const TextStyle(color:Colors.white )),
        backgroundColor: Colors.blue,
      ),
      
      body: Column(
        children: [
          //MENSAGENS
          Expanded(
            child: _buildMessageList(),
          ),


          //Input do Usuário
          _buildMessageInput()
        ],
      ),
    );
  }


  //MESSAGE LIST
Widget _buildMessageList(){
  return StreamBuilder(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Text('Carregando...');
      }
      
      if (snapshot.hasError) {
        return Text('Erro: ${snapshot.error}');
      }
      
      if (snapshot.hasData && snapshot.data != null) {
        User user = snapshot.data as User;
        
        return StreamBuilder(
          stream: _chatService.getMessages(widget.receiverUserEmail, user.email!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Carregando...');
            }
            
            if (snapshot.hasError) {
              return Text('Erro: ${snapshot.error}');
            }
            
            if (!snapshot.hasData || snapshot.data == null) {
              return const Text('Sem mensagens');
            }
            
            return ListView(
              children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
            );
          },
        );
      } else {
        return const Text('Usuário não autenticado');
      }
    },
  );
}



  //MESSAGE ITEM
  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    bool isCurrentUser = (data['senderEmail'] == _firebaseAuth.currentUser!.email);
    var alignment = isCurrentUser
    ? Alignment.centerRight 
    : Alignment.centerLeft;


    return Container(
      alignment: alignment,
      child: Column(
        children: [
          ChatBubble(message: data['message'], isCurrentUser: isCurrentUser),
        ],
      ));


  }









  //MESSAGE INPUT
  Widget _buildMessageInput(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              hintText: "Mensagem", 
              isObscure: false, 
              controller: _messageController,
            )
          ),
      
      
          Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage, 
              icon: const Icon(
                Icons.arrow_upward, 
                color: Colors.white,
                size: 40,)))
      
        ],
      ),
    );
  }
}