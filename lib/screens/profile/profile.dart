import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  final String name;
  final Timestamp dateOfBirth;
  final String relationType;
  final String address;
  final String image;
  final String uid;
  final String music;
  final String favorites;
  final String hobbie;
  final String aboutMe;
  final String interested;
  final String gender;

  Profile({
    this.name,
    this.dateOfBirth,
    this.relationType,
    this.image,
    this.uid,
    this.address,
    this.music,
    this.favorites,
    this.hobbie,
    this.aboutMe,
    this.interested,
    this.gender,
  });
}
