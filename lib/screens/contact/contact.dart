import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String name;
  final Timestamp dateOfBirth;
  final String photoUrl;
  final String uid;
  final String aboutMe;
  final String gender;

  Contact({
    this.name,
    this.dateOfBirth,
    this.photoUrl,
    this.uid,
    this.aboutMe,
    this.gender,
  });
  Contact.fromJson(Map<String, dynamic> json)
      : this(
          name: json['name'],
          dateOfBirth: json['dateOfBirth'],
          photoUrl: json['photoUrl'],
          uid: json['uid'],
          aboutMe: json['aboutMe'],
          gender: json['gender'],
        );
  Map<String, Object> toJson() {
    return {
      'name': name,
      'dateOfBirth': dateOfBirth,
      'uid': uid,
      'gender': gender,
      'aboutMe': aboutMe,
      'photoUrl': photoUrl,
    };
  }
}
