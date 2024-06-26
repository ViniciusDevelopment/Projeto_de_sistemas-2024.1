import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:servicocerto/Controller/ServiceController.dart';
import 'package:servicocerto/DTO/Request/ServiceDTO.dart';
import 'package:servicocerto/Models/SolicitarServico.dart';
import 'package:servicocerto/Models/comodos.dart';
import 'package:servicocerto/animation/FadeAnimation.dart';

class CleaningPage extends StatefulWidget {
  // const CleaningPage({Key? key}) : super(key: key);
  final ServiceModelDTO service;
  final String emailCliente;

  const CleaningPage({
    Key? key,
    required this.service,
    required this.emailCliente,
  }) : super(key: key);

  @override
  _CleaningPageState createState() => _CleaningPageState();
}

class _CleaningPageState extends State<CleaningPage> {
  final _dataController = TextEditingController();
  final _horarioController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();

  List<dynamic> _rooms = [
    [
      'Sala',
      'https://img.icons8.com/officel/2x/living-room.png',
      Colors.red,
      0
    ],
    [
      'Quartos',
      'https://img.icons8.com/fluency/2x/bedroom.png',
      Colors.orange,
      1
    ],
    ['Banheiro', 'https://img.icons8.com/color/2x/bath.png', Colors.blue, 1],
    ['Cozinha', 'https://img.icons8.com/dusk/2x/kitchen.png', Colors.purple, 0],
    [
      'Escritório',
      'https://img.icons8.com/color/2x/office.png',
      Colors.green,
      0
    ]
  ];

  Map<String, int> _selectedQuantities = {
    'Sala': 0,
    'Quartos': 0,
    'Banheiro': 0,
    'Cozinha': 0,
    'Escritório': 0,
  };

  List<int> _selectedRooms = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 243, 243, 243),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: _selectedRooms.length > 0
          ? FloatingActionButton(
              onPressed: () {
                final comodos = Comodos(
                  _selectedQuantities['Sala']!,
                  _selectedQuantities['Quartos']!,
                  _selectedQuantities['Banheiro']!,
                  _selectedQuantities['Cozinha']!,
                  _selectedQuantities['Escritório']!,
                );

                SolicitarServico solicitarServico = SolicitarServico(
                  servico: widget.service,
                  data: _dataController.text,
                  hora: _horarioController.text,
                  emailPrestador: widget.service.email,
                  emailCliente: widget.emailCliente,
                  status: 'Solicitação enviada',
                  descricao: _descricaoController.text,
                  valorcliente: _valorController.text,
                  comodos: comodos,
                );
                print("!!@@@@@@@@@@&7777");
                print("Sala: ${comodos.sala}");
                print("Quartos: ${comodos.quarto}");
                print("Banheiro: ${comodos.banheiro}");
                print("Cozinha: ${comodos.cozinha}");
                print("Escritório: ${comodos.escritorio}");

                ServiceController().contratarServico(
                  solicitarServico,
                );
                Navigator.of(context).pop();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${_selectedRooms.length}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width: 2),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                ],
              ),
              backgroundColor: Colors.blue,
            )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: FadeAnimation(
                  1,
                  Padding(
                    padding:
                        EdgeInsets.only(top: 12.0, right: 20.0, left: 20.0),
                    child: Text(
                      'Onde precisa ser \nlimpo?',
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
            )
          ];
        },
        body: Container(
          height: MediaQuery.of(context)
              .size
              .height, // Defina a altura como a altura da tela
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap:
                        true, // Use shrinkWrap para evitar a altura ilimitada
                    itemCount: _rooms.length,
                    itemBuilder: (BuildContext context, int index) {
                      return FadeAnimation(
                        (1.2 + index) / 4,
                        room(_rooms[index], index),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Data",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: _dataController,
                        obscureText: false,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            _dataController.text =
                                DateFormat('dd-MM-yyyy').format(picked);
                          }
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]!),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]!),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Horário",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: _horarioController,
                        obscureText: false,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            _horarioController.text = picked.format(context);
                          }
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]!),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]!),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Descrição",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: _descricaoController,
                        obscureText: false,
                        onTap: () async {},
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]!),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]!),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Valor que deseja pagar",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: _valorController,
                        obscureText: false,
                        onTap: () async {},
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]!),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]!),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  room(List room, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedRooms.contains(index)) {
            _selectedRooms.remove(index);
            _selectedQuantities[room[0]] = 0;
          } else {
            _selectedRooms.add(index);
            _selectedQuantities[room[0]] = 1;
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        margin: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: _selectedRooms.contains(index)
              ? room[2].shade50.withOpacity(0.5)
              : Colors.grey.shade100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Image.network(
                      room[1],
                      width: 35,
                      height: 35,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      room[0],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Spacer(),
                _selectedRooms.contains(index)
                    ? Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.shade100.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 20,
                        ))
                    : SizedBox()
              ],
            ),
            //Se o quarto campo da lista for maior que um gera a lista
            (_selectedRooms.contains(index) && room[3] >= 1)
                ? Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "Quantos ${room[0]}?",
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          height: 45,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 6,
                            itemBuilder: (BuildContext context, int qIndex) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    room[3] = qIndex + 1;
                                    _selectedQuantities[room[0]] = qIndex + 1;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 10.0),
                                  padding: EdgeInsets.all(10.0),
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: room[3] == qIndex + 1
                                        ? room[2].withOpacity(0.5)
                                        : room[2].shade200.withOpacity(0.5),
                                  ),
                                  child: Center(
                                      child: Text(
                                    (qIndex + 1).toString(),
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.white),
                                  )),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
