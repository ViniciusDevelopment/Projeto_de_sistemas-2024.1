import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:servicocerto/Pagescliente/FormaPagamento/Debito.dart';
import 'package:servicocerto/Pagescliente/FormaPagamento/Pix.dart';

class PagamentoPage extends StatelessWidget {
  final DocumentSnapshot<Object?> service;
  const PagamentoPage(this.service, {super.key});

  @override
  Widget build(BuildContext context) {
    double valorCliente = double.parse(service['valorcliente']);
    double taxa = valorCliente * 0.05;
    String taxaFormatada = taxa.toStringAsFixed(2);
    valorCliente = valorCliente - taxa;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Efetuar Pagamento'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 24),
            alignment: Alignment.center,
            child: const Text("Valor a ser pago:"),
          ),
          Container(
            alignment: Alignment.center,
            child: Text("R\$${service['valorcliente']},00", style: const TextStyle(fontSize: 50),),
          ),
          Container(
            padding: const EdgeInsets.only(top: 12),
            alignment: Alignment.center,
            child: Text("R\$$valorCliente do serviço + R\$$taxaFormatada de taxa da aplicação", style: const TextStyle(fontSize: 10),),
          ),
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: const Text("Métodos de Pagamento:", style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue
                ),),
              ),
              ListTile(
                leading: const Icon(Icons.credit_card),
                title: const Text("Cartão de Débito"),
                onTap: () {
                  Navigator.push(context,  MaterialPageRoute(builder: (context) => Debito(service)),);
                },
              ),
              ListTile(
                leading: const Icon(Icons.pix),
                title: const Text("Pix"),
                onTap: () {
                  Navigator.push(context,  MaterialPageRoute(builder: (context) => Pix(service)),);
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
