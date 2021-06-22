import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meet_app/screens/contact/contact.dart';
import 'package:meet_app/screens/profile/profile.dart';
import 'package:meet_app/services/auth_service.dart';

class ContactService {
  final User user = AuthService().getCurrentUser();
  final userContactCollection = FirebaseFirestore.instance
      .collection('contact')
      .doc(AuthService().getCurrentUser().uid)
      .collection('contacts');
  final contactCollection = FirebaseFirestore.instance.collection('contact');
  final matchCollection = FirebaseFirestore.instance.collection("likes");

  get users => userContactCollection.withConverter<Contact>(
        fromFirestore: (snapshot, _) => Contact.fromJson(snapshot.data()),
        toFirestore: (user, _) => user.toJson(),
      );
  Future<void> addContact(Contact contact, Profile profile) async {
    var likeeId = contact.uid;
    var matches = await checkLike(likeeId);
    if (!matches) {
      return;
    }
    var myContact = Contact(
      uid: user.uid,
      name: profile.name,
      gender: profile.gender,
      photoUrl: profile.image,
      aboutMe: profile.aboutMe,
      dateOfBirth: profile.dateOfBirth,
    );
    var contactInList = await checkContact(contact.uid, myContact.uid);
    if (!contactInList) {
      await userContactCollection
          .withConverter<Contact>(
            fromFirestore: (snapshot, _) => Contact.fromJson(snapshot.data()),
            toFirestore: (user, _) => user.toJson(),
          )
          .add(contact);
    }
    var contacteeInList = await checkContact(myContact.uid, contact.uid);
    if (!contacteeInList) {
      await contactCollection
          .doc(likeeId)
          .collection("contacts")
          .withConverter<Contact>(
            fromFirestore: (snapshot, _) => Contact.fromJson(snapshot.data()),
            toFirestore: (user, _) => user.toJson(),
          )
          .add(myContact);
    }
  }

  Future<void> setLikes(String uid, bool likes) async {
    await matchCollection.doc(user.uid).collection('likes').add({
      'likes': likes,
      'user': uid,
    });
  }

  Future<bool> checkLike(String uid) async {
    print(uid);
    var likeList = await matchCollection
        .doc(user.uid)
        .collection('likes')
        .where('user', isEqualTo: uid)
        .get();
    if (likeList.docs.isNotEmpty) {
      var listOfLikees = likeList.docs.map((val) {
        return val.data()['user'];
      }).toList();
      print(listOfLikees);
      return listOfLikees.contains(uid);
    }
    return false;
  }

  Future<bool> checkContact(String uid, String checkFor) async {
    var contactList = await contactCollection
        .doc(checkFor)
        .collection("contacts")
        .withConverter<Contact>(
          fromFirestore: (snapshot, _) => Contact.fromJson(snapshot.data()),
          toFirestore: (user, _) => user.toJson(),
        )
        .get();
    return contactList.docs.map((e) => e.data().uid).contains(uid);
  }
}
