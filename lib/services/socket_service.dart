import 'dart:io';
import 'dart:convert'; // مهم جداً للغة العربية
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';
import '../models/message_model.dart';

class SocketService extends ChangeNotifier {
  ServerSocket? _serverSocket;
  Socket? _socket;
  List<Message> _messages = [];
  String? _ipAddress;
  String _status = "";

  List<Message> get messages => _messages;
  String? get ipAddress => _ipAddress;
  String get status => _status;

  // الحصول على IP الجهاز
  Future<void> getIpAddress() async {
    final info = NetworkInfo();
    _ipAddress = await info.getWifiIP();
    notifyListeners();
  }

  // 1. تشغيل السيرفر (Host)
  Future<void> startServer() async {
    try {
      await getIpAddress();
      _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 4000);
      _status = "WAITING"; // حالة رمزية سنتعامل مع ترجمتها في الواجهة
      notifyListeners();

      _serverSocket!.listen((Socket clientSocket) {
        _socket = clientSocket;
        _status = "CONNECTED";
        notifyListeners();

        _socket!.listen(
              (Uint8List data) {
            // فك التشفير باستخدام UTF-8
            final messageText = utf8.decode(data);
            _addMessage(messageText, false);
          },
          onError: (error) {
            _status = "ERROR";
            notifyListeners();
          },
          onDone: () {
            _status = "DISCONNECTED";
            notifyListeners();
          },
        );
      });
    } catch (e) {
      _status = "ERROR";
      notifyListeners();
    }
  }

  // 2. الاتصال بالسيرفر (Client)
  Future<void> connectToServer(String ip) async {
    try {
      _status = "WAITING";
      notifyListeners();

      _socket = await Socket.connect(ip, 4000);
      _status = "CONNECTED";
      notifyListeners();

      _socket!.listen(
            (Uint8List data) {
          // فك التشفير باستخدام UTF-8
          final messageText = utf8.decode(data);
          _addMessage(messageText, false);
        },
        onError: (error) {
          _status = "ERROR";
          notifyListeners();
        },
        onDone: () {
          _status = "DISCONNECTED";
          notifyListeners();
        },
      );
    } catch (e) {
      _status = "ERROR";
      notifyListeners();
    }
  }

  // إرسال الرسالة
  void sendMessage(String text) {
    if (_socket != null && text.isNotEmpty) {
      // التشفير باستخدام UTF-8 قبل الإرسال
      _socket!.add(utf8.encode(text));
      _addMessage(text, true);
    }
  }

  void _addMessage(String text, bool isMe) {
    _messages.add(Message(text: text, isMe: isMe));
    notifyListeners();
  }

  void disconnect() {
    _socket?.destroy();
    _serverSocket?.close();
    _messages.clear();
    _status = "";
    notifyListeners();
  }
}