import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:servicocerto/Controller/ServiceController.dart'; // Import corrigido para minúsculas
import 'package:servicocerto/Models/Service.dart'; // Import corrigido para minúsculas

class ServiceEditPage extends StatefulWidget {
  final ServiceModel service;

  const ServiceEditPage({Key? key, required this.service}) : super(key: key);

  @override
  _ServiceEditPageState createState() => _ServiceEditPageState();
}

class _ServiceEditPageState extends State<ServiceEditPage> {
  late TextEditingController _descricaoController;
  late TextEditingController _valorController;
  late TextEditingController _disponibilidadeController;

  @override
  void initState() {
    super.initState();
    // Inicializar os controladores com valores existentes
    _descricaoController =
        TextEditingController(text: widget.service.descricao);
    _valorController =
        TextEditingController(text: widget.service.valor.toString());
    _disponibilidadeController =
        TextEditingController(text: widget.service.disponibilidade);
  }

  Future<void> _editarServico() async {
    String descricao = _descricaoController.text.trim();
    String valor = _valorController.text.trim();
    String disponibilidade = _disponibilidadeController.text.trim();

    if (descricao.isNotEmpty &&
        valor.isNotEmpty &&
        disponibilidade.isNotEmpty) {
      ServiceModel updatedService = ServiceModel(
        id: widget.service.id,
        descricao: descricao,
        valor: double.parse(valor),
        disponibilidade: disponibilidade,
        email: widget.service.email,
        categoria: widget.service.categoria,
      );

      if (mounted) {
        await ServiceController.instance.updateService(updatedService);
        Navigator.pop(context); // Redireciona para a página anterior
      } else {
        print("Contexto nulo ou widget não está montado");
      }
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
        title: const Text('Editar Serviço'), // Adicionado const
      ),
      body: SafeArea(
        top: true,
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
                8, 5, 8, 5), // Adicionado const
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 4,
                      color: Color(0x33000000),
                      offset: Offset(0, 2))
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(40, 10, 40, 5),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: const Center(
                        child: Text(
                          'Editar Serviço',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromARGB(255, 45, 96, 234),
                              fontSize: 16,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x33000000),
                            offset: Offset(0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _descricaoController,
                        decoration: const InputDecoration(
                          labelText: 'Descrição do Serviço',
                          labelStyle: TextStyle(
                            color:
                                Colors.grey, // Ajuste a cor conforme necessário
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                        ), // Adicionado const
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0), // Adicionado const
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x33000000),
                            offset: Offset(0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _valorController,
                        decoration: const InputDecoration(
                          labelText: 'Valor do Serviço em reais',
                          labelStyle: TextStyle(
                            color:
                                Colors.grey, // Ajuste a cor conforme necessário
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                        ), // Adicionado const
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0), // Adicionado const
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x33000000),
                            offset: Offset(0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Text(
                          'Categoria: ${widget.service.categoria}',
                          style: const TextStyle(
                            color:
                                Colors.grey, // Ajuste a cor conforme necessário
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0), // Adicionado const
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x33000000),
                            offset: Offset(0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _disponibilidadeController,
                        decoration: const InputDecoration(
                          labelText: 'Disponibilidade de Horário',
                          labelStyle: TextStyle(
                            color:
                                Colors.grey, // Ajuste a cor conforme necessário
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                        ), // Adicionado const
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0), // Adicionado const
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 45, 96, 234),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x33000000),
                            offset: Offset(0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ElevatedButton(
                        onPressed: () => _editarServico(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 45, 96, 234), // Cor de fundo
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 50), // Cor do texto
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child:
                            const Text('Salvar Alterações'), // Adicionado const
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(40, 10, 40, 10),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Voltar para a página anterior
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        foregroundColor: Colors.white, // Cor do texto
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Texto em negrito
                          color: Colors.red, // Cor do texto
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
