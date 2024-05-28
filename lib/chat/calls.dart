import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class AgoraCalls extends StatefulWidget {
  String channelName;
  DateTime endTime;
  AgoraCalls({super.key, required this.channelName, required this.endTime});

  @override
  State<AgoraCalls> createState() => _AgoraCallsState();
}

class _AgoraCallsState extends State<AgoraCalls> {
  static const appId = "989f207f2a12441a9c71a5db1ee4eeac";
  static const token = "";
  static String channel = "Test_Channel";
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: "989f207f2a12441a9c71a5db1ee4eeac",
      channelName: channel,
      username: "user",
    ),
  );
  void initState() {
    super.initState();

    // initAgora();
    channel = widget.channelName;
    // initAgora();
    if (channel != "" || channel != null) {
      initAgora();
    } else {
      Navigator.pop(context);
    }
  }

  void initAgora() async {
    await client.initialize();
  }

  @override
  void dispose() {
    super.dispose();

    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Text(
              "Will End ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            TimerCountdown(
              spacerWidth: 5,
              enableDescriptions: false,
              timeTextStyle:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              minutesDescription: "",
              secondsDescription: "",
              format: CountDownTimerFormat.minutesSeconds,
              endTime: widget.endTime,
              onEnd: () {
                print("Timer finished");
                _dispose();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          AgoraVideoViewer(
            client: client,
            layoutType: Layout.floating,
            enableHostControls: true, // Add this to enable host controls
          ),
          AgoraVideoButtons(
            client: client,
            addScreenSharing: false, // Add this to enable screen sharing
          ),
          // Center(
          //   child: _remoteVideo(),
          // ),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: SizedBox(
          //     width: 100,
          //     height: 150,
          //     child: Center(
          //       child: _localUserJoined
          //           ? AgoraVideoView(
          //               controller: VideoViewController(
          //                 rtcEngine: _engine,
          //                 canvas: const VideoCanvas(uid: 0),
          //               ),
          //             )
          //           : const CircularProgressIndicator(),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
