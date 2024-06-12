class NotificationMessage {
  final int id;
  DateTime? date;
  final String subject;
  final String content;
  final bool isRead;

  NotificationMessage({
    this.id = 0,
    this.date,
    required this.subject,
    required this.content,
    this.isRead = false
  });

  factory NotificationMessage.fromSqflite(Map<String, dynamic> map) => NotificationMessage(
    id: map['id'],
    date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    subject: map['subject'],
    content: map['content'],
    isRead: map['isRead'] == 0 ? false : true
  );

  Map<String, dynamic> toSqflite() {
    return {
      'date': (date ?? DateTime.now()).millisecondsSinceEpoch,
      'subject': subject,
      'content': content,
      'isRead': isRead ? 1 : 0
    };
  }
}