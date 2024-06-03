import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late String emailUsuario;
  late String TipoUsuario;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<dynamic>> _events = {};
  

@override
void initState() {
  super.initState();
  initializeDateFormatting('pt_BR', null);
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String emailUsuario = user.email!;

    FirebaseFirestore.instance
      .collection('Users')
      .where('Email', isEqualTo: emailUsuario)
      .get()
      .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          var userData = querySnapshot.docs.first.data();
          if (userData != null && userData is Map<String, dynamic>) {
            String tipoUsuario = userData['TipoUser'] as String;

            if (tipoUsuario == 'Prestador') {
              _fetchAcceptedSolicitationsPrestador(emailUsuario);
            } else {
              _fetchAcceptedSolicitationsCliente(emailUsuario);
            }
          } else {
            print('Dados do usuário não encontrados.');
          }
        }
      });
  }
}


  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  void _fetchAcceptedSolicitationsPrestador(emailUsuario) async {
    FirebaseFirestore.instance
        .collection('SolicitacoesServico')
        .where('status', isEqualTo: 'Aceita')
        .where('emailPrestador', isEqualTo: emailUsuario)
        .get()
        .then((QuerySnapshot querySnapshot) {
      Map<DateTime, List<dynamic>> events = {};
      for (var doc in querySnapshot.docs) {
        String dateString = doc['data'];
        DateTime date = DateFormat('dd-MM-yyyy').parse(dateString);
        DateTime normalizedDate = _normalizeDate(date);

        if (events[normalizedDate] == null) events[normalizedDate] = [];
        events[normalizedDate]!.add(doc.data());
      }
      setState(() {
        _events = events;
      });
    });
  }

  void _fetchAcceptedSolicitationsCliente(emailUsuario) async {
    FirebaseFirestore.instance
        .collection('SolicitacoesServico')
        .where('status', whereIn: ['Solicitação enviada', 'Aceita', 'Concluida'])
        .where('emailCliente', isEqualTo: emailUsuario)
        .get()
        .then((QuerySnapshot querySnapshot) {
      Map<DateTime, List<dynamic>> events = {};
      for (var doc in querySnapshot.docs) {
        String dateString = doc['data'];
        DateTime date = DateFormat('dd-MM-yyyy').parse(dateString);
        DateTime normalizedDate = _normalizeDate(date);

        if (events[normalizedDate] == null) events[normalizedDate] = [];
        events[normalizedDate]!.add(doc.data());
      }
      setState(() {
        _events = events;
      });
    });
  }

  void _showEventDetails(List<dynamic> events) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Detalhes do Serviço'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: events.map((event) {
              return ListTile(
                title: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Descrição: ${event['descricao']}'),
                                Text('Prestador: ${event['emailPrestador']}'),
                                Text(
                                    "Data: ${event['data']}     Horário: ${event['hora']}"),
                                Text(
                                    'Valor Proposto: R\$${event['valorcliente']}'),
                              ],
                            ),
                ),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário'),
      ),
      body: Center(
        child: TableCalendar(
          locale: 'pt_BR',
          firstDay: DateTime.utc(2020, 10, 16),
          lastDay: DateTime.utc(2040, 3, 14),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          availableCalendarFormats: const {
            CalendarFormat.month: 'Month',
          },
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          eventLoader: (day) {
            return _events[_normalizeDate(day)] ?? [];
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            if (_events[_normalizeDate(selectedDay)] != null) {
              _showEventDetails(_events[_normalizeDate(selectedDay)]!);
            }
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                return Positioned(
                  right: 1,
                  bottom: 1,
                  child: _buildEventsMarker(date, events),
                );
              }
              return null;
            },
            selectedBuilder: (context, date, _) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
            todayBuilder: (context, date, _) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
            defaultBuilder: (context, date, _) {
              if (_events[_normalizeDate(date)] != null) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    '${date.day}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

//   Widget _buildEventsMarker(DateTime date, List events) {
//   // Mapear os tipos de eventos para suas respectivas cores
//   Map<String, Color> eventColors = {
//     'Solicitação Enviada': Colors.amber,
//     'Aceita': Colors.green,
//     'Recusado': Colors.red,
//     'Concluida': Colors.purple,
//   };

// Map<String, int> totalEvents = {};


// int totalEventsCount = events.length;


//   // Se houver eventos neste dia
//   if (totalEventsCount > 0) {
//     // Inicializar uma lista de Widgets para os marcadores de evento
//     List<Widget> markers = [];

//     // Iterar sobre os eventos e criar um marcador para cada tipo de evento
//     events.forEach((event) {
//       String status = event['status'];
//       totalEvents[status] = (totalEvents[status] ?? 0) + 1;
//       if (eventColors.containsKey(event['status'])) {
//         // Obter a cor do tipo de evento
//         Color eventColor = eventColors[event['status']]!;

//         // Adicionar um marcador para o evento com a cor correspondente
//         markers.add(
//           Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: eventColor,
//             ),
//             width: 16.0,
//             height: 16.0,
//             child: Center(
//               child: Text(
//                 '${totalEvents[status]}',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 12.0,
//                 ),
//               ),
//             ),
//           ),
//         );
//       }
//     });

//     // Retornar uma coluna com todos os marcadores de evento para este dia
//     return Column(
//       children: markers,
//     );
//   } else {
//     // Se não houver eventos neste dia, retornar um marcador vazio
//     return SizedBox.shrink();
//   }
// }


  Widget _buildEventsMarker(DateTime date, List events) {
    print(events[0]['status']);
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: const TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}
