import 'package:postgres/postgres.dart';

class DatabaseController {
  late PostgreSQLConnection _connection;

  Future<void> connectToDatabase() async {
    _connection = PostgreSQLConnection(
      'teste.cdisi2ucmeok.us-east-1.rds.amazonaws.com',
      5432,
      'pjs2024',
      username: 'teste',
      password: 'password',
    );

    await _connection.open();
    print('Conexão com o banco de dados PostgreSQL estabelecida.');
  }

  Future<void> closeConnection() async {
    await _connection.close();
    print('Conexão com o banco de dados PostgreSQL fechada.');
  }

}
