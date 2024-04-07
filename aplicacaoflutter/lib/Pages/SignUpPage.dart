import 'package:flutter/material.dart';
import '../Controllers/UsuarioController.dart';
import '../Models/Usuario.dart';
import 'package:postgres/postgres.dart'; // Importe o pacote PostgreSQL

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Define uma conexão com o PostgreSQL
  final PostgreSQLConnection _connection = PostgreSQLConnection(
    'your_host', // Insira o endereço do seu host PostgreSQL
    5432, // Porta padrão do PostgreSQL
    'your_database_name', // Nome do seu banco de dados
    username: 'your_username', // Nome de usuário do PostgreSQL
    password: 'your_password', // Senha do PostgreSQL
  );

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _selectedType = 'Usuário Comum'; // Valor padrão

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _cpfCnpjController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _enderecoController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  TextEditingController _confirmarSenhaController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  void _cadastrarUsuario() {
    if (_formKey.currentState!.validate()) {
      final user = User(
        nome: _nomeController.text,
        email: _emailController.text,
        senha: _senhaController.text,
        tipo: _selectedType,
        cpf: _selectedType != 'Empresa' ? _cpfCnpjController.text : '',
        cnpj: _selectedType == 'Empresa' ? _cpfCnpjController.text : '',
        telefone: _telefoneController.text,
        endereco: _enderecoController.text,
      );

      // Criar uma instância de UserController passando a conexão como argumento
      final userController = UserController(_connection);

      // Chamar o método cadastrarUsuario do UserController
      userController.cadastrarUsuario(user).then((success) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Usuário cadastrado com sucesso!'),
              duration: Duration(seconds: 2),
            ),
          );

          // Limpar os campos após o cadastro
          _nomeController.clear();
          _emailController.clear();
          _cpfCnpjController.clear();
          _telefoneController.clear();
          _enderecoController.clear();
          _senhaController.clear();
          _confirmarSenhaController.clear();
          setState(() {
            _selectedType = 'Usuário Comum';
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao cadastrar usuário'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuário'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(
                    // Utilize OutlineInputBorder para adicionar bordas
                    borderRadius: BorderRadius.circular(8.0), // Raio da borda
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0), // Cor e largura da borda
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o nome';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(border: OutlineInputBorder(
                    // Utilize OutlineInputBorder para adicionar bordas
                    borderRadius: BorderRadius.circular(8.0), // Raio da borda
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0), // Cor e largura da borda
                  ),labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Por favor, informe um email válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedType,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
                items: <String>['Diarista', 'Empresa', 'Usuário Comum']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(border: OutlineInputBorder(
                    // Utilize OutlineInputBorder para adicionar bordas
                    borderRadius: BorderRadius.circular(8.0), // Raio da borda
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0), // Cor e largura da borda
                  ),labelText: 'Tipo'),
              ),
              SizedBox(height: 12),
              Visibility(
                visible: _selectedType != 'Empresa',
                child: TextFormField(
                  controller: _cpfCnpjController,
                  decoration: InputDecoration(border: OutlineInputBorder(
                    // Utilize OutlineInputBorder para adicionar bordas
                    borderRadius: BorderRadius.circular(8.0), // Raio da borda
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0), // Cor e largura da borda
                  ),
                    labelText: _selectedType == 'Diarista'
                        ? 'CPF'
                        : 'CPF (para Pessoa Física)',
                  ),
                ),
              ),
              SizedBox(height: 12),
              Visibility(
                visible: _selectedType == 'Empresa',
                child: TextFormField(
                  controller: _cpfCnpjController,
                  decoration:
                      InputDecoration(border: OutlineInputBorder(
                    // Utilize OutlineInputBorder para adicionar bordas
                    borderRadius: BorderRadius.circular(8.0), // Raio da borda
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0), // Cor e largura da borda
                  ),labelText: 'CNPJ (para Pessoa Jurídica)'),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(border: OutlineInputBorder(
                    // Utilize OutlineInputBorder para adicionar bordas
                    borderRadius: BorderRadius.circular(8.0), // Raio da borda
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0), // Cor e largura da borda
                  ),labelText: 'Telefone'),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _enderecoController,
                decoration: InputDecoration(border: OutlineInputBorder(
                    // Utilize OutlineInputBorder para adicionar bordas
                    borderRadius: BorderRadius.circular(8.0), // Raio da borda
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0), // Cor e largura da borda
                  ),labelText: 'Endereço'),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _senhaController,
                decoration: InputDecoration(border: OutlineInputBorder(
                    // Utilize OutlineInputBorder para adicionar bordas
                    borderRadius: BorderRadius.circular(8.0), // Raio da borda
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0), // Cor e largura da borda
                  ),
                  labelText: 'Senha',
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                obscureText: !_isPasswordVisible,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _confirmarSenhaController,
                decoration: InputDecoration(border: OutlineInputBorder(
                    // Utilize OutlineInputBorder para adicionar bordas
                    borderRadius: BorderRadius.circular(8.0), // Raio da borda
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0), // Cor e largura da borda
                  ),
                  labelText: 'Confirmar Senha',
                  suffixIcon: IconButton(
                    icon: Icon(_isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: _toggleConfirmPasswordVisibility,
                  ),
                ),
                obscureText: !_isConfirmPasswordVisible,
                validator: (value) {
                  if (value != _senhaController.text) {
                    return 'As senhas não correspondem';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _cadastrarUsuario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Fechar a conexão com o PostgreSQL ao descartar a página
    _connection.close();
    super.dispose();
  }
}
