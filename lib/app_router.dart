import 'package:go_router/go_router.dart';
import 'home_screen.dart';
import 'device_detail_screen.dart';

// Invece di usare il vecchio sistema di Flutter per caricare le pagine
// che può diventare confusionario, ho deciso di utilizzare un sistema basato
// su URL

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(
      path: '/detail/:ip',  //I due punti (:ip) indicano un parametro dinamico.
                            // Quando clicchi su un dispositivo, GoRouter prende
                            // il suo IP (es. 192.168.1.5), lo mette nell'URL e
                            // lo passa come pacchetto alla schermata di dettaglio,
                            //permettendole di sapere su quale dispositivo stai investigando.

      builder: (context, state) {
        final deviceIp = state.pathParameters['ip'] ?? 'Sconosciuto';
        return DeviceDetailScreen(ip: deviceIp);
      },
    ),
  ],
);