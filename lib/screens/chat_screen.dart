import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/socket_service.dart';
import '../providers/language_provider.dart';

class ChatScreen extends StatefulWidget {
  final bool isHost;
  const ChatScreen({super.key, required this.isHost});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();

  @override
  void dispose() {
    Provider.of<SocketService>(context, listen: false).disconnect();
    super.dispose();
  }

  // دالة مساعدة لترجمة الحالة القادمة من السيرفر
  String _getStatusText(String status, LanguageProvider lang) {
    if (status == "WAITING") return lang.getText('waiting');
    if (status == "CONNECTED") return lang.getText('connected_to');
    if (status == "ERROR") return lang.getText('error');
    if (status == "DISCONNECTED") return lang.getText('disconnected');
    return status;
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isHost ? lang.getText('host_title') : lang.getText('client_title')),
      ),
      body: Consumer<SocketService>(
        builder: (context, socketService, child) {
          return Column(
            children: [
              // شريط الحالة
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                color: socketService.status == "CONNECTED" ? Colors.green[100] : Colors.amber[100],
                child: Text(
                  _getStatusText(socketService.status, lang) +
                      (socketService.status == "WAITING" && widget.isHost ? " ${socketService.ipAddress}" : ""),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // قائمة الرسائل
              Expanded(
                child: ListView.builder(
                  itemCount: socketService.messages.length,
                  itemBuilder: (context, index) {
                    final msg = socketService.messages[index];
                    return Align(
                      // محاذاة الرسائل: دائماً رسائلي يمين والطرف الآخر يسار (مثل الواتساب)
                      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: msg.isMe ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(15),
                            topRight: const Radius.circular(15),
                            bottomLeft: msg.isMe ? const Radius.circular(15) : const Radius.circular(0),
                            bottomRight: msg.isMe ? const Radius.circular(0) : const Radius.circular(15),
                          ),
                        ),
                        child: Text(
                          msg.text,
                          style: TextStyle(
                            color: msg.isMe ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // منطقة الكتابة
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        decoration: InputDecoration(
                          hintText: lang.getText('type_msg'),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () {
                          socketService.sendMessage(_msgController.text);
                          _msgController.clear();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}