import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet_app/screens/profile/profile.dart';

import './auth_service.dart';
import '../screens/call/call.dart';

class CallService {
  final callCollection = FirebaseFirestore.instance.collection("calls");

  Stream<DocumentSnapshot> callStream({String uid}) =>
      callCollection.doc(uid).snapshots();

  Future<bool> makeCall({Call call}) async {
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callCollection.doc(call.callerId).set(hasDialledMap);
      await callCollection.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({Call call}) async {
    try {
      await callCollection.doc(call.callerId).delete();
      await callCollection.doc(call.receiverId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static dial({Profile from, Profile to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      receiverId: to.uid,
      receiverName: to.name,
      channelId: Random().nextInt(1000).toString(),
    );

    bool callMade = await CallService().makeCall(call: call);

    call.hasDialled = true;

    // if (callMade) {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => CallScreen(call: call),
    //       ));
    // }
  }
}
