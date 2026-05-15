import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'scanner_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ascoltiamo lo stato del provider
    final scannerState = ref.watch(scannerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NetGuard'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card informativa sull'IP del tuo telefono
            Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tuo IP Locale:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      scannerState.localIp,
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Messaggio di errore se presente
            if (scannerState.errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  scannerState.errorMessage,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),

            // Pulsante di Scansione / Indicatore Caricamento
            ElevatedButton.icon(
              onPressed: scannerState.isLoading
                  ? null // Disabilitato se sta già scansionando
                  : () => ref.read(scannerProvider.notifier).startScan(),
              icon: scannerState.isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.radar),
              label: Text(scannerState.isLoading ? 'Scansione in corso...' : 'Avvia Scansione Rete'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 20),

            // Lista dei dispositivi trovati
            Expanded(
              child: scannerState.devices.isEmpty
                  ? Center(
                child: Text(
                  scannerState.isLoading
                      ? 'Sto cercando i dispositivi...'
                      : 'Nessun dispositivo rilevato.\nClicca sul pulsante in alto.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: scannerState.devices.length,
                itemBuilder: (context, index) {
                  final device = scannerState.devices[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.devices),
                      ),
                      title: Text(device.ip),
                      subtitle: Text('Host: ${device.hostname}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Navighiamo al dettaglio usando GoRouter passandogli l'IP
                        context.go('/detail/${device.ip}');
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}