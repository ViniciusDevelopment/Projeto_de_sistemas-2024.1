import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:servicocerto/DTO/Response/UserImageDTO.dart';
import 'package:servicocerto/Models/ratingService.dart';
import 'package:servicocerto/PagesCommon/ChatPage.dart';
import 'ContratarServicoPage.dart';
import 'package:servicocerto/Controller/ratingController.dart';
import 'package:servicocerto/Components/ratingStarWidget.dart'; // Importar a RatingStarsWidget
import 'package:servicocerto/Components/ratingList.dart';

class OutroUserPage extends StatefulWidget {
  final String email;

  const OutroUserPage({Key? key, required this.email}) : super(key: key);

  @override
  _OutroUserPageState createState() => _OutroUserPageState();
}

class _OutroUserPageState extends State<OutroUserPage> {
  UserImageDTO? _simpleSearchResults;
  final RatingServiceController _ratingController = RatingServiceController();
  double _rating = 0;
  int _ratingCount = 0;
  String _avaliacoes = "";

  @override
  void initState() {
    super.initState();
    _simpleSearchResults = null;
    _performSearch(widget.email);
  }

  Widget _chatButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChatPage(receiverUserEmail: widget.email)));
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 60),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        backgroundColor: const Color.fromARGB(255, 45, 96, 234),
      ),
      child: const Text(
        "Conversar",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _contratarButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ContratarServicoPage(email: widget.email)));
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 60),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        backgroundColor: const Color.fromARGB(255, 45, 96, 234),
        textStyle: const TextStyle(
          fontFamily: 'Readex Pro',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      child: const Text(
        "Contratar",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _performSearch(String searchTerm) async {
    try {
      final CollectionReference usersRef =
          FirebaseFirestore.instance.collection('Users');
      final CollectionReference ratingRef =
          FirebaseFirestore.instance.collection('AvaliacaoPrestador');
      final CollectionReference ratingServices =
          FirebaseFirestore.instance.collection('AvaliacoesServico');

      final QuerySnapshot querySnapshot = await usersRef
          .where('Email', isEqualTo: searchTerm)
          .where('TipoUser', isEqualTo: 'Prestador')
          .get();
      final QuerySnapshot querySnapshotRating =
          await ratingRef.where('email', isEqualTo: searchTerm).get();
      final QuerySnapshot querySnapshotServices = await ratingServices
          .where('emailPrestador', isEqualTo: searchTerm)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        final user = UserImageDTO.fromJson(userData);

        double rating = 0.0;
        int ratingCount = 0;
        List<Map<String, dynamic>> avaliacoes = [];

        if (querySnapshotRating.docs.isNotEmpty) {
          final ratingData =
              querySnapshotRating.docs.first.data() as Map<String, dynamic>;
          rating = ratingData['rating'];
          ratingCount = ratingData['ratingCount'];
        }

        if (querySnapshotServices.docs.isNotEmpty) {
          avaliacoes = querySnapshotServices.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        }

        setState(() {
          _simpleSearchResults = user;
          _rating = rating;
          _ratingCount = ratingCount;
          _avaliacoes = avaliacoes;
        });
      } else {
        print('Nenhum usuário encontrado.');
        setState(() {
          _simpleSearchResults = null;
        });
      }
    } catch (error) {
      print("Erro ao buscar dados do usuário: $error");
      setState(() {
        _simpleSearchResults = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: AlignmentDirectional(0, 0),
          child: Text(
            "Perfil do Prestador",
            style: TextStyle(
              fontFamily: 'Outfit',
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 0,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 45, 96, 234),
        automaticallyImplyLeading: true,
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IntrinsicHeight(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(0, 2),
                      )
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          width: 110,
                          height: 110,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: _simpleSearchResults != null &&
                                  _simpleSearchResults!.photoURL != null
                              ? Image.network(
                                  _simpleSearchResults!.photoURL!,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  'https://www.shutterstock.com/image-vector/blank-avatar-photo-place-holder-600nw-1095249842.jpg',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _simpleSearchResults != null
                                    ? _simpleSearchResults!.name
                                    : 'Nenhum usuário encontrado.',
                                style: const TextStyle(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .start, // Alinha os elementos ao início
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, // Centraliza verticalmente
                                  children: [
                                    Text(
                                      _rating.toStringAsFixed(1),
                                      style: const TextStyle(
                                        fontFamily: 'Readex Pro',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            4), // Espaçamento entre a nota e as estrelas
                                    RatingBar(
                                      rating: _rating,
                                      ratingCount: _ratingCount,
                                      size:
                                          16, // Ajusta o tamanho das estrelas conforme necessário
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 122,
              decoration: const BoxDecoration(
                color: Color.fromARGB(26, 192, 188, 188),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: _chatButton(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: _contratarButton(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: RatingList(avaliacoes: widget.email),
            )
          ],
        ),
      ),
    );
  }
}
