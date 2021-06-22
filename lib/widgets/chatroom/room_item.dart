import 'package:flutter/material.dart';

import '../../services/room_service.dart';
import '../../screens/chatroom/chatroom_detail_screen.dart';

class ChatRoomItem extends StatelessWidget {
  final _roomService = RoomService();

  final String id;
  final String name;
  final int capacity;
  final int joined;
  final String description;

  ChatRoomItem({
    this.id,
    this.name,
    this.description,
    this.capacity,
    this.joined,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.house),
      ),
      title: Text(name),
      subtitle: Text(description),
      trailing: Container(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${joined.toString()}/${capacity.toString()}"),
            TextButton(
              child: Text('Join now'),
              onPressed: () {
                try {
                  _roomService.joinRoom(id, context);
                  Navigator.of(context)
                      .pushNamed(ChatRoomDetailScreen.routeName, arguments: id);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
