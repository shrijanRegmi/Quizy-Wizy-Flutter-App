import 'package:flutter/material.dart';
import 'package:quizy_wizy/screens/widgets/normal_btn.dart';

class ShowDialogs {
  final BuildContext context;

  ShowDialogs(this.context);

  Future showProgressBar(final result) async {
    if (result) {
      return await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => Center(
                child: CircularProgressIndicator(),
              ));
    } else {
      return Navigator.pop(context);
    }
  }

  Future showRemoveQuestionDialog(final _title, final _question,
      final _positiveFunction, final _negativeFunction, var _value) async {
    var _checkVal = false;
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => StatefulBuilder(
            builder: (_, setState) => AlertDialog(
                  title: Text("$_title",
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      )),
                  content: Container(
                    height: 100.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_question, style: TextStyle(fontSize: 14.0)),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: _checkVal,
                              onChanged: (val) {
                                setState(() {
                                  _checkVal = val;
                                  _value(val);
                                });
                              },
                            ),
                            Expanded(
                                child: Text("Don't show this again",
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    IconButton(
                      onPressed: _positiveFunction,
                      icon: Icon(Icons.check_circle),
                    ),
                    IconButton(
                      onPressed: _negativeFunction,
                      icon: Icon(Icons.cancel),
                    ),
                  ],
                )));
  }

  Future showModesDescriptionDialog(
      final _mode, final _count, final _function) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return StatefulBuilder(builder: (_, setState) {
            return AlertDialog(
              title: Text(
                "Welcome to $_mode",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: Text(_getDescription(_mode, _count)),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: _function,
                )
              ],
            );
          });
        });
  }

  Future showResultDialog(
      final _mode, final _result, final _points, final _function, final _skippedFunction) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return StatefulBuilder(builder: (_, setState) {
            return AlertDialog(
              title: Text(
                _result == "Correct" ? "Congratulations !" : "I am sorry !",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: Text(
                _getResultDesciption(_mode, _result, _points),
              ),
              actions: <Widget>[
                _mode == "Exam"
                    ? GestureDetector(
                      onTap: _skippedFunction,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            color: Colors.white,
                            child: Text("Skipped Questions",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      )
                    : Container(),
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: _function,
                )
              ],
            );
          });
        });
  }

  Future showChooseDialog(
    final _nursingFunction,
    final _generalFunction,
  ) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return StatefulBuilder(builder: (_, setState) {
            return AlertDialog(
              title: Text(
                "Please select mode :",
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: NormalBtn("Quick", Colors.black, _nursingFunction),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: NormalBtn("General", Colors.black, _generalFunction),
                )
              ],
            );
          });
        });
  }

  Future showExamDialog(
    List<String> _dropdownList,
    var _value,
    final _function,
  ) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StatefulBuilder(builder: (_, setState) {
                return AlertDialog(
                  title: Text(
                    "Welcome to Exams",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  content: Column(
                    children: <Widget>[
                      Text("Please select number of questions"),
                      SizedBox(
                        height: 10.0,
                      ),
                      DropdownButton(
                        isExpanded: true,
                        value: _value,
                        items: _dropdownList.map((item) {
                          return DropdownMenuItem(
                              value: item, child: Text(item));
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _value = val;
                          });
                        },
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        _function(_value);
                      },
                    )
                  ],
                );
              }),
            ],
          );
        });
  }

  _getDescription<String>(final _mode, final _count) {
    switch (_mode) {
      case "Quick Play":
        return "You will be presented with $_count questions. Once you answer a question then you will get +1 points and when you complete 10 questions you will get +1 level. Good Luck !";
        break;
      case "General":
        return "This is the general mode. Here you will be presented with general questions and you have 1 minutes to answer each question. Good Luck !";
        break;
      case "Daily Hunt":
        return "Here you will be presented with $_count question. You only have 15 seconds to answer that question. This quiz mode will consume your 10 points, if you correctly answer the question then you will earn +50 points but if you fail to answer then you will not get any points and your 10 points will also be gone.\nContinue??";
        break;
      case "Exam":
        return "You will be presented with $_count questions. You have 1 minute to answer, once you answer a question then you will get +1 points and when you complete 10 questions you will get +1 level. Good Luck !";
        break;
      default:
        return "";
    }
  }

  _getResultDesciption<String>(
    final _mode,
    final _result,
    final _points,
  ) {
    switch (_mode) {
      case "Quick Play":
        return "Well done, you have reached so far. Your final point in this round is $_points.";
        break;
      case "General":
        return "Well done, you have reached so far. Your final point in this round is $_points";
        break;
      case "Daily Hunt":
        return _result == "Correct"
            ? "Well done, the answer is correct and you have earned $_points points."
            : "Bad luck, you have lost ${_points + 10} points. Better luck next time.";
        break;
      case "Exam":
        return "Well done, you have reached so far. Your final point in this round is $_points.";
        break;
      default:
        return "";
    }
  }
}
