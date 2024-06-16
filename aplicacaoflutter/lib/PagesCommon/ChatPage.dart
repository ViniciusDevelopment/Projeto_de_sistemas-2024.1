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
  late String receiverUserName;
  late String receiverUserPhotoUrl;
  bool _isLoading = true; 

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  @override
  void initState() {
    super.initState();
    // Carregar dados do usuário que está recebendo mensagens
    _loadReceiverUserData();
  }

 void _loadReceiverUserData() async {
  try {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.receiverUserEmail)
        .get();

    if (userSnapshot.exists) {
      setState(() {
        receiverUserName = userSnapshot['Name']; 
        receiverUserPhotoUrl = userSnapshot['photoURL']; // URL da foto do usuário
        _isLoading = false; // Dados carregados, portanto, não estamos mais carregando
      });
    } else {
      setState(() {
        _isLoading = false; // Não há dados, mas não estamos mais carregando
      });
    }
  } catch (e) {
    print('Erro ao carregar dados do usuário: $e');
    setState(() {
      _isLoading = false; // Erro ao carregar, não estamos mais carregando
    });
  }
}

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
      title: _isLoading
          ? CircularProgressIndicator() // Indicador de carregamento
          : Row(
              children: [
                receiverUserPhotoUrl != ""
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(receiverUserPhotoUrl),
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                const SizedBox(width: 8),
                Text(receiverUserName ?? 'Carregando...', style: const TextStyle(color: Colors.white)),
              ],
            ),
      backgroundColor: Colors.blue,
      iconTheme: const IconThemeData(color: Colors.white),
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