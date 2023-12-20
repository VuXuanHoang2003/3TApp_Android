// import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:three_tapp_app/view/common_view/chat/chat_page.dart';

import '../../../viewmodel/post_viewmodel.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> {
  PostViewModel postViewModel = PostViewModel();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
Widget build(BuildContext context) {
  // TODO: implement build
  return Scaffold(
    appBar: AppBar(
      title: const Text("Chat"),
      automaticallyImplyLeading: false, // Tắt nút back
    ),
    body: _buildUserList(),
  );
}

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(      
      stream: FirebaseFirestore.instance.collection('USERS').snapshots(), 
      builder: (context,snapshot) { 
          if (snapshot.hasError) {  
            return const Text('error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text ('loading ...');
          }
          // print(snapshot.data!.docs.length);
          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        },
       );
  }

  // build individual list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map <String,dynamic> data = document.data()! as Map <String,dynamic>;

  // display all user except current user
    if (_auth.currentUser!.email != data['email']) {
      print("doc id" + document.id);
      return ListTile(
        title : Text(data['email']),
        onTap: () {
          // pass the clicked user's ID to the chat page
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
      );  
    } else {
      
      //return empty container
        return Container();
    }
  }
}