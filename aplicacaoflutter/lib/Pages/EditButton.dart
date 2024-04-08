import 'package:flutter/material.dart';
import 'package:aplicacaoflutter/Pages/EditPage.dart';

class EditButton extends StatefulWidget {
  @override
  _EditButtonState createState() => _EditButtonState();
}

class _EditButtonState extends State<EditButton> {
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            Colors.blue),
        foregroundColor: MaterialStateProperty.all<Color>(
            Colors.white), // Cor do texto branco
      ),
      
      onPressed: () {
        Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPage()),
    );
      }, 
      child:const Text('Editar Conta'),
      
    );
  }
}