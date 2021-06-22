import 'package:flutter/material.dart';

import '../../screens/profile/profile.dart';
import '../../services/profile_service.dart';
import '../../screens/call/call_screen.dart';
import '../../services/contact_service.dart';
import '../../screens/contact/contact.dart';

class UsersList extends StatefulWidget {
  const UsersList({
    Key key,
    @required this.document,
    @required ProfileService profileService,
    @required this.me,
    this.likePage = false,
  })  : _profileService = profileService,
        super(key: key);

  final document;
  final ProfileService _profileService;
  final Profile me;
  final bool likePage;

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  List<Profile> _profile;
  var _isLoading = true;
  final _contactService = ContactService();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.document['users'].length,
      itemBuilder: (ctx, i) {
        return FutureBuilder(
          future:
              widget._profileService.getUserInfo(widget.document['users'][i]),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            var profile = snapshot.data;

            return (widget.likePage &&
                    widget.document['users'][i] == widget.me.uid)
                ? Container()
                : Column(
                    children: [
                      ListTile(
                        title: widget.document['users'][i] == widget.me.uid
                            ? Text("Me")
                            : Text(profile.name),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(profile.image),
                          radius: 40,
                        ),
                        trailing: widget.document['users'][i] !=
                                    widget.me.uid &&
                                (profile.gender != widget.me.gender)
                            ? IconButton(
                                onPressed: !widget.likePage
                                    ? () {
                                        Navigator.of(context)
                                            .pushNamed(CallScreen.routeName);
                                      }
                                    : () {
                                        print(profile.toString());
                                        _contactService.setLikes(
                                          widget.document['users'][i],
                                          true,
                                        );
                                        _contactService.addContact(
                                          Contact(
                                            uid: widget.document['users'][i],
                                            name: profile.name,
                                            gender: profile.gender,
                                            photoUrl: profile.image,
                                            aboutMe: profile.aboutMe,
                                            dateOfBirth: profile.dateOfBirth,
                                          ),
                                          widget.me,
                                        );
                                        // Navigator.of(context).pop();
                                      },
                                icon: !widget.likePage
                                    ? Icon(Icons.video_call)
                                    : Icon(Icons.favorite_border),
                              )
                            : null,
                      ),
                      Divider(),
                    ],
                  );
          },
        );
      },
    );
  }
}
