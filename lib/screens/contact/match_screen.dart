import 'package:flutter/material.dart';

import '../../services/room_service.dart';
import '../../services/profile_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/chatroom/users_list.dart';

class MatchScreen extends StatefulWidget {
  static const routeName = '/match';

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  final _roomService = RoomService();

  final _authService = AuthService();

  final _profileService = ProfileService();

  @override
  Widget build(BuildContext context) {
    final document =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final me = _authService.getCurrentUser();
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
            title: Text("${document['name']}-Matching"),
            actions: [
              // Row(
              //   // crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     Text(
              //         "${document['joined'].toString()}/${document['capacity'].toString()}"),
              //     IconButton(onPressed: () {}, icon: Icon(Icons.face)),
              //   ],
              // ),
            ],
          ),
          // floatingActionButton: FloatingActionButton(
          //   child: Icon(Icons.favorite_border),
          //   onPressed: () {},
          // ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UsersList(
                  document: document,
                  profileService: _profileService,
                  me: snapshot.data,
                  likePage: true),
            ],
          ),
        );
      },
    );
  }
}
