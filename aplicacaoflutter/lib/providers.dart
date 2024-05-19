import 'package:provider/provider.dart';
import 'package:servicocerto/Repository/UserRepository.dart';

final providers = [

  ChangeNotifierProvider<UserRepository>(
    create: (context) => UserRepository(),
  ),
  // Provider<UsuariosRepository>(
  //   create: (context) => UsuariosRepository(),
  // ),
  // ChangeNotifierProvider<UsuariosController>(
  //   create: (context) => UsuariosController(
  //     usuariosRepository: context.read<UsuariosRepository>(),
  //   ),
  // ),
];