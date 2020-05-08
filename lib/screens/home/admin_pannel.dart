import 'package:flutter/material.dart';
import 'package:quizy_wizy/models/functions/show_dialogs.dart';
import 'package:quizy_wizy/screens/home/add_question_screen.dart';
import 'package:quizy_wizy/screens/home/remove_question_screen.dart';
import 'package:quizy_wizy/screens/widgets/normal_btn.dart';

class AdminPannel extends StatefulWidget {
  @override
  _AdminPannelState createState() => _AdminPannelState();
}

class _AdminPannelState extends State<AdminPannel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Pannel"),
        backgroundColor: Colors.black.withOpacity(0.8),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: NormalBtn("Add Question", Colors.black, () {
                    ShowDialogs(context).showChooseDialog(() {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AddQuestionScreen("Quick")));
                    }, () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AddQuestionScreen("General")));
                    });
                  }),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: NormalBtn("Remove Question", Colors.black, () {
                    ShowDialogs(context).showChooseDialog(() {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => RemoveQuestionScreen("Nursing")));
                    }, () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => RemoveQuestionScreen("General")));
                    });
                  }),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
         
        ],
      ),
    );
  }
}
