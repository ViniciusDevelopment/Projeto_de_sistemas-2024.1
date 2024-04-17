import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PesquisapageWidget extends StatefulWidget {
  const PesquisapageWidget({Key? key}) : super(key: key);

  @override
  State<PesquisapageWidget> createState() => _PesquisapageWidgetState();
}

class _PesquisapageWidgetState extends State<PesquisapageWidget> {
  late TextEditingController _entradaBuscaController;
  late FocusNode _entradaBuscaFocusNode;
  List<Record> _simpleSearchResults = [];

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
          automaticallyImplyLeading: false,
          title: Text(
            'Procure diaristas',
            style: TextStyle(
              fontFamily: 'Outfit',
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 0,
            ),
          ),
          actions: [],
          centerTitle: false,
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
                child: TextFormField(
                  controller: _entradaBuscaController,
                  focusNode: _entradaBuscaFocusNode,
                  onFieldSubmitted: (_) async {
                    await _performSearch(_entradaBuscaController.text);
                  },
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'search...',
                    // aqui os estilos de decoração
                  ),
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 18,
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                  ),
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
                      return ListTile(
                        title: Text(item.Name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.Email),
                            Text(item.Endereco),
                            Text(item.Telefone),
                          ],
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

  Future<void> _performSearch(String searchTerm) async {
    // Referência para a coleção 'Users' no Firestore
    final CollectionReference usersRef =
        FirebaseFirestore.instance.collection('Users');

    // Executar a consulta para buscar usuários que correspondem ao termo de pesquisa
    final QuerySnapshot querySnapshot = await usersRef
        .where('Name',
            isEqualTo:
                searchTerm) // ajustar o campo de pesquisa conforme necessário
        .where('TipoUser', isEqualTo: 'Prestador')
        .get();

    // Atualizar a lista de resultados da pesquisa com base nos documentos encontrados
    setState(() {
      _simpleSearchResults = querySnapshot.docs.map((doc) {
        return Record(
          Name: doc['Name'],
          Telefone: doc['Telefone'],
          Email: doc['Email'],
          Endereco: doc['Endereco'],
        );
      }).toList();
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
