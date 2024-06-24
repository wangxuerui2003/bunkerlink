class Message {
  final String text;
  final String senderId;

  Message({
    required this.text,
    required this.senderId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'],
      senderId: json['sender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'sender': senderId,
    };
  }
}
