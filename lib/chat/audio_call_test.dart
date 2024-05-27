import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';

class AudioCallPage extends StatefulWidget {
  @override
  _AudioCallPageState createState() => _AudioCallPageState();
}

class _AudioCallPageState extends State<AudioCallPage> {
  final AgoraClient _client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: 'YOUR_AGORA_APP_ID', // Replace with your Agora App ID
      channelName: 'testChannel', // Replace with your channel name
    ),
    enabledPermission: [
      Permission.microphone,
    ],
  );

  bool _isInChannel = false;

  @override
  void initState() {
    super.initState();
    _initializeAgora();
  }

  Future<void> _initializeAgora() async {
    try {
      await _client.initialize();
      print('Agora client initialized');
      setState(() {
        _isInChannel = false;
      });
    } catch (e) {
      print('Failed to initialize Agora: $e');
    }
  }

  Future<void> _toggleChannel() async {
    try {
      if (_isInChannel) {
        // await _client.sessionController.leave();
        print('Left the channel');
        setState(() {
          _isInChannel = false;
        });
      } else {
        // await _client.sessionController.join();
        print('Joined the channel');
        setState(() {
          _isInChannel = true;
        });
      }
    } catch (e) {
      print('Error toggling channel: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agora Audio Call'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isInChannel)
              Text('You are in the channel')
            else
              Text('You are not in the channel'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleChannel,
              child: Text(_isInChannel ? 'Leave Channel' : 'Join Channel'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _client.sessionController.dispose();
    super.dispose();
  }
}
