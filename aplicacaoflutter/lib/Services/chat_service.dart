import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Models/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ENVIAR MENSAGENS
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

    String chatRoomId = _getChatRoomId(currentUserEmail, receiverEmail);

    // Verifica se o documento da sala de bate-papo já existe
    var chatRoomRef = _firestore.collection('chat_rooms').doc(chatRoomId);
    var chatRoomSnapshot = await chatRoomRef.get();

    if (!chatRoomSnapshot.exists) {
      // Se o documento da sala de bate-papo não existir, cria um novo
      await chatRoomRef.set({
        // Aqui você pode adicionar outros campos necessários para sua sala de bate-papo
      });
    }

    // Adiciona a mensagem à coleção 'messages' dentro do documento da sala de bate-papo
    await chatRoomRef.collection('messages').add(newMessage.toMap());
  }

  // LER AS MENSAGENS
  Stream<QuerySnapshot> getMessages(String userEmail, String otherUserEmail) {
    String chatRoomId = _getChatRoomId(userEmail, otherUserEmail);

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Método para obter o ID da sala de bate-papo
  String _getChatRoomId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();
    return ids.join("__");
  }
}
