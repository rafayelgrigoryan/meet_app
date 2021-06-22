import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './auth_service.dart';

class RoomService {
  User user = AuthService().getCurrentUser();
  final roomsCollection = FirebaseFirestore.instance.collection("rooms");

  Stream<QuerySnapshot<Map<String, dynamic>>> get streamobject {
    return roomsCollection.snapshots();
  }

  Future<void> joinRoom(String id, BuildContext context) async {
    var prevState = await roomsCollection.doc(id).get();
    var prevJoinedCount = prevState.data()['joined'];
    var capacity = prevState.data()['capacity'];
    var joinedUsers = prevState.data()['users'] as List;
    if (prevJoinedCount + 1 < capacity || !joinedUsers.contains(user.uid)) {
      await roomsCollection.doc(id).update({
        'users': [...joinedUsers, user.uid],
        'joined': prevJoinedCount + 1,
      });
    } else if (joinedUsers.contains(user.uid)) {
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("The room is full"),
        ),
      );
      // throw "You either have joined or room is full";
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getRoomParticipants(
      String id) async {
    var doc = await roomsCollection.doc(id).get();

    return doc.data()['users'];
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> roomsnapshot(String id) {
    var doc = roomsCollection.doc(id).snapshots();
    return doc;
  }
}
