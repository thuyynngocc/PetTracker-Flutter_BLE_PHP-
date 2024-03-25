import 'package:flutter/material.dart';

class AdminChatPage extends StatefulWidget {
  @override
  _AdminChatPageState createState() => _AdminChatPageState();
}

class _AdminChatPageState extends State<AdminChatPage> {
  TextEditingController messageController = TextEditingController();
  List<Message> messages = [
    Message(isAdmin: false, text: 'Xin chào!'),
    Message(isAdmin: true, text: 'Chào bạn!'),
    Message(isAdmin: false, text: 'Tôi có một câu hỏi về đặt lịch.'),
    Message(isAdmin: true, text: 'Tất nhiên, bạn có thể hỏi gì?'),
    // Thêm tin nhắn khác tùy theo nhu cầu
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Chat'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return MessageWidget(message: message);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Điều chỉnh khoảng cách dọc
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(hintText: 'Nhập tin nhắn',),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  // Lấy nội dung tin nhắn từ người dùng
                  final messageText = messageController.text;
                  if (messageText.isNotEmpty) {
                    setState(() {
                      messages.add(Message(isAdmin: false, text: messageText));
                    });
                    // Xóa nội dung đã nhập từ TextField
                    messageController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Message {
  final bool isAdmin;
  final String text;

  Message({required this.isAdmin, required this.text});
}

class MessageWidget extends StatelessWidget {
  final Message message;

  MessageWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isAdmin ? Alignment.topLeft : Alignment.topRight,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(vertical: 4.0), // Điều chỉnh khoảng cách dọc giữa các tin nhắn
        decoration: BoxDecoration(
          color: message.isAdmin ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
