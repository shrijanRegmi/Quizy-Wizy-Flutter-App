import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quizy_wizy/models/firebase_model/questions.dart';
import 'package:quizy_wizy/models/firebase_model/user.dart';
import 'package:quizy_wizy/services/auth/auth_provider.dart';
import 'package:quizy_wizy/services/database/database_provider.dart';
import 'package:quizy_wizy/wrapper.dart';

void main() {
  runApp(NursesExam());
}

class NursesExam extends StatefulWidget {
  @override
  _NursesExamState createState() => _NursesExamState();
}

class _NursesExamState extends State<NursesExam> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  // ca-app-pub-3940256099942544/6300978111 banner
  // ca-app-pub-3940256099942544/1033173712 interstitial

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<UserDetail>.value(
            value: AuthProvider().user,
          ),
          StreamProvider<List<Questions>>.value(
              value: DatabaseProvider().questions),
          StreamProvider<List<GeneralQuestions>>.value(
              value: DatabaseProvider().generalQuestion),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Quizy Wizy",
          theme: ThemeData(fontFamily: "Mont"),
          home: Material(
            child: Wrapper(),
          ),
        ));
  }
}
