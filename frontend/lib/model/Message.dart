class Message {
  int toId; // ID of the user who receive the message
  String content;
  int fromId; // ID of the user who sent the message
  DateTime timestamp; // Timestamp when the message was sent

  Message({
    required this.toId,
    required this.content,
    required this.fromId,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      toId: json['toId'],
      content: json['content'],
      fromId: json['fromId'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'toId': toId,
      'content': content,
      'fromId': fromId,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}