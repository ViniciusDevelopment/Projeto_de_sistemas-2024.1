// ignore: file_names, depend_on_referenced_packages
import 'package:postgres/postgres.dart';
import '../Models/Usuario.dart';

class UserController {
  final PostgreSQLConnection _connection;

  UserController(this._connection);

  Future<bool> cadastrarUsuario(User user) async {
    try {
      await _connection.open();

      // Montar o comando SQL para inserir o usuário na tabela
      final result = await _connection.query('''
        INSERT INTO Usuarios (Nome, Email, Senha, Tipo, CPF, CNPJ, Telefone, Endereco)
        VALUES (@nome, @email, @senha, @tipo, @cpf, @cnpj, @telefone, @endereco)
      ''', substitutionValues: {
        'nome': user.nome,
        'email': user.email,
        'senha': user.senha,
        'tipo': user.tipo,
        'cpf': user.cpf,
        'cnpj': user.cnpj,
        'telefone': user.telefone,
        'endereco': user.endereco,
      });

      print('Usuário cadastrado com sucesso!');
      return true; // Indicar que o cadastro foi realizado com sucesso
    } catch (e) {
      print('Erro ao cadastrar usuário: $e');
      return false; // Indicar que ocorreu um erro ao cadastrar o usuário
    } finally {
      await _connection.close();
    }
  }
}
