class Message {
  final String text;
  final bool isMe; // لتحديد ما إذا كانت الرسالة مني أو من الطرف الآخر

  Message({required this.text, required this.isMe});
}