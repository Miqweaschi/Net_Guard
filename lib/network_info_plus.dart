import 'dart:async';
import 'dart:io';
import 'package:network_info_plus/network_info_plus.dart';
import 'network_device.dart';

class NetworkService {
  final _networkInfo = NetworkInfo();

  // Recupera l'IP del telefono connesso al Wi-Fi
  Future<String?> getLocalIp() async {
    try {
      return await _networkInfo.getWifiIP();
    } catch (e) {
      return null;
    }
  }

  // Scansiona la sottorete cercando dispositivi attivi
  Stream<NetworkDevice> scanSubnet(String localIp) async* {
    final String subnet = localIp.substring(0, localIp.lastIndexOf('.'));

    // Lista delle porte da controllare
    final List<int> commonPorts = [80, 443, 135, 445, 5357, 22, 8000];

    for (int i = 1; i <= 254; i++) {
      final String targetIp = '$subnet.$i';

      if (targetIp == localIp) continue;

      bool isDeviceAlive = false;

      //Controlla ogni porta nella lista per questo IP
      for (int port in commonPorts) {
        final bool isOpen = await _checkPort(targetIp, port);

        if (isOpen) {
          isDeviceAlive = true;
          break; // Se almeno una porta risponde, il dispositivo è attivo
        }
      }

      // Se il dispositivo ha risposto a una delle porte, lo inviamo alla UI
      if (isDeviceAlive) {
        yield NetworkDevice(
          ip: targetIp,
          macAddress: '00:1A:2B:3C:4D:5E',
          hostname: i == 1 ? 'Gateway della Rete' : 'Dispositivo Rilevato',
          isWritable: true,
        );
      }
    }
  }

  // Funzione che effettua un ping per controllare se la porta è aperta
  Future<bool> _checkPort(String ip, int port) async {
    try {
      final socket = await Socket.connect(
        ip,
        port,
        timeout: const Duration(milliseconds: 150), // Tempo di attesa ridotto per essere veloci
      );
      socket.destroy(); // Chiudiamo subito la connessione se ha successo
      return true;
    } catch (_) {
      return false; // Se va in timeout o rifiuta, assumiamo che non ci sia nulla
    }
  }
}