import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final String? imageUrl;
  final String? videoUrl;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    this.imageUrl,
    this.videoUrl,
    required this.timestamp,
  });

  // convert to a Map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'timestamp': timestamp,
    };
  }
}