import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:three_tapp_app/view/common_view/chat/chat_buble.dart';
import 'package:three_tapp_app/viewmodel/chat_viewmodel.dart';

class ChatPage extends StatefulWidget {
  final String receiveruserEmail;
  final String receiveruserID;

  const ChatPage({
    Key? key,
    required this.receiveruserEmail,
    required this.receiveruserID,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatViewModel _chatService = ChatViewModel();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ImagePicker _imagePicker = ImagePicker();
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.network('');

  File? _selectedImage;
  File? _selectedVideo;

  @override
  void initState() {
    super.initState();
    _videoPlayerController.addListener(() {
      if (!_videoPlayerController.value.isInitialized) {
        return;
      }
      if (_videoPlayerController.value.hasError) {
        print(
            'Video player error: ${_videoPlayerController.value.errorDescription}');
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _selectImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _selectVideo() async {
    final pickedFile =
        await _imagePicker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedVideo = File(pickedFile.path);
        _videoPlayerController
          ..dispose()
          ..initialize().then((_) {
            setState(() {});
          });
      });
    }
  }

  void _clearSelectedImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _clearSelectedVideo() {
    setState(() {
      _selectedVideo = null;
    });
  }

  Future<String?> _uploadFile(File file, String folderName) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('$folderName/$fileName');
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  void sendMessage() async {
    // Only send when there is something to send
    if (_messageController.text.isNotEmpty ||
        _selectedImage != null ||
        _selectedVideo != null) {
      String? imageUrl;
      String? videoUrl;

      // Upload image if selected
      if (_selectedImage != null) {
        imageUrl = await _uploadFile(_selectedImage!, 'chat_images');
      }

      // Upload video if selected
      if (_selectedVideo != null) {
        videoUrl = await _uploadFile(_selectedVideo!, 'chat_videos');
      }

      await _chatService.sendMessage(
        widget.receiveruserID,
        _messageController.text,
        imageUrl: imageUrl,
        videoUrl: videoUrl,
      );

      // Clear the text controller and selected files after sending the message
      _messageController.clear();
      setState(() {
        _selectedImage = null;
        _selectedVideo = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiveruserEmail),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: _buildMessageList(),
          ),

          // User input
          _buildMessageInput(),
        ],
      ),
    );
  }

  // Build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.receiveruserID,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading ... ');
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // Build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    // Align the message to the right if the sender is the current user, otherwise align to the left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          mainAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            if (data['imageUrl'] != null)
              Image.network(
                data['imageUrl'],
                width: 200,
              ),
            if (data['videoUrl'] != null)
              AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
              ),
            ChatBubble(message: data['message']),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Nhập tin nhắn',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  ),
                  obscureText: false,
                ),
              ),
              const SizedBox(width: 8.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Material(
                  color: Colors.blue,
                  child: InkWell(
                    onTap: sendMessage,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.send,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              IconButton(
                onPressed: _selectImage,
                icon: Icon(Icons.image),
              ),
              if (_selectedImage != null)
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: IconButton(
                    onPressed: _clearSelectedImage,
                    icon: Icon(Icons.close),
                  ),
                ),
              IconButton(
                onPressed: _selectVideo,
                icon: Icon(Icons.video_library),
              ),
              if (_selectedVideo != null)
                Container(
                  width: 50,
                  height: 50,
                  child: Stack(
                    children: [
                      VideoPlayer(_videoPlayerController),
                      Align(
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: _clearSelectedVideo,
                          icon: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
