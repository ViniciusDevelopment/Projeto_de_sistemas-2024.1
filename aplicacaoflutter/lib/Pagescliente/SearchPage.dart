import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:servicocerto/Pagescliente/outroUserPage.dart';

class PesquisapageWidget extends StatefulWidget {
  const PesquisapageWidget({Key? key}) : super(key: key);

  @override
  State<PesquisapageWidget> createState() => _PesquisapageWidgetState();
}

class _PesquisapageWidgetState extends State<PesquisapageWidget> {
  late TextEditingController _entradaBuscaController;
  late FocusNode _entradaBuscaFocusNode;
  List<Record> _simpleSearchResults = [];
  String _selectedCategory = 'Limpeza';

  @override
  void initState() {
    super.initState();
    _entradaBuscaController = TextEditingController();
    _entradaBuscaFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _entradaBuscaController.dispose();
    _entradaBuscaFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_entradaBuscaFocusNode.canRequestFocus) {
          FocusScope.of(context).requestFocus(_entradaBuscaFocusNode);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: true,
          title: const Text(
            'Procure diaristas',
            style: TextStyle(
              fontFamily: 'Outfit',
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 0,
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    DropdownButton<String>(
                      value: _selectedCategory,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                      items: <String>['Limpeza', 'Alimentação']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    TextFormField(
                      controller: _entradaBuscaController,
                      focusNode: _entradaBuscaFocusNode,
                      onFieldSubmitted: (_) async {
                        await _performSearch();
                      },
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Search...',
                        // aqui os estilos de decoração
                      ),
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 18,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _performSearch();
                      },
                      child: Text('Pesquisar'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemCount: _simpleSearchResults.length,
                    itemBuilder: (context, index) {
                      final item = _simpleSearchResults[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: Offset(0, 2)),
                          ],
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OutroUserPage(email: item.Email)))
                                .then((value) {
                              // Aqui você pode executar qualquer código após a navegação
                              print('Página do usuário foi aberta');
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                255, 255, 255, 255), // Cor de fundo do botão
                            // Cor do texto do botão
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: ListTile(
                            title: Text(item.Name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.Email),
                                Text(item.Endereco),
                                Text(item.Telefone),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _performSearch() async {
    String searchTerm = _entradaBuscaController.text.trim();

    // Referência para a coleção 'Servicos' no Firestore
    final CollectionReference servicosRef =
        FirebaseFirestore.instance.collection('Servicos');

    Query query = servicosRef.where('categoria', isEqualTo: _selectedCategory);

    final QuerySnapshot querySnapshot = await query.get();

    List<Record> filteredResults = [];

    for (var doc in querySnapshot.docs) {
      String email = doc['email'];
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(email).get();

      if (userDoc.exists) {
        String name = userDoc['Name'];
        if (searchTerm.isEmpty ||
            name.toLowerCase().contains(searchTerm.toLowerCase())) {
          filteredResults.add(
            Record(
              Name: name,
              Telefone: userDoc['Telefone'],
              Email: userDoc['Email'],
              Endereco: userDoc['Endereco'],
            ),
          );
        }
      }
    }

    setState(() {
      _simpleSearchResults = filteredResults;
    });
  }
}

class Record {
  final String Name;
  final String Telefone;
  final String Email;
  final String Endereco;

  Record({
    required this.Name,
    required this.Telefone,
    required this.Email,
    required this.Endereco,
  });
}
