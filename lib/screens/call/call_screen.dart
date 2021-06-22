import 'package:flutter/material.dart';

import './video_call.dart';

class CallScreen extends StatelessWidget {
  static const routeName = '/call';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("On Call"),
      ),
      body: JoinChannelVideo(),
    );
  }
}
