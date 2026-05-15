
 // Questo è il file da cui parte l'intera applicazione

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app_router.dart';

void main() async {
  // Assicura che i binding di Flutter siano pronti prima di inizializzare Hive
  WidgetsFlutterBinding.ensureInitialized();

  // Inizializza il database locale Hive per Flutter
  await Hive.initFlutter();

  // Apriamo una Box dove salveremo la cronologia delle scansioni
  await Hive.openBox('network_history');

  runApp(
    const ProviderScope(  // ProviderScope è FONDAMENTALE per Riverpod.
                          // Avvolge l'intera applicazione dentro ProviderScope. Senza questo "recinto",
                          // Riverpod non potrebbe far girare i suoi dati e l'app andrebbe in crash.
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Colleghiamo GoRouter per la gestione delle pagine
      routerConfig: appRouter,
      title: 'NetGuard',
      debugShowCheckedModeBanner: false,

      //tema scuro
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
        ),
      ),
    );
  }
}