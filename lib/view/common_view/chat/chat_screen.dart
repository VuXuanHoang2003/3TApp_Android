import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:three_tapp_app/view/common_view/chat/chat_page.dart';
import 'package:three_tapp_app/viewmodel/post_viewmodel.dart';
import 'package:three_tapp_app/viewmodel/chat_viewmodel.dart'; // Import ChatViewModel

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatViewModel _chatViewModel = ChatViewModel(); // Khởi tạo ChatViewModel

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false, // Tắt nút back
        backgroundColor: Colors.blue, // Màu nền AppBar
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return FutureBuilder<List<String>>(
      future: _getChatRoomIds(), // Thay đổi đây để gọi hàm _getChatRoomIds()
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        List<String> chatRoomIds = snapshot.data ?? [];
        //print(chatRoomIds);
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('USERS').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            List<DocumentSnapshot> filteredUsers = _filterUsers(snapshot.data!.docs, chatRoomIds);

            return ListView(
              padding: EdgeInsets.all(16.0),
              children: filteredUsers
                  .map<Widget>((doc) => _buildUserListItem(doc))
                  .toList(),
            );
          },
        );
      },
    );
  }

  Future<List<String>> _getChatRoomIds() async {
    // Lấy danh sách các ID của các tài liệu
    List<String> chatRoomIds = await _chatViewModel.getChatRoomIds();    
    // Trả về danh sách các ID
    return chatRoomIds;
  }

  List<DocumentSnapshot> _filterUsers(List<DocumentSnapshot> users, List<String> chatRoomIds) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    // Lọc danh sách người dùng dựa trên điều kiện userId của người tham gia chat room không phải là userId hiện tại và userId nằm trong danh sách chatRoomIds
    List<DocumentSnapshot> filteredUsers = users.where((user) {
      String userId = user.id; // Sử dụng document.id thay vì truy cập vào userData
      return userId != currentUserId;
    }).toList();
    //print(filteredUsers);
    return filteredUsers;
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(data['avatarUrl'] ?? 'URL_MẶC_ĐỊNH'),
        ),
        title: Text(
          data['username'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiveruserEmail: data['email'],
                receiveruserID: document.id,
              ),
            ),
          );
        },
      ),
    );
  }
}
