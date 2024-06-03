import 'package:flutter/material.dart';


class ChatBubble extends StatelessWidget {

  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message, 
    required this.isCurrentUser
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.blue[500] : Colors.grey[500],
        borderRadius: BorderRadius.circular(15)
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(top: 25, left: 15, right: 15),

      child: Text(message, style: const TextStyle(color: Colors.white),),
    );
  }
}