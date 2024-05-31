class UserImageDTO {
  final String name;
  final String email;
  final String tipoUser;
  final String? photoURL;
  final String endereco;


  const UserImageDTO({
    required this.name,
    required this.email,
    required this.tipoUser,
    this.photoURL,
    required this.endereco,

  });

  Map<String, dynamic> toJson() {
    return {
      "Name": name,
      "Email": email,
      "TipoUser": tipoUser,
      "photoURL": photoURL,
      "Endereco": endereco,
    };
  }
  factory UserImageDTO.fromJson(Map<String, dynamic> json) {
    return UserImageDTO(
      name: json['Name'],
      email: json['Email'],
      tipoUser: json['TipoUser'],
      photoURL: json['photoURL'],
      endereco: json['Endereco'],
    );
  }
}
