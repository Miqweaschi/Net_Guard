# NetGuard

Un'applicazione mobile moderna sviluppata in **Flutter** per la scansione e la diagnostica delle reti locali (LAN). L'app identifica i dispositivi attivi all'interno della stessa rete Wi-Fi scansionando le porte più comuni.

---

##  Funzionalità

*   **Rilevamento IP Locale:** Identifica istantaneamente l'indirizzo IP del dispositivo su cui è eseguita l'app.
*   **Scansione di Sottorete:** Scansiona l'intera sottorete (254 indirizzi IP).
*   **Port Scanning Integrato:** Verifica lo stato dei dispositivi interrogando le porte più comuni (`80`, `443`, `22`, `135`, `445`, `5357`, `8000`).
*   **Dettaglio Dispositivo & Navigazione:** Interfaccia dedicata per analizzare il singolo IP.
*   **Salvataggio Locale:** Cronologia e preferiti integrati per salvare i dispositivi rilevati.

---

## Stack Tecnologico & Pacchetti

L'architettura dell'applicazione si basa sulle migliori librerie dell'ecosistema Flutter:

*   **Stato:** [Flutter Riverpod](https://pub.dev/packages/flutter_riverpod) (Gestione dello stato reattiva e scalabile)
*   **Navigazione:** [GoRouter](https://pub.dev/packages/go_router) (Gestione delle rotte di tipo dichiarativo)
*   **Database Locale:** [Hive Flutter](https://pub.dev/packages/hive_flutter) (Database NoSQL leggero e performante per la cronologia)
*   **Rete:** [Network Info Plus](https://pub.dev/packages/network_info_plus) & [HTTP](https://pub.dev/packages/http) (Per l'analisi dell'interfaccia Wi-Fi e richieste di test)

---


## Interfaccia

<img width="30%" alt="WhatsApp Image 2026-05-15 at 21 34 57" src="https://github.com/user-attachments/assets/ffe3d633-16e2-47bc-80aa-0636f6d629c0" />       <img width="30%" height="1560" alt="WhatsApp Image 2026-05-15 at 21 35 33" src="https://github.com/user-attachments/assets/235f684b-5ea4-468a-9c61-aa3e48deb03b" />

---  


## Come Avviare il Progetto

### Prerequisiti
Assicurati di avere Flutter installato sul tuo sistema (`flutter doctor` deve essere verde).

1. Clona la repository:
   ```bash
   git clone https://github.com/Miqweaschi/Net_Guard
