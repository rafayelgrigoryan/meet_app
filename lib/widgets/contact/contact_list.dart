import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:meet_app/screens/chat/chat_screen.dart';
import 'package:meet_app/screens/contact/contact.dart';

class ContactList extends StatelessWidget {
  final Contact contact;
  final DocumentReference<Contact> reference;

  ContactList(this.contact, this.reference);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        color: Colors.grey.shade300,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(contact.photoUrl),
            radius: 80,
          ),
          title: Text(contact.name),
          subtitle: Text(contact.aboutMe),
          trailing: Icon(Icons.more_vert),
          isThreeLine: true,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(contact.uid)));
          },
        ));
  }
}
