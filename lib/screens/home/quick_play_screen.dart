import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizy_wizy/models/firebase_model/questions.dart';
import 'package:quizy_wizy/models/firebase_model/stats.dart';
import 'package:quizy_wizy/models/firebase_model/user.dart';
import 'package:quizy_wizy/models/functions/show_dialogs.dart';
import 'package:quizy_wizy/screens/widgets/normal_btn.dart';
import 'package:quizy_wizy/services/database/database_provider.dart';

class QuizScreen extends StatelessWidget {
  final _mode;
  QuizScreen(this._mode);
  @override
  Widget build(BuildContext context) {
    final _userDetail = Provider.of<UserDetail>(context);
    return StreamProvider<UserStat>.value(
      value: DatabaseProvider(uid: _userDetail.uid).userStat,
      child: QuizScreenTemp(_mode),
    );
  }
}

class QuizScreenTemp extends StatefulWidget {
  final _mode;
  QuizScreenTemp(this._mode);
  @override
  _QuizScreenTempState createState() => _QuizScreenTempState();
}

class _QuizScreenTempState extends State<QuizScreenTemp> {
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
    _timer != null ? _timer.cancel() : print("Bye Bye");
    super.dispose();
  }


  ScrollController _c;
  List<String> _option = ["A", "B", "C", "D"];
  List<Color> _optionColor =
      List<Color>.generate(4, (_color) => Color(0xfff3f3f3));
  List<Color> _optionBg = List<Color>.generate(4, (_color) => Colors.white);
  List<String> _answers;
  List<Questions> _quickQuestions = [];
  int _i = 0;
  int _count = 60;
  bool _isNextBtnPressed = false;
  bool _gameStarted = false;
  bool _gameCompleted = false;
  bool _empty = false;
  String _myAns = "";
  int _myAnsIndex = 0;
  Timer _timer;
  String _btnText = "Skip";
  int _points = 0;

  _initStateFunction() {
    _c = ScrollController();

    Timer(Duration(milliseconds: 10), () {
      ShowDialogs(context).showModesDescriptionDialog(widget._mode, 10, () {
        Navigator.pop(context);
      });
    });
  }

  _didChangeDependenciesFunction() {
    final _questions = Provider.of<List<Questions>>(context);
    if (_questions != null && _questions.length != 0) {
      setState(() {
        _quickQuestions = _questions;
      });
    }
  }

  _whenAnsIsSubmitted(List<Questions> _quickQuestions) {
    Timer(Duration(seconds: 1), () {
      if (_i <
          (_quickQuestions.length <= 10 ? _quickQuestions.length - 1 : 9)) {
        setState(() {
          _c.animateTo(40.0 * _i,
              duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        });
        setState(() {
          _btnText = "Skip";
          _i++;
          _answers = [
            _quickQuestions[_i].optionA.trim(),
            _quickQuestions[_i].optionB.trim(),
            _quickQuestions[_i].optionC.trim(),
            _quickQuestions[_i].optionD.trim(),
          ];
          _isNextBtnPressed = false;
          for (int i = 0; i < _optionBg.length; i++) {
            _optionColor[i] = Color(0xfff3f3f3);
            _optionBg[i] = Colors.white;
          }
          _count = 60;
          _showTimer(_quickQuestions);
        });
      }
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

  _showTimer(List<Questions> _quickQuestions) {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        if (_count <= 0) {
          timer.cancel();
          _whenAnsIsSubmitted(_quickQuestions);
        } else {
          _count = _count - 1;
        }
      });
    });
  }

  _onPressedStartBtn() {
    setState(() {
      if (_quickQuestions.length != 0) {
        _quickQuestions.shuffle();
        _empty = false;
        _answers = [
          _quickQuestions[_i].optionA.trim(),
          _quickQuestions[_i].optionB.trim(),
          _quickQuestions[_i].optionC.trim(),
          _quickQuestions[_i].optionD.trim(),
        ];
        _showTimer(_quickQuestions);
      } else {
        _empty = true;
      }
      _gameStarted = true;
    });
  }

  _onPressedNextBtn(UserDetail _userDetails, UserStat _userStat) async {
    _timer.cancel();
    setState(() {
      _isNextBtnPressed = true;
      if (_myAns != _quickQuestions[_i].correctAns.trim()) {
        if (_btnText != "Skip") {
          _optionBg[_myAnsIndex] = Colors.red;
        }
      } else {
        _points++;
        DatabaseProvider(uid: _userDetails.uid).updateUserStats(
            _userStat.level, _userStat.points + 1, _userStat.rank);
        if (_points == 10) {
          DatabaseProvider(uid: _userDetails.uid).updateUserStats(
              _userStat.level + 1, _userStat.points, _userStat.rank);
        }
      }
      if (_i ==
          (_quickQuestions.length <= 10 ? _quickQuestions.length - 1 : 9)) {
        _gameCompleted = true;
        Timer(Duration(seconds: 1), () {
          ShowDialogs(context)
              .showResultDialog(widget._mode, "Correct", _points, () {
            Navigator.pop(context);
            Navigator.pop(context);
          }, null);
        });
      }
    });
    if (_i == (_quickQuestions.length <= 10 ? _quickQuestions.length - 1 : 9)) {
     
    }
    _whenAnsIsSubmitted(_quickQuestions);
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
                                _onPressedStartBtn();
                              }),
                            ),
                          ),
                        ],
                      )
                    : _empty
                        ? Center(
                            child: Text("Nothing to show"),
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
                                          _btnText, Color(0xff452826), () {
                                        _onPressedNextBtn(
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
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          controller: _c,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            return _numbersListItem(index + 1);
          },
          itemCount: _quickQuestions.length <= 10 ? _quickQuestions.length : 10,
        ));
  }

  Widget _numbersListItem(int _num) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ClipOval(
          child: Container(
            width: 20.0,
            height: 20.0,
            color: _num == _i + 1 ? Colors.greenAccent : Colors.white,
            child: Center(
              child: Text(
                "$_num",
                style: TextStyle(
                    color: _num == _i + 1
                        ? Colors.white
                        : Colors.black.withOpacity(0.5),
                    fontSize: _quickQuestions.length != 0 &&
                            _quickQuestions[_i].question.length == 20
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
              _quickQuestions[_i].question.contains("?")
                  ? _quickQuestions[_i].question
                  : "${_quickQuestions[_i].question}?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize:
                      _getFontSizeQuestion(_quickQuestions[_i].question.length),
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
                      _answers[index] == _quickQuestions[_i].correctAns
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
          _btnText = "Next";
          for (int i = 0; i < _optionColor.length; i++) {
            if (i != index) {
              _optionColor[i] = Color(0xfff3f3f3);
            }
          }

          if (_optionColor[index] == Color(0xff452826)) {
            _optionColor[index] = Color(0xfff3f3f3);
            _btnText = "Skip";
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
