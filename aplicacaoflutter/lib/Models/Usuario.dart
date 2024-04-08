import 'package:postgres/postgres.dart';

class User {
  final String nome;
  final String email;
  final String senha;
  final String tipo;
  final String cpf;
  final String cnpj;
  final String telefone;
  final String endereco;

  User({
    required this.nome,
    required this.email,
    required this.senha,
    required this.tipo,
    this.cpf = '',
    this.cnpj = '',
    required this.telefone,
    required this.endereco,
  });
}
