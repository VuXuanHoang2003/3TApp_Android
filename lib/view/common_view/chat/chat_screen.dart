import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:three_tapp_app/view/common_view/chat/chat_page.dart';
import 'package:three_tapp_app/viewmodel/chat_viewmodel.dart'; // Import ChatViewModel

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatViewModel _chatViewModel = ChatViewModel();

  void reloadChatScreen() {
    setState(() {});
  }

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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: UserSearch(
                  FirebaseFirestore.instance.collection('USERS').snapshots(),
                  reloadChatScreen: reloadChatScreen,
                ),
              );
            },
          ),
        ],
      ),
      body: _buildUserList(),
    );
  }


  Widget _buildUserList() {
    return FutureBuilder<List<String>>(
      future: _getChatRoomIds(),
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

            List<DocumentSnapshot> filteredUsers =
                _filterUsers(chatRoomIds, snapshot.data!);

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
    List<String> chatRoomIds = await _chatViewModel.getChatRoomIds();
    return chatRoomIds;
  }

  List<DocumentSnapshot> _filterUsers(
      List<String> chatRoomIds, QuerySnapshot snapshot) {
    String currentUserId = _auth.currentUser!.uid;
    List<DocumentSnapshot> filteredUsers = [];
    for (String chatRoomId in chatRoomIds) {
      List<String> userIds = chatRoomId.split('_');
      if (userIds.contains(currentUserId)) {
        userIds.remove(currentUserId);
        for (String userId in userIds) {
          DocumentSnapshot userDoc =
              snapshot.docs.firstWhere((doc) => doc.id == userId);
          filteredUsers.add(userDoc);
        }
      }
    }
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
                reloadChatScreen: reloadChatScreen,
              ),
            ),
          );
        },
      ),
    );
  }
}

class UserSearch extends SearchDelegate<DocumentSnapshot> {
  final Stream<QuerySnapshot> userStream;
  final Function reloadChatScreen;
  UserSearch(this.userStream, {required this.reloadChatScreen});

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        reloadChatScreen();
        Navigator.pop(context);
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildUserList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildUserList(context);
  }

  Widget _buildUserList(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: userStream,
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }
      final results = snapshot.data!.docs.where(
        (DocumentSnapshot doc) {
          return doc['username']
              .toLowerCase()
              .contains(query.toLowerCase());
        },
      );
      return ListView(
        children: results
            .map<Widget>((doc) => _buildUserListItem(context, doc, reloadChatScreen)) // Truyền vào reloadChatScreen ở đây
            .toList(),
      );
    },
  );
}


Widget _buildUserListItem(BuildContext context, DocumentSnapshot document, Function reloadChatScreen) { // Thêm biến reloadChatScreen
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
              reloadChatScreen: reloadChatScreen,
            ),
          ),
        );
      },
    ),
  );
}

}
