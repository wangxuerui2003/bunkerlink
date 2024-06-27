class Message {
  final String text;
  final String userId;
  final Map<String, dynamic>? userData;

  Message({
    required this.text,
    required this.userId,
    this.userData,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'],
      userId: json['userId'],
      userData: json['expand']['userId'],
    );
  }

  Map<String, dynamic> toJson({bool expand = false}) {
    if (expand) {
      return {
        'text': text,
        'userId': userId,
        'userData': userData,
      };
    }
    return {
      'text': text,
      'userId': userId,
    };
  }
}
