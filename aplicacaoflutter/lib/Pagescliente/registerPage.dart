import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:servicocerto/Controller/UserController.dart';
import 'package:servicocerto/Models/User.dart';
import 'package:servicocerto/Pagescliente/loginPage.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  String? _selectedTipoUser;
  final List<String> _userTypes = ['Cliente', 'Prestador'];

  Future<void> registerUser(BuildContext context) async {
    try {
      // Criar usuário no Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Criar usuário no seu sistema
      await UserController().createUser(
        UserModel(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          cpf: _cpfController.text.trim(),
          name: _nameController.text.trim(),
          telefone: _telefoneController.text.trim(),
          endereco: _enderecoController.text.trim(),
          tipoUser: _selectedTipoUser ?? '',
        ),
      );

      // Redirecionar para a próxima tela após o registro bem-sucedido
      Navigator.pop(context); // Voltar para a tela anterior após o registro
    } on FirebaseAuthException catch (e) {
      // Tratar erros de autenticação do Firebase
      print("Erro de registro: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao registrar usuário: ${e.message}"),
        ),
      );
    } catch (e) {
      // Outros erros
      print("Erro ao registrar usuário: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao registrar usuário: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Cadastrar",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Crie sua conta gratuitamente ",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  inputFile(label: "Email", controller: _emailController),
                  inputFile(label: "Senha", obscureText: true, controller: _passwordController),
                  inputFile(label: "CPF", controller: _cpfController),
                  inputFile(label: "Nome", controller: _nameController),
                  inputFile(label: "Telefone", controller: _telefoneController),
                  inputFile(label: "Endereço", controller: _enderecoController),
                  DropdownButtonFormField<String>(
                    value: _selectedTipoUser,
                    items: _userTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      _selectedTipoUser = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Tipo de Usuário',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 3, left: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.black),
                ),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () => registerUser(context),
                  color: Color(0xff0095FF),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "Cadastrar",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Possui uma conta?"),
                  TextButton(
                     onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget personalizado para entrada de texto
Widget inputFile({required String label, bool obscureText = false, required TextEditingController controller}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(8.0),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      SizedBox(height: 10),
    ],
  );
}




// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:servicocerto/Controller/UserController.dart';
// import 'package:servicocerto/Models/User.dart';
// import '../Controller/authCheck.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({Key? key}) : super(key: key);

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   String? errorMessage = '';
//   String? _selectedTipoUser;
//   final List<String> _userTypes = ['Cliente', 'Prestador'];

//   final TextEditingController _controllerEmail = TextEditingController();
//   final TextEditingController _controllerPassword = TextEditingController();
//   final TextEditingController _controllerCPF = TextEditingController();
//   final TextEditingController _controllerTelefone = TextEditingController();
//   final TextEditingController _controllerEndereco = TextEditingController();
//   final TextEditingController _controllerName = TextEditingController();

//   Future<void> createUserWithEmailAndPassword() async {
//     try {
//       await Authentication().createUserWithEmailAndPassword(
//           email: _controllerEmail.text, password: _controllerPassword.text);
//       await UserController().createUser(UserModel(
//           name: _controllerName.text,
//           email: _controllerEmail.text,
//           cpf: _controllerCPF.text,
//           telefone: _controllerTelefone.text,
//           password: _controllerPassword.text,
//           endereco: _controllerEndereco.text,
//           tipoUser: _selectedTipoUser ?? ''));

//           Navigator.pop(context);
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         errorMessage = e.message;
//       });
//     }
//   }

//   Widget _title() {
//     return const Text('Cadastrar Usuário');
//   }

//   Widget _entryField(String title, TextEditingController controller) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: title,
//       ),
//     );
//   }

//   Widget _tipoUserDropdown() {
//     return DropdownButtonFormField<String>(
//       value: _selectedTipoUser,
//       items: _userTypes.map((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//       onChanged: (String? value) {
//         setState(() {
//           _selectedTipoUser = value;
//         });
//       },
//       decoration: const InputDecoration(
//         labelText: 'Tipo de Usuário',
//         border: OutlineInputBorder(),
//       ),
//     );
//   }

//   Widget _errorMessage() {
//     return Text(errorMessage == '' ? '' : "Error: $errorMessage");
//   }

//   Widget _submitButton() {
//     return ElevatedButton(
//       onPressed: createUserWithEmailAndPassword,
//       child: const Text('Register'),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: _title(),
//       ),
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         padding: const EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           // Adicione SingleChildScrollView para evitar overflow
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               _entryField('Email', _controllerEmail),
//               _entryField('Password', _controllerPassword),
//               _entryField('CPF', _controllerCPF),
//               _entryField('Nome Completo', _controllerName),
//               _entryField('Telefone', _controllerTelefone),
//               _entryField('Endereço', _controllerEndereco),
//               _tipoUserDropdown(),
//               _errorMessage(),
//               _submitButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
