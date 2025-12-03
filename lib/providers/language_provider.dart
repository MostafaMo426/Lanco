import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _appLocale = const Locale('ar'); // اللغة الافتراضية العربية

  Locale get appLocale => _appLocale;

  // قاموس الكلمات
  final Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      'app_title': 'شات الشبكة المحلية',
      'host_btn': 'إنشاء غرفة (Host)',
      'join_btn': 'انضمام لغرفة (Join)',
      'enter_ip': 'أدخل IP السيرفر',
      'host_title': 'أنت المستضيف',
      'client_title': 'أنت متصل',
      'waiting': 'في انتظار الاتصال...',
      'connected_to': 'تم الاتصال بـ:',
      'error': 'حدث خطأ',
      'disconnected': 'انقطع الاتصال',
      'type_msg': 'اكتب رسالة...',
      'change_lang': 'English',
      'my_ip': 'عنوان الـ IP الخاص بك هو:',
    },
    'en': {
      'app_title': 'LAN Chat',
      'host_btn': 'Create Room (Host)',
      'join_btn': 'Join Room',
      'enter_ip': 'Enter Server IP',
      'host_title': 'You are Host',
      'client_title': 'You are Client',
      'waiting': 'Waiting for connection...',
      'connected_to': 'Connected to:',
      'error': 'An error occurred',
      'disconnected': 'Disconnected',
      'type_msg': 'Type a message...',
      'change_lang': 'العربية',
      'my_ip': 'Your IP Address is:',
    },
  };

  String getText(String key) {
    return _localizedValues[_appLocale.languageCode]![key] ?? key;
  }

  void changeLanguage() {
    if (_appLocale.languageCode == 'ar') {
      _appLocale = const Locale('en');
    } else {
      _appLocale = const Locale('ar');
    }
    notifyListeners();
  }
}