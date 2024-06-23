import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
// import 'package:pie_chart/pie_chart.dart';
// import 'package:graphic/graphic.dart';

class RelatorioPage extends StatefulWidget {
  const RelatorioPage({
    super.key,
  });

  @override
  State<RelatorioPage> createState() => _RelatorioPageState();
}

class _RelatorioPageState extends State<RelatorioPage> {
  String periodoSelecionado = 'Hoje';
  String? tipoUsuario;
  String emailUsuario = '';
  int numeroSolicitacoes = 0;
  int servicosConcluidos = 0;
  double totalGasto = 0;
  List<RelatorioData> servicosgrafico = [];
  List<RelatorioData> servicosgrafico2 = [];
  List<RelatorioData> servicosgrafico3 = [];
  List<RelatorioData> servicosgrafico4 = [];

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emailUsuario = user.email!;

      FirebaseFirestore.instance
          .collection('Users')
          .where('Email', isEqualTo: emailUsuario)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          var userData = querySnapshot.docs.first.data();
          if (userData != null && userData is Map<String, dynamic>) {
            tipoUsuario = userData['TipoUser'] as String;

            if (tipoUsuario != null) {
              if (tipoUsuario == 'Prestador') {
                _GerarRelatorioPrestador();
              } else {
                _GerarRelatorioSolicitationsCliente();
              }
            }
          } else {
            print('Dados do usuário não encontrados.');
          }
        }
      });
    }
  }

  void _GerarRelatorioPrestador() async { setState(() {
      servicosgrafico.clear();
      servicosgrafico2.clear();
      servicosgrafico3.clear();
    });

    DateTime dataHoje = DateTime.now();

    if (periodoSelecionado == 'Hoje') {
      print("Danadas");

      DateTime inicioDia =
          DateTime(dataHoje.year, dataHoje.month, dataHoje.day, 0, 0, 0);
      DateTime fimDia =
          DateTime(dataHoje.year, dataHoje.month, dataHoje.day, 23, 59, 59);
      Timestamp inicioTimestamp = Timestamp.fromDate(inicioDia);
      Timestamp fimTimestamp = Timestamp.fromDate(fimDia);

      QuerySnapshot solicitacoesSnapshot = await FirebaseFirestore.instance
          .collection('SolicitacoesServico')
          .where('emailPrestador', isEqualTo: emailUsuario)
          .where('data', isEqualTo: inicioTimestamp)
          .get();

      numeroSolicitacoes = solicitacoesSnapshot.docs.length;
      List<DocumentSnapshot> solicitacoesConcluidas = solicitacoesSnapshot.docs
          .where((doc) => doc['status'] == 'Concluido')
          .toList();

      servicosConcluidos = solicitacoesConcluidas.length;
      totalGasto = 0;
      for (var solicitacao in solicitacoesConcluidas) {
        totalGasto += solicitacao['servico']['valor'];
      }

      setState(() {
        servicosgrafico
            .add(RelatorioData('Hoje', numeroSolicitacoes.toDouble()));
        servicosgrafico2
            .add(RelatorioData('Hoje', servicosConcluidos.toDouble()));
        servicosgrafico3.add(RelatorioData('Hoje', totalGasto));
        servicosgrafico4.add(RelatorioData('Hoje', 1));
        servicosgrafico4.add(RelatorioData('Hoje', 5));
        servicosgrafico4.add(RelatorioData('Hoje', 9));
        servicosgrafico4.add(RelatorioData('Hoje', 2));
        servicosgrafico4.add(RelatorioData('Hoje', 2));
        servicosgrafico4.add(RelatorioData('Hoje', 15));
      });

      // Imprimir as informações
      print(
          'Número de solicitações do cliente para o dia de hoje: $numeroSolicitacoes');
      print('Serviços concluídos para o dia de hoje: $servicosConcluidos');
      print(
          'Total gasto em serviços concluídos para o dia de hoje: $totalGasto');

      print('Gerando relatório para hoje');
    } else if (periodoSelecionado == 'Semana') {
      DateTime inicioSemana =
          dataHoje.subtract(Duration(days: dataHoje.weekday - 1));
      DateTime fimSemana = inicioSemana.add(const Duration(days: 6));
      Timestamp inicioTimestamp = Timestamp.fromDate(inicioSemana);
      Timestamp fimTimestamp = Timestamp.fromDate(fimSemana);

      QuerySnapshot solicitacoesSnapshot = await FirebaseFirestore.instance
          .collection('SolicitacoesServico')
          .where('emailPrestador', isEqualTo: emailUsuario)
          .get();

      List<DocumentSnapshot> todasSolicitacoes = solicitacoesSnapshot.docs;

      List<DocumentSnapshot> solicitacoesNaSemana =
          todasSolicitacoes.where((doc) {
        Timestamp dataSolicitacao = doc['data'];
        return dataSolicitacao.toDate().isAfter(inicioSemana) &&
            dataSolicitacao.toDate().isBefore(fimSemana);
      }).toList();

      numeroSolicitacoes = solicitacoesNaSemana.length;
      List<DocumentSnapshot> solicitacoesConcluidas = solicitacoesNaSemana
          .where((doc) => doc['status'] == 'Concluido')
          .toList();

      servicosConcluidos = solicitacoesConcluidas.length;
      totalGasto = 0;
      for (var solicitacao in solicitacoesConcluidas) {
        totalGasto += solicitacao['servico']['valor'];
      }

      setState(() {
        servicosgrafico
            .add(RelatorioData('Semana', numeroSolicitacoes.toDouble()));
        servicosgrafico2
            .add(RelatorioData('Semana', servicosConcluidos.toDouble()));
        servicosgrafico3.add(RelatorioData('Semana', totalGasto));
      });

      // Imprimir as informações
      print(
          'Número de solicitações do cliente para a semana: $numeroSolicitacoes');
      print('Serviços concluídos para a semana: $servicosConcluidos');
      print('Total gasto em serviços concluídos para a semana: $totalGasto');

      print('Gerando relatório para a semana');

      print('Gerando relatório para a semana');
    } else if (periodoSelecionado == 'Mês') {
      print('Gerando relatório para o mês');

      DateTime inicioMes = DateTime(dataHoje.year, dataHoje.month, 1);
      DateTime fimMes = DateTime(dataHoje.year, dataHoje.month + 1, 0);
      Timestamp inicioTimestamp = Timestamp.fromDate(inicioMes);
      Timestamp fimTimestamp = Timestamp.fromDate(fimMes);

      QuerySnapshot solicitacoesSnapshot = await FirebaseFirestore.instance
          .collection('SolicitacoesServico')
          .where('emailPrestador', isEqualTo: emailUsuario)
          .get();

      List<DocumentSnapshot> todasSolicitacoes = solicitacoesSnapshot.docs;

      List<DocumentSnapshot> solicitacoesNoMes = todasSolicitacoes.where((doc) {
        Timestamp dataSolicitacao = doc['data'];
        return dataSolicitacao.toDate().isAfter(inicioMes) &&
            dataSolicitacao.toDate().isBefore(fimMes);
      }).toList();

      numeroSolicitacoes = solicitacoesNoMes.length;
      List<DocumentSnapshot> solicitacoesConcluidas = solicitacoesNoMes
          .where((doc) => doc['status'] == 'Concluido')
          .toList();

      servicosConcluidos = solicitacoesConcluidas.length;
      totalGasto = 0;
      for (var solicitacao in solicitacoesConcluidas) {
        totalGasto += solicitacao['servico']['valor'];
      }

      setState(() {
        servicosgrafico
            .add(RelatorioData('Semana', numeroSolicitacoes.toDouble()));
        servicosgrafico2
            .add(RelatorioData('Semana', servicosConcluidos.toDouble()));
        servicosgrafico3.add(RelatorioData('Semana', totalGasto));
      });

      // Imprimir as informações
      print(
          'Número de solicitações do cliente para a semana: $numeroSolicitacoes');
      print('Serviços concluídos para a semana: $servicosConcluidos');
      print('Total gasto em serviços concluídos para a semana: $totalGasto');

      print('Gerando relatório para a semana');
    } else if (periodoSelecionado == 'Ano') {
      print('Gerando relatório para o ano');

      DateTime inicioAno = DateTime(dataHoje.year, 1, 1);
      DateTime fimAno = DateTime(dataHoje.year, 12, 31);
      Timestamp inicioTimestamp = Timestamp.fromDate(inicioAno);
      Timestamp fimTimestamp = Timestamp.fromDate(fimAno);

      QuerySnapshot solicitacoesSnapshot = await FirebaseFirestore.instance
          .collection('SolicitacoesServico')
          .where('emailPrestador', isEqualTo: emailUsuario)
          .get();


       List<DocumentSnapshot> todasSolicitacoes = solicitacoesSnapshot.docs;

      List<DocumentSnapshot> solicitacoesNoAno = todasSolicitacoes.where((doc) {
        Timestamp dataSolicitacao = doc['data'];
        return dataSolicitacao.toDate().isAfter(inicioAno) &&
            dataSolicitacao.toDate().isBefore(fimAno);
      }).toList();

      numeroSolicitacoes = solicitacoesNoAno.length;
      List<DocumentSnapshot> solicitacoesConcluidas = solicitacoesNoAno
          .where((doc) => doc['status'] == 'Concluido')
          .toList();

      servicosConcluidos = solicitacoesConcluidas.length;
      totalGasto = 0;
      for (var solicitacao in solicitacoesConcluidas) {
        totalGasto += solicitacao['servico']['valor'];
      }

      setState(() {
        servicosgrafico
            .add(RelatorioData('Ano', numeroSolicitacoes.toDouble()));
        servicosgrafico2
            .add(RelatorioData('Ano', servicosConcluidos.toDouble()));
        servicosgrafico3.add(RelatorioData('Ano', totalGasto));
      });

      // Imprimir as informações
      print(
          'Número de solicitações do cliente para a semana: $numeroSolicitacoes');
      print('Serviços concluídos para a semana: $servicosConcluidos');
      print('Total gasto em serviços concluídos para a semana: $totalGasto');

      

    }
  }
  void _GerarRelatorioSolicitationsCliente() async {
    setState(() {
      servicosgrafico.clear();
      servicosgrafico2.clear();
      servicosgrafico3.clear();
    });

    DateTime dataHoje = DateTime.now();

    if (periodoSelecionado == 'Hoje') {
      print("Danadas");

      DateTime inicioDia =
          DateTime(dataHoje.year, dataHoje.month, dataHoje.day, 0, 0, 0);
      DateTime fimDia =
          DateTime(dataHoje.year, dataHoje.month, dataHoje.day, 23, 59, 59);
      Timestamp inicioTimestamp = Timestamp.fromDate(inicioDia);
      Timestamp fimTimestamp = Timestamp.fromDate(fimDia);

      QuerySnapshot solicitacoesSnapshot = await FirebaseFirestore.instance
          .collection('SolicitacoesServico')
          .where('emailCliente', isEqualTo: emailUsuario)
          .where('data', isEqualTo: inicioTimestamp)
          .get();

      numeroSolicitacoes = solicitacoesSnapshot.docs.length;
      List<DocumentSnapshot> solicitacoesConcluidas = solicitacoesSnapshot.docs
          .where((doc) => doc['status'] == 'Concluido')
          .toList();

      servicosConcluidos = solicitacoesConcluidas.length;
      totalGasto = 0;
      for (var solicitacao in solicitacoesConcluidas) {
        totalGasto += solicitacao['servico']['valor'];
      }

      setState(() {
        servicosgrafico
            .add(RelatorioData('Hoje', numeroSolicitacoes.toDouble()));
        servicosgrafico2
            .add(RelatorioData('Hoje', servicosConcluidos.toDouble()));
        servicosgrafico3.add(RelatorioData('Hoje', totalGasto));
        servicosgrafico4.add(RelatorioData('Hoje', 1));
        servicosgrafico4.add(RelatorioData('Hoje', 5));
        servicosgrafico4.add(RelatorioData('Hoje', 9));
        servicosgrafico4.add(RelatorioData('Hoje', 2));
        servicosgrafico4.add(RelatorioData('Hoje', 2));
        servicosgrafico4.add(RelatorioData('Hoje', 15));
      });

      // Imprimir as informações
      print(
          'Número de solicitações do cliente para o dia de hoje: $numeroSolicitacoes');
      print('Serviços concluídos para o dia de hoje: $servicosConcluidos');
      print(
          'Total gasto em serviços concluídos para o dia de hoje: $totalGasto');

      print('Gerando relatório para hoje');
    } else if (periodoSelecionado == 'Semana') {
      DateTime inicioSemana =
          dataHoje.subtract(Duration(days: dataHoje.weekday - 1));
      DateTime fimSemana = inicioSemana.add(const Duration(days: 6));
      Timestamp inicioTimestamp = Timestamp.fromDate(inicioSemana);
      Timestamp fimTimestamp = Timestamp.fromDate(fimSemana);

      QuerySnapshot solicitacoesSnapshot = await FirebaseFirestore.instance
          .collection('SolicitacoesServico')
          .where('emailCliente', isEqualTo: emailUsuario)
          .get();

      List<DocumentSnapshot> todasSolicitacoes = solicitacoesSnapshot.docs;

      List<DocumentSnapshot> solicitacoesNaSemana =
          todasSolicitacoes.where((doc) {
        Timestamp dataSolicitacao = doc['data'];
        return dataSolicitacao.toDate().isAfter(inicioSemana) &&
            dataSolicitacao.toDate().isBefore(fimSemana);
      }).toList();

      numeroSolicitacoes = solicitacoesNaSemana.length;
      List<DocumentSnapshot> solicitacoesConcluidas = solicitacoesNaSemana
          .where((doc) => doc['status'] == 'Concluido')
          .toList();

      servicosConcluidos = solicitacoesConcluidas.length;
      totalGasto = 0;
      for (var solicitacao in solicitacoesConcluidas) {
        totalGasto += solicitacao['servico']['valor'];
      }

      setState(() {
        servicosgrafico
            .add(RelatorioData('Semana', numeroSolicitacoes.toDouble()));
        servicosgrafico2
            .add(RelatorioData('Semana', servicosConcluidos.toDouble()));
        servicosgrafico3.add(RelatorioData('Semana', totalGasto));
      });

      // Imprimir as informações
      print(
          'Número de solicitações do cliente para a semana: $numeroSolicitacoes');
      print('Serviços concluídos para a semana: $servicosConcluidos');
      print('Total gasto em serviços concluídos para a semana: $totalGasto');

      print('Gerando relatório para a semana');

      print('Gerando relatório para a semana');
    } else if (periodoSelecionado == 'Mês') {
      print('Gerando relatório para o mês');

      DateTime inicioMes = DateTime(dataHoje.year, dataHoje.month, 1);
      DateTime fimMes = DateTime(dataHoje.year, dataHoje.month + 1, 0);
      Timestamp inicioTimestamp = Timestamp.fromDate(inicioMes);
      Timestamp fimTimestamp = Timestamp.fromDate(fimMes);

      QuerySnapshot solicitacoesSnapshot = await FirebaseFirestore.instance
          .collection('SolicitacoesServico')
          .where('emailCliente', isEqualTo: emailUsuario)
          .get();

      List<DocumentSnapshot> todasSolicitacoes = solicitacoesSnapshot.docs;

      List<DocumentSnapshot> solicitacoesNoMes = todasSolicitacoes.where((doc) {
        Timestamp dataSolicitacao = doc['data'];
        return dataSolicitacao.toDate().isAfter(inicioMes) &&
            dataSolicitacao.toDate().isBefore(fimMes);
      }).toList();

      numeroSolicitacoes = solicitacoesNoMes.length;
      List<DocumentSnapshot> solicitacoesConcluidas = solicitacoesNoMes
          .where((doc) => doc['status'] == 'Concluido')
          .toList();

      servicosConcluidos = solicitacoesConcluidas.length;
      totalGasto = 0;
      for (var solicitacao in solicitacoesConcluidas) {
        totalGasto += solicitacao['servico']['valor'];
      }

      setState(() {
        servicosgrafico
            .add(RelatorioData('Semana', numeroSolicitacoes.toDouble()));
        servicosgrafico2
            .add(RelatorioData('Semana', servicosConcluidos.toDouble()));
        servicosgrafico3.add(RelatorioData('Semana', totalGasto));
      });

      // Imprimir as informações
      print(
          'Número de solicitações do cliente para a semana: $numeroSolicitacoes');
      print('Serviços concluídos para a semana: $servicosConcluidos');
      print('Total gasto em serviços concluídos para a semana: $totalGasto');

      print('Gerando relatório para a semana');
    } else if (periodoSelecionado == 'Ano') {
      print('Gerando relatório para o ano');

      DateTime inicioAno = DateTime(dataHoje.year, 1, 1);
      DateTime fimAno = DateTime(dataHoje.year, 12, 31);
      Timestamp inicioTimestamp = Timestamp.fromDate(inicioAno);
      Timestamp fimTimestamp = Timestamp.fromDate(fimAno);

      QuerySnapshot solicitacoesSnapshot = await FirebaseFirestore.instance
          .collection('SolicitacoesServico')
          .where('emailCliente', isEqualTo: emailUsuario)
          .get();


       List<DocumentSnapshot> todasSolicitacoes = solicitacoesSnapshot.docs;

      List<DocumentSnapshot> solicitacoesNoAno = todasSolicitacoes.where((doc) {
        Timestamp dataSolicitacao = doc['data'];
        return dataSolicitacao.toDate().isAfter(inicioAno) &&
            dataSolicitacao.toDate().isBefore(fimAno);
      }).toList();

      numeroSolicitacoes = solicitacoesNoAno.length;
      List<DocumentSnapshot> solicitacoesConcluidas = solicitacoesNoAno
          .where((doc) => doc['status'] == 'Concluido')
          .toList();

      servicosConcluidos = solicitacoesConcluidas.length;
      totalGasto = 0;
      for (var solicitacao in solicitacoesConcluidas) {
        totalGasto += solicitacao['servico']['valor'];
      }

      setState(() {
        servicosgrafico
            .add(RelatorioData('Ano', numeroSolicitacoes.toDouble()));
        servicosgrafico2
            .add(RelatorioData('Ano', servicosConcluidos.toDouble()));
        servicosgrafico3.add(RelatorioData('Ano', totalGasto));
      });

      // Imprimir as informações
      print(
          'Número de solicitações do cliente para a semana: $numeroSolicitacoes');
      print('Serviços concluídos para a semana: $servicosConcluidos');
      print('Total gasto em serviços concluídos para a semana: $totalGasto');

      

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove o botão de voltar
        backgroundColor: Colors.white, // Define o fundo como branco
        title: const Text(
          'Relatório',
          style: TextStyle(color: Colors.black), // Define o título da página
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildBadge('Hoje'),
                buildBadge('Semana'),
                buildBadge('Mês'),
                buildBadge('Ano'),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Número de Solicitações'),
                buildBarChart(servicosgrafico),
                const SizedBox(height: 20),
                const Text('Serviços Concluídos'),
                buildBarChart(servicosgrafico2),
                const SizedBox(height: 20),
                const Text('Total Gasto'),
                buildBarChart(servicosgrafico3),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBarChart(List<RelatorioData> data) {
    final List<BarChartGroupData> barGroups = [];

    for (var relatorio in data) {
      print("relatorio.periodo.hashCode");
      print(relatorio.periodo.hashCode);
      barGroups.add(
        BarChartGroupData(
          x: relatorio.valor.toInt(),
          barRods: [
            BarChartRodData(
              toY: relatorio.valor,
              color: Colors.blue,
              width: 25,
              borderRadius: BorderRadius.zero,
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    value.toStringAsFixed(
                        1), // Formato para valores com uma casa decimal
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  for (var relatorio in data) {
                    if (relatorio.periodo.hashCode == value.toInt()) {
                      return Text(relatorio.periodo);
                    }
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(width: 1),
              bottom: BorderSide(width: 1),
            ),
          ),
        ),
      ),
    );
  }

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// Widget buildLineChart(List<RelatorioData> data) {
//   final List<LineChartBarData> lineBarsData = [];

//   for (var relatorio in data) {
//     lineBarsData.add(
//       LineChartBarData(
//         spots: [
//           FlSpot(relatorio.valor.toInt().toDouble(), relatorio.valor),
//         ],
//         isCurved: true,
//         color: Colors.blue,
//         barWidth: 4,
//         isStrokeCapRound: true,
//         belowBarData: BarAreaData(show: false),
//       ),
//     );
//   }

// return SizedBox(
//     height: 200,
//     child: LineChart(
//       LineChartData(
//         lineBarsData: lineBarsData,
//         titlesData: FlTitlesData(
//           leftTitles: AxisTitles(
//             sideTitles: SideTitles(
//             showTitles: true,
//             getTitlesWidget: (double value, TitleMeta meta) {
//                 for (var relatorio in data) {
//                   if (relatorio.periodo.hashCode == value.toInt()) {
//                     return Text(relatorio.periodo);
//                   }
//                 }
//                 return Text('');
//               },
//             ),
//           ),
//            bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (double value, TitleMeta meta) {
//                 for (var relatorio in data) {
//                   if (relatorio.periodo.hashCode == value.toInt()) {
//                     return Text(relatorio.periodo);
//                   }
//                 }
//                 return Text('');
//               },
//             ),
//           ),
//         ),
//         gridData: FlGridData(show: true),
//         borderData: FlBorderData(
//           show: true,
//           border: Border(
//             left: BorderSide(width: 1),
//             bottom: BorderSide(width: 1),
//           ),
//         ),
//       ),
//     ),
//   );
// }

  Widget buildBadge(String periodo) {
    bool selecionado = periodo == periodoSelecionado;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            periodoSelecionado = periodo;
          });

          if (tipoUsuario != null) {
            if (tipoUsuario == 'Prestador') {
              _GerarRelatorioPrestador();
            } else {
              _GerarRelatorioSolicitationsCliente();
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: selecionado ? Colors.blue : Colors.grey, // Cor do container
            borderRadius: BorderRadius.circular(20), // Borda arredondada
          ),
          child: Text(
            periodo,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class RelatorioData {
  final String periodo;
  final double valor;

  RelatorioData(this.periodo, this.valor);
}
