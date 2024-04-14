import 'dart:ffi';

class UserModel {
  final String name;
  final String email;
  final String cpf;
  final String password;
  final String telefone;
  final String endereco;
  final String tipoUser;

  const UserModel(
      {required this.name,
      required this.email,
      required this.cpf,
      required this.telefone,
      required this.password,
      required this.endereco,
      required this.tipoUser});

  toJson() {
    return {
      "Name": name,
      "Email": email,
      "Cpf": cpf,
      "Password": password,
      "Telefone": telefone,
      "Endereco": endereco,
      "TipoUser": tipoUser,
    };
  }
}
