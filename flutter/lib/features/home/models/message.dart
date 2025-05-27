class Message {
  final String text;
  final bool isUser;
  final String dateTime;
  Message(this.text, this.isUser, this.dateTime);

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(json['text'], json['isUser'], json['time']);
  }
}
