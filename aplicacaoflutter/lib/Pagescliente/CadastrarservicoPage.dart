import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:servicocerto/Controller/ServiceController.dart';
import 'package:servicocerto/Models/Service.dart';

class ServiceRegistrationPage extends StatelessWidget {
  final TextEditingController _descricaoController = TextEditingController();

  void _cadastrarServico() {
    String descricao = _descricaoController.text.trim();

    if (descricao.isNotEmpty) {
      ServiceModel service = ServiceModel(descricao: descricao);
      ServiceController.instance.createService(service);
    } else {
      Get.snackbar(
        "Erro",
        "Por favor, preencha todos os campos.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Serviço'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(labelText: 'Descrição do Serviço'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _cadastrarServico,
              child: Text('Cadastrar Serviço'),
            ),
          ],
        ),
      ),
    );
  }
}
