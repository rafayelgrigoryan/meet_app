import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meet_app/screens/profile/profile.dart';
import 'package:meet_app/services/auth_service.dart';

class ChatService{

 User user = AuthService().getCurrentUser();
  final usersCollection = FirebaseFirestore.instance.collection("users");
  
   Future<Profile> getUserInfo() async {
    var userData = await usersCollection.doc(user.uid).get();
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
}