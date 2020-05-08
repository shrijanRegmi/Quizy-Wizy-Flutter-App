import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quizy_wizy/models/firebase_model/stats.dart';
import 'package:quizy_wizy/models/firebase_model/user.dart';
import 'package:quizy_wizy/screens/home/daily_hunt_screen.dart';
import 'package:quizy_wizy/screens/home/exams_screen.dart';
import 'package:quizy_wizy/screens/home/general_question_screen.dart';
import 'package:quizy_wizy/screens/home/quick_play_screen.dart';
import 'package:quizy_wizy/screens/widgets/drawer.dart';
import 'package:quizy_wizy/screens/widgets/quiz_modes_item.dart';
import 'package:quizy_wizy/services/auth/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _rank = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _user = Provider.of<UserDetail>(context, listen: false);
    final _usersList = Provider.of<List<UserDetail>>(context, listen: false);
    if (_usersList != null && _user != null) {
      for (int i = 0; i < _usersList.length; i++) {
        if (_usersList[i].uid == _user.uid) {
          setState(() {
            _rank = i + 1;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserDetail>(context);
    final _userStat = Provider.of<UserStat>(context);
    final _usersList = Provider.of<List<UserDetail>>(context) ?? [];
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.deepPurple,
      endDrawer: MyDrawer(_user != null ? _user.userName : "",
          _user != null ? _user.userEmail : "", _usersList),
      body: SafeArea(
        child: _user == null && _userStat == null
            ? Center(child: CircularProgressIndicator())
            : Container(
                color: Colors.blue,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        left: 0.0,
                        right: 0.0,
                        bottom: -30.0,
                        child: SvgPicture.asset("images/home_page_bottom.svg")),
                    
                    Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: ListView(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 2 -
                                          50.0,
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(30.0),
                                      bottomRight: Radius.circular(30.0),
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      _userStats(context),
                                    ],
                                  ),
                                ),
                                _quizModes(context),
                                SizedBox(
                                  height: 60.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                   
                  ],
                ),
              ),
      ),
    );
  }

  Widget _userStats(BuildContext context) {
    final _user = Provider.of<UserDetail>(context);
    final _userStat = Provider.of<UserStat>(context);
    return Expanded(
      child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 100),
                    child: Text(_user.userName,
                        style: TextStyle(fontSize: 45.0, color: Colors.white)),
                  ),
                  Spacer(),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Level",
                                style: TextStyle(
                                    color: Colors.yellow, fontSize: 10.0),
                              ),
                              Text(
                                _userStat != null ? "${_userStat.level}" : "0",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 32.0),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Points",
                                style: TextStyle(
                                    color: Colors.yellow, fontSize: 10.0),
                              ),
                              Text(
                                _userStat != null ? "${_userStat.points}" : "0",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 32.0),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "Rank",
                                style: TextStyle(
                                    color: Colors.yellow, fontSize: 10.0),
                              ),
                              Text(
                                _rank != 0 ? "$_rank" : "-",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 32.0),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                right: 0.0,
                child: IconButton(
                  icon: Icon(
                    Icons.menu,
                  ),
                  color: Colors.white,
                  iconSize: 30.0,
                  onPressed: () {
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                ),
              )
            ],
          )),
    );
  }

  Widget _quizModes(BuildContext context) {
    final _userStats = Provider.of<UserStat>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        children: <Widget>[
          QuizModesItem("Quick Play", "Go", "images/quick_play.svg", () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizScreen("Quick Play"),
                ));
          }),
          QuizModesItem("General", "Power", "images/events.svg", () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GeneralQuestionScreen("General"),
                ));
          }),
          QuizModesItem("Daily Hunt", "Lets hunt", "images/daily_hunt.svg", () {
            if (_userStats.points >= 10) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DailyHuntScreen("Daily Hunt"),
                  ));
            } else {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(
                    "You need minimum of 10 points to play this quiz mode !"),
              ));
            }
          }),
          QuizModesItem("Exam", "Education", "images/quick_play.svg", () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExamScreen("Exam"),
                ));
          }),
        ],
      ),
    );
  }
}
