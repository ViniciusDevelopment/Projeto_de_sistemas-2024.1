import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:servicocerto/Controller/UserController.dart';
import 'package:servicocerto/Models/User.dart';
import 'package:servicocerto/PagesCommon/loginPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:brasil_fields/brasil_fields.dart'; // Biblioteca para validação de CPF

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  String? _selectedTipoUser;
  final List<String> _userTypes = ['Cliente', 'Prestador'];
  File? _profileImage;

  Future<void> registerUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        // Criar usuário no Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Upload da foto de perfil
        String? photoURL;
        if (_profileImage != null) {
          photoURL = await UserController.instance.uploadImage(_profileImage!);
        }

        // Criar usuário no seu sistema
        await UserController.instance.createUser(
          UserModel(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            cpf: _cpfController.text.trim(),
            name: _nameController.text.trim(),
            telefone: _telefoneController.text.trim(),
            endereco: _enderecoController.text.trim(),
            tipoUser: _selectedTipoUser ?? '',
          ),
          photoURL: photoURL, // Passando photoURL aqui
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
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
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
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const Text(
                      "Cadastrar",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Crie sua conta gratuitamente",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    inputFile(
                      label: "Email",
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (!EmailValidator.validate(value)) {
                          return 'Email inválido';
                        }
                        return null;
                      },
                    ),
                    inputFile(
                      label: "Senha",
                      obscureText: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (value.length < 6) {
                          return 'A senha deve ter pelo menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    inputFile(
                      label: "CPF",
                      controller: _cpfController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (!CPFValidator.isValid(value)) {
                          return 'CPF inválido';
                        }
                        return null;
                      },
                    ),
                    inputFile(
                      label: "Nome",
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),
                    inputFile(
                      label: "Telefone",
                      controller: _telefoneController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (!RegExp(r'^\(\d{2}\) \d{4,5}-\d{4}$')
                            .hasMatch(value)) {
                          return 'Telefone inválido';
                        }
                        return null;
                      },
                    ),
                    inputFile(
                      label: "Endereço",
                      controller: _enderecoController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
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
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Tipo de Usuário',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                                size: 50,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _profileImage == null
                          ? "Adicionar Foto de Perfil"
                          : "Foto de Perfil Selecionada",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.black),
                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 50, // Reduzido de 60 para 50
                    onPressed: () => registerUser(context),
                    color: const Color(0xff0095FF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text(
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
                    const Text("Possui uma conta?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text(
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
      ),
    );
  }
}

// Widget personalizado para entrada de texto
Widget inputFile(
    {required String label,
    bool obscureText = false,
    required TextEditingController controller,
    required String? Function(String?)? validator}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      const SizedBox(
        height: 5,
      ),
      TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(8.0),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        validator: validator,
      ),
      const SizedBox(height: 10),
    ],
  );
}
