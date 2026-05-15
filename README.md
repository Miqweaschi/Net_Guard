# 🔌 NetGuard

Un'applicazione mobile moderna sviluppata in **Flutter** per la scansione e la diagnostica delle reti locali (LAN). L'app identifica i dispositivi attivi all'interno della stessa rete Wi-Fi scansionando le porte più comuni in modo asincrono e parallelo, garantendo prestazioni ultra-rapide.

---

## 🚀 Funzionalità

*   **Rilevamento IP Locale:** Identifica istantaneamente l'indirizzo IP del dispositivo su cui è eseguita l'app.
*   **Scansione di Sottorete Ultra-Veloce:** Scansiona l'intera sottorete (254 indirizzi IP) in parallelo in pochissimi secondi.
*   **Port Scanning Integrato:** Verifica lo stato dei dispositivi interrogando le porte più comuni (`80`, `443`, `22`, `135`, `445`, `5357`, `8000`).
*   **Dettaglio Dispositivo & Navigazione:** Interfaccia dedicata per analizzare il singolo IP.
*   **Salvataggio Locale:** Cronologia e preferiti integrati per salvare i dispositivi rilevati.

---

## 🛠️ Stack Tecnologico & Pacchetti

L'architettura dell'applicazione si basa sulle migliori librerie dell'ecosistema Flutter:

*   **Stato:** [Flutter Riverpod](https://pub.dev/packages/flutter_riverpod) (Gestione dello stato reattiva e scalabile)
*   **Navigazione:** [GoRouter](https://pub.dev/packages/go_router) (Gestione delle rotte di tipo dichiarativo)
*   **Database Locale:** [Hive Flutter](https://pub.dev/packages/hive_flutter) (Database NoSQL leggero e performante per la cronologia)
*   **Rete:** [Network Info Plus](https://pub.dev/packages/network_info_plus) & [HTTP](https://pub.dev/packages/http) (Per l'analisi dell'interfaccia Wi-Fi e richieste di test)

---

## 💻 Come Avviare il Progetto

### Prerequisiti
Assicurati di avere Flutter installato sul tuo sistema (`flutter doctor` deve essere verde).

1. Clona la repository:
   ```bash
   git clone [https://github.com/TUO-USERNAME/NOME-REPO.git](https://github.com/TUO-USERNAME/NOME-REPO.git)
