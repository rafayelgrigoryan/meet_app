import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './screens/auth_screen.dart';
import './screens/tabs_screen.dart';
import './screens/profile/profile_screen.dart';
import './screens/chatroom/chatroom_detail_screen.dart';
import './screens/call/call_screen.dart';
import './screens/call/video_call.dart';
import './screens/contact/match_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, appSnapshot) {
        return MaterialApp(
          title: 'Flutter Chat',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.pink,
              backgroundColor: Colors.red[300],
              accentColor: Colors.purpleAccent,
              accentColorBrightness: Brightness.dark,
              buttonTheme: ButtonTheme.of(context).copyWith(
                buttonColor: Colors.purple,
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              )),
          home: appSnapshot.connectionState != ConnectionState.done
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (ctx, userSnapshot) {
                    if (userSnapshot.hasData) {
                      return TabsScreen();
                    }
                    return AuthScreen();
                  },
                ),
          routes: {
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
            ChatRoomDetailScreen.routeName: (ctx) => ChatRoomDetailScreen(),
            CallScreen.routeName: (ctx) => CallScreen(),
            JoinChannelVideo.routeName: (ctx) => JoinChannelVideo(),
            MatchScreen.routeName: (ctx) => MatchScreen(),
          },
        );
      },
    );
  }
}
