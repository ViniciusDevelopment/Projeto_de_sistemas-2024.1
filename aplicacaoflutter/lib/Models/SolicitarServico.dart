import 'package:servicocerto/DTO/Request/ServiceDTO.dart';

class SolicitarServico {
  final ServiceModelDTO servico;
  final String data;
  final String hora;
  final String emailPrestador;
  final String emailCliente;
  final String status;

  const SolicitarServico({
    required this.servico,
    required this.data,
    required this.hora,
    required this.emailPrestador,
    required this.emailCliente,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "servico": servico.toJson(), // Chamar toJson aqui
      "data": data,
      "hora": hora,
      "emailPrestador": emailPrestador,
      "emailCliente": emailCliente,
      "status": status,
    };
  }
}
