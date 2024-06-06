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
  String? _selectedOrder;

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
        FocusScope.of(context).unfocus();
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChoiceChip(
                          label: Text('Limpeza'),
                          selected: _selectedCategory == 'Limpeza',
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedCategory = 'Limpeza';
                            });
                          },
                        ),
                        SizedBox(width: 10),
                        ChoiceChip(
                          label: Text('Alimentação'),
                          selected: _selectedCategory == 'Alimentação',
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedCategory = 'Alimentação';
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _entradaBuscaController,
                            focusNode: _entradaBuscaFocusNode,
                            onFieldSubmitted: (_) async {
                              await _performSearch();
                            },
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              prefixIcon: GestureDetector(
                                onTap: () {
                                  _performSearch();
                                },
                                child: const Icon(
                                  Icons.search,
                                  color: Colors.blue,
                                ),
                              ),
                              hintText: 'Pesquisar...',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.all(16.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 18,
                              letterSpacing: 0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
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
                                    OutroUserPage(email: item.Email),
                              ),
                            ).then((value) {
                              // Aqui você pode executar qualquer código após a navegação
                              print('Página do usuário foi aberta');
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                                255, 255, 255, 255), // Cor de fundo do botão
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: item.photoURL != null
                                  ? NetworkImage(item.photoURL!)
                                  : null,
                              child: item.photoURL == null
                                  ? Icon(Icons.person, size: 40)
                                  : null,
                            ),
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

    if (_selectedOrder != null) {
      query = query.orderBy('valor', descending: _selectedOrder == 'desc');
    }

    final QuerySnapshot querySnapshot = await query.get();

    List<Record> filteredResults = [];

    for (var doc in querySnapshot.docs) {
      String email = doc['email'];
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(email).get();

      if (userDoc.exists) {
        String name = userDoc['Name'];
        String? photoURL = userDoc.data().toString().contains('photoURL')
            ? userDoc['photoURL']
            : null;
        if (searchTerm.isEmpty ||
            name.toLowerCase().contains(searchTerm.toLowerCase())) {
          filteredResults.add(
            Record(
              Name: name,
              Telefone: userDoc['Telefone'],
              Email: userDoc['Email'],
              Endereco: userDoc['Endereco'],
              photoURL: photoURL,
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
  final String? photoURL;

  Record({
    required this.Name,
    required this.Telefone,
    required this.Email,
    required this.Endereco,
    this.photoURL,
  });
}
