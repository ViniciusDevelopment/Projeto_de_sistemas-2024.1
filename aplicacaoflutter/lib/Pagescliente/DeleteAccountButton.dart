import 'package:flutter/material.dart';
import '../main.dart';

class DeleteAccountButton extends StatefulWidget {
  @override
  _DeleteAccountButtonState createState() => _DeleteAccountButtonState();
}

class _DeleteAccountButtonState extends State<DeleteAccountButton> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.delete, color: Colors.red), // Ícone de exclusão
      title: Text(
        'Excluir conta',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.red, // Cor do texto vermelho para indicar perigo
        ),
      ),
      onTap: () {
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
    );
  }
}
