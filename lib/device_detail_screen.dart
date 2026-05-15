import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DeviceDetailScreen extends StatelessWidget {
  final String ip;

  const DeviceDetailScreen({super.key, required this.ip});

  // Funzione per salvare l'IP nello storico/preferiti di Hive
  void _salvaSuHive(BuildContext context) {
    final box = Hive.box('network_history');

    // Salviamo l'IP usando come chiave il timestamp corrente
    final String chiave = DateTime.now().millisecondsSinceEpoch.toString();
    box.put(chiave, ip);

    // Mostriamo un feedback all'utente
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('IP $ip salvato nella cronologia locale!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettaglio Dispositivo'),
        // Gestisce automaticamente il pulsante "Indietro" grazie a GoRouter
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card con i dettagli principali
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info_outline, color: Colors.cyan),
                      title: const Text('Indirizzo IP'),
                      subtitle: Text(ip, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const Divider(),
                    const ListTile(
                      leading: Icon(Icons.code, color: Colors.cyan),
                      title: Text('Porta Monitorata'),
                      subtitle: Text('Porta 80 (HTTP) - Aperta/Attiva'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Pulsanti di Azione
            ElevatedButton.icon(
              onPressed: () => _salvaSuHive(context),
              icon: const Icon(Icons.bookmark_add),
              label: const Text('Salva nei Preferiti (Hive)'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () {
                // Work in progress
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Richiesta HTTP simulata verso il dispositivo.')),
                );
              },
              icon: const Icon(Icons.http),
              label: const Text('Invia Richiesta HTTP di Test'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}