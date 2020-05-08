import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizy_wizy/models/firebase_model/stats.dart';
import 'package:quizy_wizy/models/firebase_model/user.dart';
import 'package:quizy_wizy/screens/authentication/auth_screen.dart';
import 'package:quizy_wizy/screens/home/home_screen.dart';
import 'package:quizy_wizy/services/database/database_provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userDetail = Provider.of<UserDetail>(context);

    if (_userDetail != null) {
      return MultiProvider(providers: [
        StreamProvider<UserDetail>.value(
          value: DatabaseProvider(uid: _userDetail.uid).userDetail,
        ),
        StreamProvider<UserStat>.value(
          value: DatabaseProvider(uid: _userDetail.uid).userStat,
        ),
        StreamProvider<List<UserDetail>>.value(
          value: DatabaseProvider().usersList,
        )
      ], child: HomeScreen());
    } else {
      return AuthScreen();
    }
  }
}
