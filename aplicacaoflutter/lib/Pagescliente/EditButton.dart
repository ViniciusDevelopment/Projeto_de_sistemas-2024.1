import 'package:flutter/material.dart';
import 'EditPage.dart';

class EditButton extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditButton({Key? key, required this.userData}) : super(key: key);

  @override
  _EditButtonState createState() => _EditButtonState();
}

class _EditButtonState extends State<EditButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        foregroundColor: MaterialStateProperty.all<Color>(
            Colors.white), // Cor do texto branco
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditPage(userData: widget.userData),
          ),
        );
      },
      child: const Text('Editar Conta'),
    );
  }
}
