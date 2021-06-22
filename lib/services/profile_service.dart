import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './auth_service.dart';
import '../screens/profile/profile.dart';

class ProfileService {
  User user = AuthService().getCurrentUser();
  FirebaseStorage storage = FirebaseStorage.instance;
  final usersCollection = FirebaseFirestore.instance.collection("users");

  Stream<QuerySnapshot<Map<String, dynamic>>> get streamobject {
    return usersCollection.snapshots();
  }

  Future<bool> checkUserInfo() async {
    var userData = await usersCollection.doc(user.uid).get();
    if (userData.data() == null) {
      return true;
    }
    return false;
  }

  Future<Profile> getUserInfo([String id]) async {
    var userId = id != null ? id : user.uid;
    var userData = await usersCollection.doc(userId).get();
    if (userData.data() == null) {
      return null;
    }
    var userProfile = Profile(
        name: userData.data()['name'],
        relationType: userData.data()['relationType'],
        gender: userData.data()['gender'],
        aboutMe: userData.data()['aboutMe'],
        dateOfBirth: userData.data()['dateOfBirth'],
        image: userData.data()['image'],
        music: userData.data()['music'],
        favorites: userData.data()['favorites'],
        hobbie: userData.data()['hobbie'],
        uid: user.uid,
        interested: userData.data()['interested'],
        address: userData.data()['address']);
    return userProfile;
  }

  Future<void> addUserInfo(
    File image,
    String name,
    Timestamp dateOfBirth,
    String address,
    String hobbie,
    String favorites,
    String music,
    String gender,
    String relation,
    String aboutMe,
    String interested,
  ) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('user-pictures')
        .child('${user.uid}-${name}.jpg');

    UploadTask upTask = ref.putFile(image);

    final imgUrl = await (await upTask).ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
      {
        'name': name,
        'dateOfBirth': dateOfBirth,
        'address': address,
        'hobbie': hobbie,
        'favorites': favorites,
        'music': music,
        'gender': gender,
        'relationType': relation,
        'aboutMe': aboutMe,
        'interested': interested,
        'uid': user.uid,
        'image': imgUrl,
        'age': ((Timestamp.now()
                    .toDate()
                    .difference(dateOfBirth.toDate())
                    .inDays) /
                365)
            .floor(),
      },
    );
  }

  Future<void> updateUserInfo(
    String name,
    Timestamp dateOfBirth,
    String address,
    String hobbie,
    String favorites,
    String music,
    String gender,
    String relation,
    String aboutMe,
    String interested,
  ) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
      {
        'name': name,
        'dateOfBirth': dateOfBirth,
        'address': address,
        'hobbie': hobbie,
        'favorites': favorites,
        'music': music,
        'gender': gender,
        'relationType': relation,
        'aboutMe': aboutMe,
        'interested': interested,
        'uid': user.uid,
        'age': ((Timestamp.now()
                    .toDate()
                    .difference(dateOfBirth.toDate())
                    .inDays) /
                365)
            .floor(),
      },
    );
  }
}
