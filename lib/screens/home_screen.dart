import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/socket_service.dart';
import '../providers/language_provider.dart';
import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _ipController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    final lang = Provider.of<LanguageProvider>(context);

    // تحميل الـ IP الخاص بالجهاز عند فتح الشاشة لعرضه للمستخدم
    if (socketService.ipAddress == null) {
      socketService.getIpAddress();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.getText('app_title')),
        actions: [
          TextButton(
            onPressed: () => lang.changeLanguage(),
            child: Text(
              lang.getText('change_lang'),
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // عرض IP الجهاز الحالي لمساعدة المستخدم
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue),
                ),
                child: Column(
                  children: [
                    Text(lang.getText('my_ip'), style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 5),
                    Text(
                      socketService.ipAddress ?? "...",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // زر Host
              ElevatedButton.icon(
                icon: const Icon(Icons.wifi_tethering),
                label: Text(lang.getText('host_btn')),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                onPressed: () async {
                  await socketService.startServer();
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChatScreen(isHost: true)),
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 30),

              // حقل Join
              TextField(
                controller: _ipController,
                decoration: InputDecoration(
                  labelText: lang.getText('enter_ip'),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.computer),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              // زر Join
              ElevatedButton.icon(
                icon: const Icon(Icons.link),
                label: Text(lang.getText('join_btn')),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                onPressed: () {
                  if (_ipController.text.isNotEmpty) {
                    socketService.connectToServer(_ipController.text.trim());
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChatScreen(isHost: false)),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}