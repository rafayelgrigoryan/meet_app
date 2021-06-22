import 'dart:async';
import 'package:flutter/material.dart';

import '../../services/room_service.dart';
import '../../services/profile_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/chatroom/users_list.dart';
import '../../widgets/timer.dart';
import '../call/call_screen.dart';
import '../contact/match_screen.dart';

class ChatRoomDetailScreen extends StatefulWidget {
  static const routeName = '/room';

  @override
  _ChatRoomDetailScreenState createState() => _ChatRoomDetailScreenState();
}

class _ChatRoomDetailScreenState extends State<ChatRoomDetailScreen> {
  final _roomService = RoomService();

  final _authService = AuthService();

  final _profileService = ProfileService();

  var _isFull = false;

  Timer _timer;
  int _start = 10;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    return StreamBuilder(
      stream: _roomService.roomsnapshot(id),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final document = snapshot.data.data();
        final me = _authService.getCurrentUser();
        if (document['joined'] == document['capacity']) {
          _isFull = true;
        }
        return FutureBuilder(
          future: _profileService.getUserInfo(me.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Scaffold(
              appBar: AppBar(
                title: Text(document['name']),
                actions: [
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                          "${document['joined'].toString()}/${document['capacity'].toString()}"),
                      IconButton(onPressed: () {}, icon: Icon(Icons.face)),
                    ],
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.favorite_border),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(MatchScreen.routeName, arguments: document);
                },
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UsersList(
                      document: document,
                      profileService: _profileService,
                      me: snapshot.data),
                  TextButton(
                    onPressed: () {},
                    child: _isFull
                        ? CountDownTimer(
                            secondsRemaining: _start,
                            whenTimeExpires: () {
                              Navigator.of(context)
                                  .pushNamed(CallScreen.routeName);
                            },
                          )
                        : Text("$_start"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
