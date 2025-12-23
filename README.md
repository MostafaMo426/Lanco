# Lanco 🌐
### Local Network Communication System

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=apple&logoColor=white)

**Lanco** is a mobile application designed to enable instant communication within a local network environment (Office, Campus, Home) without the need for an active internet connection. By leveraging **TCP Sockets**, Lanco transforms a device into a local server, allowing others to connect directly via IP address for secure, real-time messaging.

---

## 🚀 Key Features

* **100% Offline:** Works entirely on Local LAN (Wi-Fi) without internet or data usage.
* **Low Latency:** Uses raw **TCP Sockets** for millisecond-speed message delivery.
* **Dual Role System:** Any device can act as a **Host (Server)** or a **Joiner (Client)**.
* **Bilingual Support:** Ready for **English** and **Arabic (RTL)** text exchange.
* **Data Integrity:** Custom UTF-8 serialization layer to support multi-byte characters.
* **Live Status:** Real-time feedback on connection state (Waiting, Connected, Disconnected).

---

## 🛠️ Technical Architecture

Lanco implements a robust **Client-Server Architecture** over TCP/IP:

1.  **Host Mode (Server):** The device binds a `ServerSocket` to the local IP on port `4000` and listens for incoming streams.
2.  **Join Mode (Client):** The client device initiates a `Socket` handshake to the Host's IP address.
3.  **Payload Transfer:** Messages are serialized into `Uint8List` byte arrays and transmitted via the bi-directional socket stream.

---

## 📱 Screenshots

| Home (Host/Join) | Chat Interface |
|:---:|:---:|
| ![Home Screen](assets/screenshots/home.png) | ![Chat Screen](assets/screenshots/chat.png) |
*(Add your screenshots here)*

---

## 🔧 Installation & Setup

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/MostafaMo426/Lanco.git](https://github.com/your-username/lanco.git)
    ```
2.  **Install dependencies:**
    ```bash
    cd lanco
    flutter pub get
    ```
3.  **Run on Device:**
    * *Requirement:* Two devices must be on the **same Wi-Fi network**.
    ```bash
    flutter run
    ```

### Permissions
The app handles local network permissions automatically:
* `INTERNET` (Required for Socket usage)
* `ACCESS_NETWORK_STATE` (To fetch local IP)

---

## 🧩 Tech Stack

* **Framework:** Flutter (Dart)
* **Networking:** `dart:io` (ServerSocket & Socket)
* **State Management:** Provider
* **Utilities:** `network_info_plus` (IP Discovery)

---

### How to Test
1.  **Device A:** Tap **"Create Room"**. Note the IP address displayed (e.g., `192.168.1.5`).
2.  **Device B:** Enter the IP `192.168.1.5` in the text field and tap **"Join Room"**.
3.  The connection status should update to "Connected", and you can start messaging.

---

## 📂 Project Structure

```text
lib/
├── main.dart                 # Application entry point & Provider setup
├── models/
│   └── message_model.dart    # Data class for chat messages
├── screens/
│   ├── chat_screen.dart      # Chat UI & message list
│   └── home_screen.dart      # Role selection & IP input
└── services/
    └── socket_service.dart   # Core networking logic (Socket/ServerSocket)
```
---

## 🔮 Future Roadmap

This version serves as the **TCP Core MVP**. Future updates will transition to a full Ad-hoc model:
* [ ] Migrate to **Google Nearby Connections API** (P2P).
* [ ] Implement **Hybrid BLE/Wi-Fi Direct** for router-less discovery.
* [ ] Add **End-to-End Encryption** (AES).
* [ ] Enable File & Image Sharing.

---

## 👨‍💻 Contributors

* **[Mostafa Mohamed]** - *Initial Work & Development*

## 📄 License

This project is licensed under the MIT License.