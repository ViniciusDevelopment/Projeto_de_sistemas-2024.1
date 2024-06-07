import 'package:flutter/material.dart';

class CategoriaPage extends StatefulWidget {
  final String nome;

  const CategoriaPage({Key? key, required this.nome}) : super(key: key);

  @override
  _CategoriaPageState createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nome),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
        titleTextStyle: TextStyle(color: Colors.blue, fontSize: 20),
      ),
      body: Center(
        child: Text(
          'Conteúdo da Categoria: ${widget.nome}',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CategoriaPage(nome: 'Categoria Exemplo'),
  ));
}
