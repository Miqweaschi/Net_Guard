// Questo modello rappresenta ogni singolo dispositivo scovato nella rete locale.
class NetworkDevice {
  final String ip;
  final String macAddress;
  final String hostname;
  final bool isWritable; // Identifica se risponde a servizi comuni (es. HTTP)

  NetworkDevice({
    required this.ip,
    required this.macAddress,
    required this.hostname,
    this.isWritable = false,
  });

  // Bisonga comvertire l'oggetto in una mappa JSON per poterlo salvare facilmente in Hive
  Map<String, dynamic> toMap() {
    return {
      'ip': ip,
      'macAddress': macAddress,
      'hostname': hostname,
      'isWritable': isWritable,
    };
  }

  // Metodo per ricostruire l'oggetto quando lo leggiamo da Hive
  factory NetworkDevice.fromMap(Map<dynamic, dynamic> map) {
    return NetworkDevice(
      ip: map['ip'] as String,
      macAddress: map['macAddress'] as String,
      hostname: map['hostname'] as String,
      isWritable: map['isWritable'] as bool? ?? false,
    );
  }
}