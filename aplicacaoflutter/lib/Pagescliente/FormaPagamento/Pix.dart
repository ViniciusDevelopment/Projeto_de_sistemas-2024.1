import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:servicocerto/Controller/ratingController.dart';
import 'package:servicocerto/Models/ratingService.dart';
import 'package:servicocerto/Pagescliente/ServicosContratadosCliente.dart';

class Pix extends StatefulWidget {
  final DocumentSnapshot<Object?> service;

  const Pix(this.service, {super.key});

  @override
  _PixState createState() => _PixState();
}

class _PixState extends State<Pix> {
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
    return Column(
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
        title: const Text("Pagamento via Pix"),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: const Text(
              "Finalize o Pagamento.",
              style: TextStyle(fontSize: 30),
            ),
          ),
          const SizedBox(height: 30),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "1. Acesse o aplicativo do seu banco de preferência.",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 15),
              Text(
                "2. Escolha a opção pagar via Pix.",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 15),
              Text(
                "3. Cole o seguinte código.",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 15),
            ],
          ),
          SizedBox(
            width: 360,
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                fillColor: Colors.blue,
                labelText: 'Endereço Pix',
                hintText: '000012232-servicocerto-2334',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(
                      const ClipboardData(text: '000012232-servicocerto-2334'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Endereço PIX copiado')),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              _confirmarConclusaoServico(
                  widget.service.id, widget.service['emailPrestador']);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text("Prosseguir"),
          ),
        ],
      ),
    );
  }
}
