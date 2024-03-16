import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:three_tapp_app/model/message.dart';

class ChatViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverUserId, String message, {String? imageUrl, String? videoUrl}) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverUserId,
      timestamp: timestamp,
      message: message,
      imageUrl: imageUrl,
      videoUrl: videoUrl,
    );

    List<String> ids = [currentUserId, receiverUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }



  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

Future<List<String>> getChatRoomIds() async {
  try {
    QuerySnapshot chatRoomsSnapshot = await _firestore.collection('/chat_rooms').get();
    if (chatRoomsSnapshot.docs.isEmpty) {
      print("No documents in chat_rooms");
      return [];
    }
    for (DocumentSnapshot doc in chatRoomsSnapshot.docs) {
      print("Document ID: ${doc.id}");
      print("Document Data: ${doc.data()}"); // In ra dữ liệu của tài liệu
    }
    List<String> chatRoomIds = chatRoomsSnapshot.docs.map((doc) => doc.id).toList();
    //print("chatroomIds: $chatRoomIds");
    return chatRoomIds;
  } catch (e) {
    print("Error getting chat room ids: $e");
    return [];
  }
}

}