class UserListImageDTO {
  final String name;
  final String email;
  final String tipoUser;
  final String? photoURL;
  final String descricao;
  final String disponibilidade;
  final num valor;
  final double? rating;
  final int ratingCount;

  const UserListImageDTO({
    required this.name,
    required this.email,
    required this.tipoUser,
    this.photoURL,
    required this.descricao,
    required this.disponibilidade,
    required this.valor,
    this.rating,
    required this.ratingCount,
  });

  Map<String, dynamic> toJson() {
    return {
      "Name": name,
      "Email": email,
      "TipoUser": tipoUser,
      "photoURL": photoURL,
      "descricao": descricao,
      "disponibilidade": disponibilidade,
      "valor": valor,
      "rating": rating,
      "ratingCount": ratingCount,
    };
  }

  factory UserListImageDTO.fromJson(Map<String, dynamic> json) {
    return UserListImageDTO(
      name: json['Name'],
      email: json['Email'],
      tipoUser: json['TipoUser'],
      photoURL: json['photoURL'],
      descricao: json['descricao'],
      disponibilidade: json['disponibilidade'],
      valor: json['valor'],
      rating: json['rating'],
      ratingCount: json['ratingCount'],
    );
  }
}
