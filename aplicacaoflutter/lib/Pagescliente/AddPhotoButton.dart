import 'package:flutter/material.dart';
import '../PagesCommon/AddPhotoPage.dart';

class AddPhotoButton extends StatefulWidget {
  const AddPhotoButton({super.key});

  @override
  _AddPhotoButtonState createState() => _AddPhotoButtonState();
}

class _AddPhotoButtonState extends State<AddPhotoButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
        foregroundColor: WidgetStateProperty.all<Color>(
            Colors.white), // Cor do texto branco
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddPhotoPage()),
        );
      },
      child: const Text('Adicionar foto de peril'),
    );
  }
}
