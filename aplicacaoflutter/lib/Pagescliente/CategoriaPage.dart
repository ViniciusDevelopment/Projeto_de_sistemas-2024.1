import 'package:flutter/material.dart';

class CategoriaPage extends StatefulWidget {
  final String nome;

  const CategoriaPage({super.key, required this.nome});

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
        iconTheme: const IconThemeData(color: Colors.blue),
        titleTextStyle: const TextStyle(color: Colors.blue, fontSize: 20),
      ),
      body: Center(
        child: Text(
          'Conteúdo da Categoria: ${widget.nome}',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: CategoriaPage(nome: 'Categoria Exemplo'),
  ));
}
