import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:servicocerto/Controller/UserController.dart';
import 'package:servicocerto/Models/User.dart';
import 'package:servicocerto/pages/loginPage.dart';
import '../Controller/authCheck.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? errorMessage = '';
  String? _selectedTipoUser;
  final List<String> _userTypes = ['Cliente', 'Prestador'];

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerCPF = TextEditingController();
  final TextEditingController _controllerTelefone = TextEditingController();
  final TextEditingController _controllerEndereco = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerTipoUser = TextEditingController();

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Authentication().createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
      await UserController().createUser(UserModel(
          name: _controllerName.text,
          email: _controllerEmail.text,
          cpf: _controllerCPF.text,
          telefone: _controllerTelefone.text,
          password: _controllerPassword.text,
          endereco: _controllerEndereco.text,
          tipoUser: _controllerTipoUser.text));
      /*Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );*/
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Text('Register');
  }

  Widget _entryField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _tipoUserDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedTipoUser,
      items: _userTypes.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _selectedTipoUser = value;
          _controllerTipoUser.text = value ?? '';
        });
      },
      decoration: const InputDecoration(
        labelText: 'Tipo de Usuário',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : "Error: $errorMessage");
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: createUserWithEmailAndPassword,
      child: const Text('Register'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _entryField('Email', _controllerEmail),
            _entryField('Password', _controllerPassword),
            _entryField('CPF', _controllerCPF),
            _entryField('Nome Completo', _controllerName),
            _entryField('Telefone', _controllerTelefone),
            _entryField('Endereço', _controllerEndereco),
            _tipoUserDropdown(),
            _errorMessage(),
            _submitButton(),
          ],
        ),
      ),
    );
  }
}
