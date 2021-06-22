import 'package:flutter/material.dart';

import '../../services/room_service.dart';
import '../../services/profile_service.dart';
import '../../widgets/chatroom/room_item.dart';

class ChatRoomScreen extends StatelessWidget {
  final _roomService = RoomService();
  @override
  Widget build(BuildContext context) {
    final _profileService = ProfileService();
    return FutureBuilder(
        future: _profileService.checkUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          return snapshot.data
              ? Center(
                  child: Text("Complete profile first"),
                )
              : StreamBuilder(
                  stream: _roomService.streamobject,
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final documents = snapshot.data.docs;
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (ctx, i) => Column(
                        children: [
                          ChatRoomItem(
                            id: documents[i].id,
                            name: documents[i].data()['name'],
                            description: documents[i].data()['description'],
                            capacity: documents[i].data()['capacity'],
                            joined: documents[i].data()['joined'],
                          ),
                          Divider(),
                        ],
                      ),
                    );
                  },
                );
        });
  }
}
