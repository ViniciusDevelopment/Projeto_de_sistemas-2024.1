import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicocerto/Components/ratingStarWidget.dart';
import 'package:servicocerto/Pagescliente/outroUserPage.dart';
import 'package:servicocerto/Repository/UserRepository.dart';

class CategoriaPage extends StatefulWidget {
  final String nome;

  const CategoriaPage({Key? key, required this.nome}) : super(key: key);

  @override
  _CategoriaPageState createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserRepository>().fetchUsersCategoria(widget.nome);
  }

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Consumer<UserRepository>(
            builder: (context, userRepository, child) {
              if (userRepository.listaDeUsuarios2.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: userRepository.listaDeUsuarios2.length,
                  itemBuilder: (context, index) {
                    final user = userRepository.listaDeUsuarios2[index];
                    return Card(
                      elevation: 0,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: user.photoURL != null && user.photoURL != ""
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(user.photoURL!),
                                radius: 30,
                              )
                            : const CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 30,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                        title: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(width: 5),
                            Row(children: [
                              Text(
                                '${user.rating?.toStringAsFixed(1)}',
                                style: const TextStyle(
                                  color:
                                      Colors.amber, // Cor amarela para o rating
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              RatingBar(
                                rating: user.rating!,
                                ratingCount: user.ratingCount,
                                size:
                                    16, // Ajusta o tamanho das estrelas conforme necessário
                              ),
                            ])
                          ],
                        ),
                        subtitle: Text(user.descricao),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OutroUserPage(email: user.email),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
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
