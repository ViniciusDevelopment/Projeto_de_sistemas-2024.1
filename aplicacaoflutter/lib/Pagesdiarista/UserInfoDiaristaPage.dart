import 'package:flutter/material.dart';
import 'package:servicocerto/Pagescliente/CadastrarservicoPage.dart';
import 'package:servicocerto/Pagescliente/DeleteAccountButton.dart';
import 'package:servicocerto/Pagescliente/EditButton.dart';
import 'package:servicocerto/Controller/ServiceController.dart'; // Atualize o import
import 'package:servicocerto/Models/Service.dart'; // Atualize o import

class DiaristaProfilePage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const DiaristaProfilePage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: const Text(
          'Meu Perfil - Diarista',
          style: TextStyle(
            fontFamily: 'Outfit',
            color: Colors.white,
            fontSize: 22,
            letterSpacing: 0,
          ),
        ),
        centerTitle: false,
        elevation: 2,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://cdn.pixabay.com/photo/2017/02/13/16/58/signal-2063096_1280.png'),
            ),
            const SizedBox(height: 20),
            Text(
              userData['Name'] ?? 'Nome do Usuário',
              style: const TextStyle(
                fontFamily: 'Readex Pro',
                fontSize: 24,
                letterSpacing: 0,
                fontWeight: FontWeight.w600,
              ),
            ),
            _buildUserInfoTile('Telefone', userData['Telefone']),
            _buildUserInfoTile('Email', userData['Email']),
            _buildUserInfoTile('Endereco', userData['Endereco']),
            Expanded(
              child: StreamBuilder<List<ServiceModel>>(
                stream: ServiceController.instance.getUserServices(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text("Erro ao carregar serviços"));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: const Text("Nenhum serviço encontrado"));
                  }

                  List<ServiceModel> services = snapshot.data!;
                  return ListView.builder(
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      ServiceModel service = services[index];
                      return Card(
                        elevation: 4,
                        margin:
                            const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          title: Text(service.descricao),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Valor: ${service.valor.toString()} reais'),
                              Text(
                                  'Disponibilidade: ${service.disponibilidade}'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.blue),
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () {
                      _cadastrarServico(context);
                    },
                    child: const Text('Cadastrar serviço'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: EditButton(),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: DeleteAccountButton(),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoTile(String title, String? value) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Readex Pro',
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        value ?? 'Informação não encontrada',
        style: const TextStyle(
          fontFamily: 'Readex Pro',
          fontSize: 16,
        ),
      ),
    );
  }

  void _cadastrarServico(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ServiceRegistrationPage(email: userData['Email'],)),
    );
  }
}
