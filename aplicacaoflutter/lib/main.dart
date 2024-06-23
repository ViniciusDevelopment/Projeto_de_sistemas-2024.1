import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:servicocerto/Controller/ServiceController.dart';
import 'package:servicocerto/Controller/UserController.dart';
import 'package:servicocerto/Controller/ratingController.dart';
import 'package:servicocerto/providers.dart';
import 'firebase_options.dart';
import 'index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(ServiceController());
  Get.put(RatingServiceController());
  Get.put(UserController()); // Inicializar o UserController
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    MultiProvider(
      providers: providers,
      child: const MyApp(),
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Color secondary = Colors.green; // Cor secundária
    Color onSecondary = Colors.white; // Cor do texto sobre a cor secundária
    Color error = Colors.red; // Cor para indicar erros
    Color onError = Colors.white; // Cor do texto sobre a cor de erro
    Color surface = Colors.white; // Cor da superfície
    Color onSurface = Colors.black; // Cor do texto sobre a superfície

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.blue,
          onPrimary: Colors.white,
          secondary: secondary,
          onSecondary: onSecondary,
          error: error,
          onError: onError,
          surface: surface,
          onSurface: onSurface,
        ),
        primarySwatch: Colors.blue,
        brightness: Brightness.light, // Definindo tema claro
        scaffoldBackgroundColor: Colors.white, // Fundo branco
      ),
      home: const IndexPage(),
    );
  }
}
