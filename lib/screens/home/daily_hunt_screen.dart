import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizy_wizy/models/firebase_model/questions.dart';
import 'package:quizy_wizy/models/firebase_model/stats.dart';
import 'package:quizy_wizy/models/firebase_model/user.dart';
import 'package:quizy_wizy/models/functions/show_dialogs.dart';
import 'package:quizy_wizy/screens/widgets/normal_btn.dart';
import 'package:quizy_wizy/services/database/database_provider.dart';

class DailyHuntScreen extends StatelessWidget {
  final _mode;
  DailyHuntScreen(this._mode);
  @override
  Widget build(BuildContext context) {
    final _userDetail = Provider.of<UserDetail>(context);
    return StreamProvider<UserStat>.value(
      value: DatabaseProvider(uid: _userDetail.uid).userStat,
      child: DailyHuntScreenTemp(_mode),
    );
  }
}

class DailyHuntScreenTemp extends StatefulWidget {
  final _mode;
  DailyHuntScreenTemp(this._mode);
  @override
  _DailyHuntScreenTempState createState() => _DailyHuntScreenTempState();
}

class _DailyHuntScreenTempState extends State<DailyHuntScreenTemp> {
  @override
  void initState() {
    super.initState();
    _initStateFunction();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _didChangeDependenciesFunction();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  List<String> _option = ["A", "B", "C", "D"];
  List<Color> _optionColor =
      List<Color>.generate(4, (_color) => Color(0xfff3f3f3));
  List<Color> _optionBg = List<Color>.generate(4, (_color) => Colors.white);
  List<String> _answers;
  List<Questions> _dailyHuntQuestions = [];
  int _count = 15;
  bool _isNextBtnPressed = false;
  bool _gameStarted = false;
  bool _gameCompleted = false;
  bool _empty = false;
  String _myAns = "";
  int _myAnsIndex = 0;
  Timer _timer;
  int _points = 0;

 

  _initStateFunction() {
   
    Timer(Duration(milliseconds: 10), () {
      ShowDialogs(context).showModesDescriptionDialog(widget._mode, 1, () {
        Navigator.pop(context);
      });
    });
  }

  _didChangeDependenciesFunction() {
    final _questions = Provider.of<List<Questions>>(context);
    setState(() {
      _dailyHuntQuestions = _questions;
    });
  }

  _getFontSizeQuestion(var length) {
    if (length < 20) {
      return 24.0;
    } else if (length > 20 && length < 25) {
      return 22.0;
    } else if (length > 25 && length < 30) {
      return 20.0;
    } else if (length > 30 && length < 35) {
      return 18.0;
    } else if (length > 35 && length < 40) {
      return 16.0;
    } else if (length > 40 && length < 50) {
      return 16.0;
    } else {
      return 14.0;
    }
  }

  _getFontSizeAnswer(var length) {
    if (length < 20) {
      return 16.0;
    } else if (length > 20 && length < 25) {
      return 14.0;
    } else if (length > 25 && length < 30) {
      return 12.0;
    } else {
      return 10.0;
    }
  }

  _showTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        if (_count <= 0) {
          timer.cancel();
          _gameCompleted = true;
          ShowDialogs(context).showResultDialog(widget._mode, "Wrong", _points,
              () {
            Navigator.pop(context);
            Navigator.pop(context);
          }, null);
        } else {
          _count = _count - 1;
        }
      });
    });
  }

  _onPressedStartBtn(UserDetail _userDetails, UserStat _userStat) {
    setState(() {
      if (_dailyHuntQuestions.length != 0) {
        _dailyHuntQuestions.shuffle();
        _empty = false;
        _answers = [
          _dailyHuntQuestions[0].optionA,
          _dailyHuntQuestions[0].optionB,
          _dailyHuntQuestions[0].optionC,
          _dailyHuntQuestions[0].optionD
        ];
        _showTimer();
        DatabaseProvider(uid: _userDetails.uid).updateUserStats(
            _userStat.level, _userStat.points - 10, _userStat.rank);
      } else {
        _empty = true;
      }
      _gameStarted = true;
    });
  }

  _onPressedDoneBtn(UserDetail _userDetails, UserStat _userStat) async {
    _timer.cancel();
  
    setState(() {
      _isNextBtnPressed = true;
      if (_myAns != _dailyHuntQuestions[0].correctAns) {
        _optionBg[_myAnsIndex] = Colors.red;
        _gameCompleted = true;
        Timer(Duration(seconds: 1), () {
          ShowDialogs(context).showResultDialog(widget._mode, "Wrong", _points,
              () {
            Navigator.pop(context);
            Navigator.pop(context);
          }, null);
        });
      } else {
        _points = 60;
        _gameCompleted = true;
        Timer(Duration(seconds: 1), () {
          ShowDialogs(context)
              .showResultDialog(widget._mode, "Correct", _points - 10, () {
            Navigator.pop(context);
            Navigator.pop(context);
          }, null);
        });
        DatabaseProvider(uid: _userDetails.uid).updateUserStats(
            _userStat.level, _userStat.points + _points, _userStat.rank);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _userDetails = Provider.of<UserDetail>(context);
    final _userStat = Provider.of<UserStat>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          color: Color(0xfff0dedd),
          child: Column(
            children: <Widget>[
              _topSection(),
              Expanded(
                child: !_gameStarted
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: NormalBtn("Start", Color(0xff452826), () {
                                _onPressedStartBtn(_userDetails, _userStat);
                              }),
                            ),
                          ),
                        ],
                      )
                    : _empty
                        ? Center(
                            child: Text("Nothing to show !"),
                          )
                        : ListView(
                            children: <Widget>[
                              SizedBox(
                                height: 20.0,
                              ),
                              _bodySection(),
                              _answerList(),
                              SizedBox(
                                height: 10.0,
                              ),
                              _gameCompleted
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: NormalBtn(
                                          "Done", Color(0xff452826), () {
                                        _onPressedDoneBtn(
                                            _userDetails, _userStat);
                                      }),
                                    ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _topSection() {
    return Container(
      height: 120.0,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
                color: Color(0xff707070).withOpacity(0.5),
                offset: Offset(0, 3),
                blurRadius: 10.0),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50.0),
                          bottomRight: Radius.circular(50.0))),
                  color: Colors.deepOrange,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  label: Text("")),
              Expanded(
                flex: 2,
                child: Text("${widget._mode}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 24.0,
                        color: Colors.deepOrange)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    color: Colors.black,
                    child: Center(
                      child: Text("$_count",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              )
            ],
          ),
          _numbersList(),
        ],
      ),
    );
  }

  Widget _numbersList() {
    return Container(
      height: 50.0,
      width: 50.0,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            return Center(child: _numbersListItem(index + 1));
          },
          itemCount: _dailyHuntQuestions.length != 0 ? 1 : 0),
    );
  }

  Widget _numbersListItem(int _num) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ClipOval(
          child: Container(
            width: 20.0,
            height: 20.0,
            color: _num == 0 + 1 ? Colors.greenAccent : Colors.white,
            child: Center(
              child: Text(
                "$_num",
                style: TextStyle(
                    color: _num == 0 + 1
                        ? Colors.white
                        : Colors.black.withOpacity(0.5),
                    fontSize: _dailyHuntQuestions.length != 0 &&
                            _dailyHuntQuestions[0].question.length == 20
                        ? 20.0
                        : 12.0,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bodySection() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Text(
              _dailyHuntQuestions[0].question.contains("?")
                  ? _dailyHuntQuestions[0].question
                  : "${_dailyHuntQuestions[0].question}?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: _getFontSizeQuestion(
                      _dailyHuntQuestions[0].question.length),
                  color: Color(0xff452826))),
        ],
      ),
    );
  }

  Widget _answerList() {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          return _answerListItem(
              index,
              _isNextBtnPressed &&
                      _answers[index] == _dailyHuntQuestions[0].correctAns
                  ? Colors.green
                  : _optionBg[index]);
        },
        itemCount: 4,
      ),
    );
  }

  Widget _answerListItem(int index, Color bg) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _myAns = _answers[index];
          _myAnsIndex = index;
          for (int i = 0; i < _optionColor.length; i++) {
            if (i != index) {
              _optionColor[i] = Color(0xfff3f3f3);
            }
          }

          if (_optionColor[index] == Color(0xff452826)) {
            _optionColor[index] = Color(0xfff3f3f3);
          } else {
            _optionColor[index] = Color(0xff452826);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff707070).withOpacity(0.5),
                  offset: Offset(3, 3),
                  blurRadius: 10.0,
                )
              ]),
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 80.0,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: _optionColor[index],
                ),
                child: Center(
                  child: Text(_option[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22.0,
                          color: _optionColor[index] == Color(0xff452826)
                              ? Colors.white
                              : Color(0xff452826),
                          fontWeight: FontWeight.w600)),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Text(_answers[index],
                    style: TextStyle(
                        fontSize: _getFontSizeAnswer(_answers[index].length),
                        color: bg == Colors.green || bg == Colors.red
                            ? Colors.white
                            : Color(0xff452826))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// 452826
