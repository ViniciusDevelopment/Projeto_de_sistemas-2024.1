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
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Erro ao inicializar o Firebase: $e');
  }

  Get.put(ServiceController());
  Get.put(RatingServiceController());
  Get.put(UserController());

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
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: const ColorScheme(
                background: Colors.white,
                onBackground: Colors.black,
                brightness: Brightness.light,
                primary: Colors.blue,
                onPrimary: Colors.white,
                secondary: Colors.green,
                onSecondary: Colors.white,
                error: Colors.red,
                onError: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
            ),
            home: const IndexPage(),
          );
        }
        return const CircularProgressIndicator(); // Indicador de carregamento enquanto Firebase é inicializado
      },
    );
  }
}
