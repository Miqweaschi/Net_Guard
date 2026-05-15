import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'network_device.dart';
import 'network_info_plus.dart';

// Lo stato che la nostra UI osserverà
class ScannerState {
  final List<NetworkDevice> devices;
  final bool isLoading;
  final String localIp;
  final String errorMessage;

  ScannerState({
    this.devices = const [],
    this.isLoading = false,
    this.localIp = 'Non connesso',
    this.errorMessage = '',
  });

  // Metodo di utilità per aggiornare solo alcune parti dello stato
  ScannerState copyWith({
    List<NetworkDevice>? devices,
    bool? isLoading,
    String? localIp,
    String? errorMessage,
  }) {
    return ScannerState(
      devices: devices ?? this.devices,
      isLoading: isLoading ?? this.isLoading,
      localIp: localIp ?? this.localIp,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}




// Il controller che gestisce la logica di scansione
class ScannerNotifier extends StateNotifier<ScannerState> {
  final NetworkService _networkService = NetworkService();

  ScannerNotifier() : super(ScannerState());

  // Avvia la scansione della rete
  Future<void> startScan() async {
    // Mettiamo lo stato in caricamento e svuotiamo la lista precedente
    state = state.copyWith(isLoading: true, devices: [], errorMessage: '');

    // Recuperiamo l'IP del nostro telefono
    final myIp = await _networkService.getLocalIp();

    if (myIp == null) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Impossibile ottenere l\'IP locale. Verifica di essere connesso al Wi-Fi.',
      );
      return;
    }

    // Aggiorniamo lo stato con il nostro IP attuale
    state = state.copyWith(localIp: myIp);

    // Ascoltiamo lo stream dei dispositivi scoperti nella sottorete
    _networkService.scanSubnet(myIp).listen(
          (device) {
        // Ogni volta che lo stream trova un dispositivo, lo aggiungiamo alla lista esistente
        state = state.copyWith(
          devices: [...state.devices, device],
        );
      },
      onError: (error) {
        state = state.copyWith(errorMessage: 'Errore durante la scansione.');
      },
      onDone: () {
        // La scansione è terminata su tutti i 254 IP
        state = state.copyWith(isLoading: false);
      },
    );
  }
}

// Il Provider globale che useremo nei widget per leggere e modificare lo stato
final scannerProvider = StateNotifierProvider<ScannerNotifier, ScannerState>((ref) {
  return ScannerNotifier();
});