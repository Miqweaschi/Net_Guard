import 'dart:async';
import 'dart:io';
import 'package:dart_ping/dart_ping.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'network_device.dart';

class NetworkService {
  final _networkInfo = NetworkInfo();

  Future<String?> getLocalIp() async {
    try {
      return await _networkInfo.getWifiIP();
    } catch (e) {
      return null;
    }
  }

  Stream<NetworkDevice> scanSubnet(String localIp) async* {
    final subnet = localIp.substring(0, localIp.lastIndexOf('.'));
    final foundIps = <String>{};


    // Legge /proc/net/arp, una tabella con i dispositivi che hanno già comunicato in rete (anche con firewall attivo)
    final arpHosts = await _readArpTable();
    for (final ip in arpHosts) {
      if (ip == localIp || !ip.startsWith(subnet)) continue;
      foundIps.add(ip);
      yield await _buildDevice(ip);
    }


    // Copre i dispositivi non ancora nella ARP table.
    // Batch da 30 IP contemporaneamente per bilanciare velocità e risorse.
    final remainingIps = List.generate(254, (i) => '$subnet.${i + 1}')
        .where((ip) => ip != localIp && !foundIps.contains(ip))
        .toList();

    const batchSize = 30;
    for (int i = 0; i < remainingIps.length; i += batchSize) {
      final batch = remainingIps.skip(i).take(batchSize).toList();

      final results = await Future.wait(
        batch.map((ip) => _pingHost(ip)),
      );

      for (int j = 0; j < batch.length; j++) {
        if (results[j] && !foundIps.contains(batch[j])) {
          foundIps.add(batch[j]);
          yield await _buildDevice(batch[j]);
        }
      }
    }
  }

  // Legge la ARP table del kernel Linux.
  // Disponibile su tutti gli Android senza root né permessi speciali.
  // Contiene tutti i dispositivi che hanno comunicato di recente nella LAN.
  Future<List<String>> _readArpTable() async {
    try {
      final file = File('/proc/net/arp');
      if (!await file.exists()) return [];

      final lines = await file.readAsLines();
      final hosts = <String>[];

      for (final line in lines.skip(1)) { // skip intestazione
        final parts = line.trim().split(RegExp(r'\s+'));
        if (parts.length < 4) continue;

        final ip    = parts[0];
        final flags = parts[2];
        final mac   = parts[3];

        // flags 0x2 = ATF_COM: entry completa e host raggiungibile
        // Scarta entry incomplete (host spento da poco)
        if (flags == '0x2' && mac != '00:00:00:00:00:00') {
          hosts.add(ip);
        }
      }
      return hosts;
    } catch (_) {
      return [];
    }
  }

  // ICMP ping via dart_ping.
  // Rileva host anche se hanno tutte le porte TCP/UDP chiuse.
  Future<bool> _pingHost(String ip) async {
    try {
      final ping = Ping(ip, count: 1, timeout: 1, ttl: 64);
      await for (final event in ping.stream) {
        if (event.response != null) return true;
        if (event.error != null)    return false;
      }
    } catch (_) {}
    return false;
  }

  // Costruisce un NetworkDevice arricchendolo con MAC e hostname.
  Future<NetworkDevice> _buildDevice(String ip) async {
    final lastOctet = int.tryParse(ip.split('.').last) ?? 0;

    // MAC address dalla ARP table (già popolata dopo il ping)
    final mac = await _getMacFromArp(ip);

    // Hostname: prova reverse DNS, fallback su label smart
    String hostname = await _resolveHostname(ip, lastOctet);

    return NetworkDevice(
      ip: ip,
      macAddress: mac,
      hostname: hostname,
      isWritable: true,
    );
  }

  // Risolve l'hostname tramite reverse DNS.
  Future<String> _resolveHostname(String ip, int lastOctet) async {
    if (lastOctet == 1) return 'Gateway della Rete';
    try {
      final result = await InternetAddress(ip).reverse()
          .timeout(const Duration(seconds: 2));
      // Restituisce l'hostname solo se è diverso dall'IP stesso
      if (result.host != ip && result.host.isNotEmpty) {
        return result.host;
      }
    } catch (_) {}
    return 'Dispositivo Rilevato';
  }

  // Legge il MAC address di un IP specifico dalla ARP table.
  Future<String> _getMacFromArp(String ip) async {
    try {
      final file = File('/proc/net/arp');
      if (!await file.exists()) return 'N/A';

      final lines = await file.readAsLines();
      for (final line in lines.skip(1)) {
        final parts = line.trim().split(RegExp(r'\s+'));
        if (parts.length >= 4 && parts[0] == ip) {
          return parts[3].toUpperCase();
        }
      }
    } catch (_) {}
    return 'N/A';
  }
}