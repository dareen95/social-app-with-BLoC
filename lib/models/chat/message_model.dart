class MessageModel {
  late String text;
  late String senderId;
  late String receiverId;
  late int dateTime;

  MessageModel.fromMap(Map<String, dynamic> map) {
    text = map['text'] ?? '';
    senderId = map['sender_id'] ?? '';
    receiverId = map['receiver_id'] ?? '';
    dateTime = map['date_time'] ?? -1;
  }

  Map<String, dynamic> toMap() {
    return {'text': text, 'sender_id': senderId, 'receiver_id': receiverId, 'date_time': dateTime};
  }

  MessageModel({
    required this.text,
    required this.senderId,
    required this.receiverId,
    required this.dateTime,
  });
}
