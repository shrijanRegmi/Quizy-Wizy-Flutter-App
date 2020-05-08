import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizy_wizy/models/firebase_model/questions.dart';
import 'package:quizy_wizy/models/functions/show_dialogs.dart';
import 'package:quizy_wizy/services/database/database_provider.dart';

class RemoveQuestionScreen extends StatefulWidget {
  final String _mode;
  RemoveQuestionScreen(this._mode);
  @override
  _RemoveQuestionScreenState createState() => _RemoveQuestionScreenState();
}

class _RemoveQuestionScreenState extends State<RemoveQuestionScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _checkVal = false;

  @override
  Widget build(BuildContext context) {
    final _questions = Provider.of<List<Questions>>(context);
    final _generalQuestions = Provider.of<List<GeneralQuestions>>(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Remove ${widget._mode} Question"),
          backgroundColor: Colors.black.withOpacity(0.8),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: widget._mode == "Nursing"
                      ? _questions.length
                      : _generalQuestions.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: widget._mode == "Nursing"
                            ? ListTile(
                                title: Text(_questions[index].question.length >
                                        60
                                    ? "${_questions[index].question.substring(0, 60)}..."
                                    : _questions[index].question.contains("?")
                                        ? _questions[index].question
                                        : "${_questions[index].question}?"),
                                trailing: Icon(Icons.delete),
                                onTap: () {
                                  if (!_checkVal) {
                                    ShowDialogs(context)
                                        .showRemoveQuestionDialog(
                                      "Are you sure you want to delete this question?",
                                      _questions[index].question.length > 15
                                          ? "${_questions[index].question.substring(0, 15)}..."
                                          : _questions[index].question,
                                      () {
                                        Navigator.pop(context);
                                        DatabaseProvider().deleteQuestion(
                                            _questions[index].docId,
                                            widget._mode);
                                      },
                                      () {
                                        Navigator.pop(context);
                                      },
                                      (val) {
                                        setState(() {
                                          _checkVal = val;
                                        });
                                      },
                                    );
                                  } else {
                                    DatabaseProvider().deleteQuestion(
                                        _questions[index].docId, widget._mode);
                                  }
                                },
                              )
                            : ListTile(
                                title: Text(_generalQuestions[index]
                                            .question
                                            .length >
                                        60
                                    ? "${_generalQuestions[index].question.substring(0, 60)}..."
                                    : _generalQuestions[index]
                                            .question
                                            .contains("?")
                                        ? _generalQuestions[index].question
                                        : "${_generalQuestions[index].question}?"),
                                trailing: Icon(Icons.delete),
                                onTap: () {
                                  if (!_checkVal) {
                                    ShowDialogs(context)
                                        .showRemoveQuestionDialog(
                                      "Are you sure you want to delete this question?",
                                      _generalQuestions[index].question.length >
                                              15
                                          ? "${_generalQuestions[index].question.substring(0, 15)}..."
                                          : _generalQuestions[index].question,
                                      () {
                                        Navigator.pop(context);
                                        DatabaseProvider().deleteQuestion(
                                            _generalQuestions[index].docId,
                                            widget._mode);
                                      },
                                      () {
                                        Navigator.pop(context);
                                      },
                                      (val) {
                                        setState(() {
                                          _checkVal = val;
                                        });
                                      },
                                    );
                                  } else {
                                    DatabaseProvider().deleteQuestion(
                                        _generalQuestions[index].docId,
                                        widget._mode);
                                  }
                                },
                              ),
                      ),
                    );
                  }),
            ),
          
          ],
        ));
  }
}
