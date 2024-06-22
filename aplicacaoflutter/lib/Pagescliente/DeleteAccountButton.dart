import '../main.dart';
import 'package:flutter/material.dart';

class DeleteAccountButton extends StatefulWidget {
  const DeleteAccountButton({super.key});

  @override
  _DeleteAccountButtonState createState() => _DeleteAccountButtonState();
}

class _DeleteAccountButtonState extends State<DeleteAccountButton> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
            Colors.red), // Cor de fundo vermelha
        foregroundColor: WidgetStateProperty.all<Color>(
            Colors.white), // Cor do texto branco
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                  'Para confirmação de apagamento de conta, digite "Apagar Conta":'),
              content: TextField(
                controller: _controller,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Enviar'),
                  onPressed: () {
                    if (_controller.text == 'Apagar Conta') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Conta apagada com sucesso!')),
                      );
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const MyApp()));
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Texto digitado incorreto. Tente novamente.')),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
      child: const Text('Apagar Conta'),
    );
  }
}
