import 'package:flutter/cupertino.dart';
import 'package:social_app/models/chat/message_model.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatProvider extends ChangeNotifier {
  Future<String> sendMessage({
    required String receiverId,
    required int dateTime,
    required String text,
  }) async {
    MessageModel model = MessageModel(
      text: text,
      senderId: uid,
      receiverId: receiverId,
      dateTime: dateTime,
    );
    try {
      // set my chats

      await FirebaseFirestore.instance.collection('users').doc(uid).collection('chats').doc(receiverId).collection('messages').add(model.toMap());

      // set receiver chats

      await FirebaseFirestore.instance.collection('users').doc(receiverId).collection('chats').doc(uid).collection('messages').add(model.toMap());

      return 'success';
    } catch (e, s) {
      print(e.toString());
      print(s.toString());
      return 'error';
    }
  }

  List<MessageModel> messages = [];

  void getMessages({
    required String receiverId,
  }) {
    print('ids: $uid \n$receiverId');
    FirebaseFirestore.instance.collection('users').doc(uid).collection('chats').doc(receiverId).collection('messages').orderBy('date_time').snapshots().listen(
      (event) {
        messages = [];
        print(event.docs);
        event.docs.forEach((element) => messages.add(MessageModel.fromMap(element.data())));
        notifyListeners();
      },
    );
  }
}
