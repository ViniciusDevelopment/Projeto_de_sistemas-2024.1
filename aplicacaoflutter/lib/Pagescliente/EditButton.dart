import 'package:flutter/material.dart';
import 'EditPage.dart';

class EditButton extends StatefulWidget {
  const EditButton({super.key});

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
              builder: (context) => const EditPage(
                    userData: {},
                  )),
        );
      },
      child: const Text('Editar Conta'),
    );
  }
}
