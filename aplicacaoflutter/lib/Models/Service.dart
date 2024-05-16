class ServiceModel {
  String descricao;
  double valor;
  String disponibilidade;

  ServiceModel({
    required this.descricao,
    required this.valor,
    required this.disponibilidade,
  });

  Map<String, dynamic> toMap() {
    return {
      'descricao': descricao,
      'valor': valor,
      'disponibilidade': disponibilidade,
    };
  }
}
