// import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:three_tapp_app/view/common_view/chat/chat_buble.dart';
import 'package:three_tapp_app/viewmodel/chat_viewmodel.dart';
class ChatPage extends StatefulWidget {
  final String receiveruserEmail;
  final String receiveruserID;
  const ChatPage({
    super.key, 
    required this.receiveruserEmail, 
    required this.receiveruserID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatViewModel _chatService = ChatViewModel();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void sendMessage() async {
    // only send when have smth to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiveruserID, _messageController.text); //
      
      //clear the text controller after sendding the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: Text(widget.receiveruserEmail),
      ),
      body: Column(
        children: [
          //messages
          Expanded(
            child: _buildMessageList(),
            ),

            //user input
            _buildMessageInput(),
        ]),
    );
  }


  // build message List
  Widget _buildMessageList() {
    return StreamBuilder(stream: _chatService.getMessages(
      widget.receiveruserID, _firebaseAuth.currentUser!.uid), 
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Eror');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading ... ');
        }

        return ListView (
          children: snapshot.data!.docs.
          map((document) => _buildMessageItem(document)).toList(),
        ); 
      },
    );
  }
  // build message Item

  Widget _buildMessageItem (DocumentSnapshot document) {
    Map <String, dynamic> data = document.data() as Map <String, dynamic>;
    // align the message to the right if the sender is the current user, otherwise the is the left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid) ? 
        Alignment.centerRight
        : Alignment.centerLeft;
    print(alignment);
    return Container(
      alignment: alignment,
      child : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
        crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid) 
            ? CrossAxisAlignment.end 
            : CrossAxisAlignment.start,
        mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid) 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        children: [
          Text(data['senderEmail']),
          ChatBubble(message: data['message']),
        ],
      ),
      )
    );
  }

Widget _buildMessageInput() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    color: Colors.white, // Đặt màu nền hoặc dùng Theme.of(context).scaffoldBackgroundColor 
    child: Row(
      children: [
        // Textfield with styling
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: 'Nhập tin nhắn',
              filled: true, // Nhập background cho textfield
              fillColor: Colors.grey[200], // Chọn màu nền
              border: OutlineInputBorder( 
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide.none, // Ẩn border đi
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            ),
            obscureText: false,
          ),
        ),
        const SizedBox(width: 8.0), // Khoảng cách giữa textfield và nút
        // Send button with design
        ClipRRect(
          borderRadius: BorderRadius.circular(25), // Góc bo tròn của nút
          child: Material(
            color: Colors.blue, // Màu sắc nút gửi, có thể lấy từ theme
            child: InkWell(
              onTap: sendMessage, // Toàn bộ khu vực sẽ là nút nhấn
              child: const Padding(
                padding: EdgeInsets.all(8.0), // Padding cho biểu tượng bên trong
                child: Icon(
                  Icons.send,
                  size: 32, // Đặt kích cỡ icon gửi
                  color: Colors.white, // Màu icon
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

}