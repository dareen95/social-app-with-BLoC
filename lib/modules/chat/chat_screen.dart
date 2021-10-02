import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/main.dart';
import 'package:social_app/models/auth/social_user_model.dart';
import 'package:social_app/models/chat/message_model.dart';
import 'package:social_app/modules/chat/chat_provider.dart';
import 'package:social_app/shared/components/constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final messageKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      chatProvider.getMessages(receiverId: (ModalRoute.of(context)!.settings.arguments as SocialUserModel).uid ?? '');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final receiver = ModalRoute.of(context)!.settings.arguments as SocialUserModel;
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) => Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(receiver.image ?? ''),
              ),
              SizedBox(width: 15),
              Text(receiver.name ?? '', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: List.generate(
                    chatProvider.messages.length,
                    (index) => chatProvider.messages[index].senderId == uid
                        ? Column(children: [buildMyMessage(chatProvider.messages[index]), SizedBox(height: 16.0)])
                        : Column(children: [buildReceiverMessage(chatProvider.messages[index]), SizedBox(height: 16.0)]),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.cyan[100]?.withOpacity(0.3), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Form(
                          key: messageKey,
                          child: TextFormField(
                            controller: messageController,
                            decoration: InputDecoration(border: InputBorder.none, hintText: 'Write a message..'),
                            maxLines: 3,
                            minLines: 1,
                            style: TextStyle(fontSize: 16),
                            validator: (value) {
                              if (value?.isEmpty ?? false) {
                                return 'message must not be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.blue),
                        onPressed: () {
                          if (messageKey.currentState?.validate() ?? true)
                            chatProvider.sendMessage(
                              receiverId: receiver.uid ?? '',
                              dateTime: DateTime.now().millisecondsSinceEpoch,
                              text: messageController.text.trim(),
                            );
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Align buildMyMessage(MessageModel message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0)), color: Colors.cyanAccent[200]?.withAlpha(50)),
        child: Text(message.text, style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Align buildReceiverMessage(MessageModel message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8.0)), color: Colors.grey[200]),
        child: Text(message.text, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
