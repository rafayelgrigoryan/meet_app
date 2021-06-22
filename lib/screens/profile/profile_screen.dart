import 'package:flutter/material.dart';

import '../../widgets/profile/profile_form.dart';
import '../../services/profile_service.dart';
import './profile.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profiles';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileService = ProfileService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your profile"),
      ),
      body: FutureBuilder(
        future: _profileService.checkUserInfo(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );

          return ProfileForm(snapshot.data);
        },
      ),
    );
  }
}
