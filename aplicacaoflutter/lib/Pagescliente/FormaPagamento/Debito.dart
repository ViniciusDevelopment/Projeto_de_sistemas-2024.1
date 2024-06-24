import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:servicocerto/Controller/ratingController.dart';
import 'package:servicocerto/Models/ratingService.dart';
import 'package:servicocerto/Pagescliente/ServicosContratadosCliente.dart';

class Debito extends StatefulWidget {
  final DocumentSnapshot<Object?> service;
  const Debito(this.service, {super.key});

  @override
  State<Debito> createState() => _DebitoState();
}

class _DebitoState extends State<Debito> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numeroCartaoController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _expiracaoController = TextEditingController();

  final TextEditingController _commentController = TextEditingController();
  double _rating = 3.0;

  void _confirmarConclusaoServico(String serviceId, String emailPrestador) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmação"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('SolicitacoesServico')
                    .doc(serviceId)
                    .update({'status': 'Concluido'});
                Navigator.of(context).pop();
                _showRatingDialog(serviceId, emailPrestador);
                setState(() {
                  // Atualiza o estado do widget após a conclusão do serviço
                  // Aqui você pode fazer algo após a confirmação
                });
              },
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  void _showRatingDialog(String serviceId, String emailPrestador) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Avalie o Serviço"),
          content: buildRatingPage(context, emailPrestador, serviceId),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  Widget buildRatingPage(
      BuildContext context, String emailPrestador, String serviceId) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AVALIE O SERVIÇO! (OPCIONAL)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Center(
            child: RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: 'Deixe um comentário',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _sendReview();
                Navigator.of(context).pop();
              },
              child: const Text('Enviar Avaliação'),
            ),
          ),
        ],
      ),
    );
  }

  void _sendReview() async {
    try {
      String comment = _commentController.text;
      RatingServiceModel service = RatingServiceModel(
        rating: _rating,
        comment: comment,
        date: DateTime.now(),
        emailCliente: FirebaseAuth.instance.currentUser?.email,
        emailPrestador: widget.service['emailPrestador'],
        serviceID: widget.service.id,
      );

      await RatingServiceController.instance.rateService(service);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Avaliação enviada com sucesso!'),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const ServicosContradosCliente(),
        ),
        (route) => false, // Remove todas as rotas na pilha
      );
    } catch (error) {
      print('Erro ao enviar avaliação: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento via Cartão de Débito'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                SvgPicture.asset(
                  "assets/icons/card.svg",
                  height: 50,
                  width: 50,
                  color: Colors.blue, // Cor do ícone do cartão
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _numeroCartaoController,
                  decoration: const InputDecoration(
                    labelText: 'Número do Cartão',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite o número do cartão';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome no Cartão',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite o nome no cartão';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _cvvController,
                        decoration: const InputDecoration(
                          labelText: 'CVV',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite o CVV';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _expiracaoController,
                        decoration: const InputDecoration(
                          labelText: 'MM/AA',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite a data de expiração';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _confirmarConclusaoServico(widget.service.id,
                            widget.service['emailPrestador']);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Prosseguir'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
