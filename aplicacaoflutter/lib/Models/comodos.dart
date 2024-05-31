class Comodos {
  final int sala;
  final int quarto;
  final int banheiro;
  final int cozinha;
  final int escritorio;

  Comodos(this.sala, this.quarto, this.banheiro, this.cozinha, this.escritorio);

   Map<String, dynamic> toJson() {
    return {
      'sala': sala,
      'quarto': quarto,
      'banheiro': banheiro,
      'cozinha': cozinha,
      'escritorio': escritorio,
    };
  }
}
