import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import necessário para FilteringTextInputFormatter
import 'package:get/get.dart';
import 'package:servicocerto/Controller/ServiceController.dart'; // Import corrigido para minúsculas
import 'package:servicocerto/Models/Service.dart'; // Import corrigido para minúsculas

class ServiceRegistrationPage extends StatefulWidget {
  const ServiceRegistrationPage({Key? key}) : super(key: key); // Adicionado key

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
        title: const Text('Cadastro de Serviço'), // Adicionado const
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Adicionado const
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                  labelText: 'Descrição do Serviço'), // Adicionado const
            ),
            const SizedBox(height: 20.0), // Adicionado const
            TextField(
              controller: _valorController,
              decoration: const InputDecoration(
                  labelText: 'Valor do Serviço em reais'), // Adicionado const
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            const SizedBox(height: 20.0), // Adicionado const
            TextField(
              controller: _disponibilidadeController,
              decoration: const InputDecoration(
                  labelText: 'Disponibilidade de Horário'), // Adicionado const
            ),
            const SizedBox(height: 20.0), // Adicionado const
            ElevatedButton(
              onPressed: _cadastrarServico,
              child: const Text('Cadastrar Serviço'), // Adicionado const
            ),
          ],
        ),
      ),
    );
  }
}
