import 'package:aplicacaoflutter/main.dart';
import 'package:flutter/material.dart';

class DeleteAccountButton extends StatefulWidget {
  @override
  _DeleteAccountButtonState createState() => _DeleteAccountButtonState();
}

class _DeleteAccountButtonState extends State<DeleteAccountButton> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            Colors.red), // Cor de fundo vermelha
        foregroundColor: MaterialStateProperty.all<Color>(
            Colors.white), // Cor do texto branco
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                  'Para confirmação de apagamento de conta, digite "Apagar Conta":'),
              content: TextField(
                controller: _controller,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Enviar'),
                  onPressed: () {
                    if (_controller.text == 'Apagar Conta') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Conta apagada com sucesso!')),
                      );
                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyApp()));
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
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
      child: Text('Apagar Conta'),
    );
  }
}
