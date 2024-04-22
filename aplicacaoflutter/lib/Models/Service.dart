class ServiceModel {
  final String descricao;


  const ServiceModel(
      {required this.descricao,});

  toJson() {
    return {
      "Descricao": descricao,

    };
  }
}
