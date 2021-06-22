import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_app/screens/contact/contact.dart';
import 'package:meet_app/services/contact_service.dart';
import 'package:meet_app/widgets/contact/contact_list.dart';

class ContactScreen extends StatefulWidget {
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  ContactService contactService = new ContactService();
  Stream<QuerySnapshot<Contact>> _contactStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _contactStream =
        contactService.users.snapshots(includeMetadataChanges: true);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: StreamBuilder<QuerySnapshot<Contact>>(
        stream: _contactStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final data = snapshot.requireData;
            print(snapshot.data.docs.length);
            if (data.size > 0) {
              return ListView.builder(
                  itemCount: data.size,
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) {
                    return ContactList(
                        data.docs[index].data(), data.docs[index].reference);
                  });
            } else {
              return Center(
                  child: Text(
                'No Contact List',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ));
            }
          }
        },
      ),
    ));
  }
}
