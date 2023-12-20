
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:three_tapp_app/model/message.dart';

class ChatViewModel extends ChangeNotifier {
  //get instance of auth and firestore
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // SEND MESSAGES
    Future<void> sendMessage(String receiveruserId, String message) async {
      final String currentUserId = _firebaseAuth.currentUser!.uid;
      final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
      final Timestamp timestamp = Timestamp.now();

      //create new message
    Message newMessage = Message(
      senderId : currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiveruserId,
      timestamp: timestamp,
      message: message,
    );

    //construct chat room id from current user id and receiver id (sorted to ensure uniqueness)

    List<String> ids = [currentUserId, receiveruserId];
    ids.sort(); // sort ids to ensures chat room id is always the same
    String chatRoomId = ids.join("_"); //combine id into a sigle string 
    // add new message to database
    await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(newMessage.toMap());
    }

    // GET MESSAGES

    Stream <QuerySnapshot> getMessages(String userId, String otherUserId) {
      List<String> ids = [userId,otherUserId];

      ids.sort();
      String chatRoomId = ids.join("_");
      print(chatRoomId);
      return _firestore
            .collection('chat_rooms')
            .doc(chatRoomId)
            .collection('messages')
            .orderBy('timestamp',descending: false)
            .snapshots();
    }
}