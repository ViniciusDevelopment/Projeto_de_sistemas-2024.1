import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import necessário para FilteringTextInputFormatter
import 'package:get/get.dart';
import 'package:servicocerto/Controller/ServiceController.dart';
import 'package:servicocerto/Models/Service.dart';

class ServiceRegistrationPage extends StatefulWidget {
  @override
  _ServiceRegistrationPageState createState() =>
      _ServiceRegistrationPageState();
}

class _ServiceRegistrationPageState extends State<ServiceRegistrationPage> {
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _disponibilidadeController =
      TextEditingController();

  void _cadastrarServico() {
    String descricao = _descricaoController.text.trim();
    String valor = _valorController.text.trim();
    String disponibilidade = _disponibilidadeController.text.trim();

    if (descricao.isNotEmpty &&
        valor.isNotEmpty &&
        disponibilidade.isNotEmpty) {
      ServiceModel service = ServiceModel(
        descricao: descricao,
        valor: double.parse(valor),
        disponibilidade: disponibilidade,
      );
      ServiceController.instance.createService(service);

      Navigator.pop(context);
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
            TextField(
              controller: _valorController,
              decoration:
                  InputDecoration(labelText: 'Valor do Serviço em reais'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _disponibilidadeController,
              decoration:
                  InputDecoration(labelText: 'Disponibilidade de Horário'),
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
