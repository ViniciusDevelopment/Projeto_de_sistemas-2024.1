
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Models/message.dart';


class ChatService extends ChangeNotifier{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  //ENVIAR MENSAGENS
  Future<void> sendMessage(String receiverEmail, String message) async {
    
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail, 
      receiverEmail: receiverEmail,
      message: message,
      timestamp: timestamp,
    );


    List<String> ids = [currentUserEmail, receiverEmail];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());

  }
    //LER AS MESSAGENS
    Stream<QuerySnapshot> getMessages(String userEmail, String otherUserEmail){

      List<String> ids = [userEmail, otherUserEmail];
      ids.sort();
      String chatRoomId = ids.join("_");

      return _firestore.collection('chat_rooms')
                       .doc(chatRoomId)
                       .collection('messages')
                       .orderBy('timestamp', descending: false)
                       .snapshots();
    }
}