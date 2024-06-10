import 'dart:convert';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:starsmeetupuser/chat/audio_Calls.dart';
// import 'package:starsmeetupuser/chat/audio_call_test.dart';
import 'package:starsmeetupuser/chat/calls.dart';
import 'package:http/http.dart' as http;
import '../../Utilities/app_colors.dart';
import '../../Utilities/app_text_styles.dart';
import '../Apis/chat_service.dart';
import '../models/appointment_model.dart';
import '../models/message_model.dart';

class ChatPage extends StatefulWidget {
  final AppointmentModel? appointment;
  final String meetingId;

  const ChatPage({Key? key, required this.meetingId, this.appointment})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  late final ChatService _chatService;
  late final FirebaseAuth _auth;


  String _userName = '';
  late AppointmentModel _appointment;
  var _isStarMessageAvailable;
  @override
  void initState() {
    super.initState();
    print(widget.meetingId);
    _chatService = ChatService(widget.meetingId);
    _checkStarMessages();
    _auth = FirebaseAuth.instance;
  }

  void _checkStarMessages() {
    _chatService.getStarMessages().listen((messages) {
      setState(() {
        _isStarMessageAvailable = messages.isNotEmpty;
        print("s$_isStarMessageAvailable ");
      });
    });
  }
  Future<void> sendNotification() async {
    // Ensure widget.appointment is not null
    if (widget.appointment == null) {
      print('Appointment is null');
      return;
    }

    // Get the celebrity ID
    final String celebrityId = widget.appointment!.celebrityId!;

    // Reference to the Firestore document
    DocumentReference docRef = FirebaseFirestore.instance.collection('celebrities').doc(celebrityId);

    try {
      // Fetch the document snapshot
      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Get the fcmtoken field
        String? fcmtoken = docSnapshot['fcmtoken'] as String?;

        if (fcmtoken != null) {
          var data = {
            'to': fcmtoken,
            'notification': {
              'title': 'Video Call Start',
              'body': 'Subscribe to my channel',
              'sound': 'jetsons_doorbell.mp3',
            },
            'android': {
              'notification': {
                'notification_count': 23,
              },
            },
            'data': {
              'type': 'msj',
              'id': 'Asif Taj',
            },
          };

          await http.post(
            Uri.parse('https://fcm.googleapis.com/fcm/send'),
            body: jsonEncode(data),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'key=YOUR_SERVER_KEY_HERE', // Replace with your actual server key
            },
          ).then((response) {
            if (kDebugMode) {
              print(response.body.toString());
            }
          }).onError((error, stackTrace) {
            if (kDebugMode) {
              print(error);
            }
          });
        } else {
          print('fcmtoken is null');
        }
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: whiteColor,
        backgroundColor: purpleColor,
        title: Text(
          widget.appointment!.celebrityName!,
          style: eighteen700TextStyle(color: whiteColor),
        ),
        actions: [
          (widget.appointment!.serviceName == "Audio Meeting")
              ? IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: () {
                    // Implement audio call action
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AudioCalls()));
                  },
                )
              : SizedBox.shrink(),
          (widget.appointment!.serviceName == "Video Meeting")
              ? IconButton(
                  icon: Icon(Icons.videocam),
                  onPressed: () async{
                    final cameras = await availableCameras();

                    // Get a specific camera from the list of available cameras.
                    final firstCamera = cameras.firstWhere((camera) => camera.lensDirection==CameraLensDirection.front);
                    log("time solt id: ${widget.appointment!.timeSlotId!}");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AgoraCalls(
                                  Name: widget.appointment!.celebrityName!,
                                  channelName: widget.appointment!.timeSlotId!,
                                  endTime:
                                      DateTime.now().add(Duration(minutes: 20)),
                                )));
                    log("this is channel id:${DateTime.now().add(Duration(minutes: 3))}");

                    // if (DateTime.now().isAfter(widget.appointment!.startTime!
                    //         .subtract(Duration(minutes: 1))) &&
                    //     widget.appointment!.endTime!.isAfter(DateTime.now())) {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => AgoraCalls(
                    //                 Name: widget.appointment!.celebrityName!,
                    //                 channelName:
                    //                     widget.appointment!.timeSlotId!,
                    //                 endTime: widget.appointment!.endTime!,
                    //               )));
                    // } else {
                    //   final snackBar = SnackBar(
                    //     content:
                    //         Text('You are unable to start before Start time'),
                    //     duration: Duration(seconds: 3), // Optional duration
                    //     // action: SnackBarAction(
                    //     //   label: 'Close',
                    //     //   onPressed: () {
                    //     //     // Some action to take when the user presses the action button
                    //     //   },
                    //     // ),
                    //   );

                    //   // Show the Snackbar using the ScaffoldMessenger
                    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    // }
                  },
                )
              : SizedBox.shrink(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _chatService.getAllMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    print(messages.length);
                    return _buildMessageWidget(message);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _isStarMessageAvailable == true ? _sendMessage() : null;
                    if (_isStarMessageAvailable == false) {
                      Fluttertoast.showToast(msg: "you can not start the chat");
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageWidget(Message message) {
    final bool isCurrentUser = message.senderUid == _auth.currentUser!.email;
    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          alignment:
              isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: isCurrentUser ? purpleColor : Colors.grey[300],
            ),
            child: Text(
              message.content,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: isCurrentUser ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            '${message.timestamp.hour}:${message.timestamp.minute}',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _chatService.sendMessage(widget.appointment!.userName!, message, true,
          _auth.currentUser!.email!);
      _messageController.clear();
    }
  }
}
