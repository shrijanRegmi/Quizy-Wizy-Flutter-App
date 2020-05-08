import 'package:flutter/material.dart';
import 'package:quizy_wizy/models/functions/show_dialogs.dart';
import 'package:quizy_wizy/screens/widgets/normal_btn.dart';
import 'package:quizy_wizy/services/database/database_provider.dart';

class AddQuestionScreen extends StatefulWidget {
  final String _mode;
  AddQuestionScreen(this._mode);
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  TextEditingController _questionController = TextEditingController();
  TextEditingController _optionAController = TextEditingController();
  TextEditingController _optionBController = TextEditingController();
  TextEditingController _optionCController = TextEditingController();
  TextEditingController _optionDController = TextEditingController();
  TextEditingController _correctAnsController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add ${widget._mode} Question"),
        backgroundColor: Colors.black.withOpacity(0.8),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                _inputFields(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputFields() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _questionField(),
          SizedBox(
            height: 40.0,
          ),
          _optionAField(),
          SizedBox(
            height: 10.0,
          ),
          _optionBField(),
          SizedBox(
            height: 10.0,
          ),
          _optionCField(),
          SizedBox(
            height: 10.0,
          ),
          _optionDField(),
          SizedBox(
            height: 40.0,
          ),
          _correctAndField(),
          SizedBox(
            height: 20.0,
          ),
          NormalBtn("Submit", Colors.black, () async {
            FocusScope.of(context).unfocus();
            if (_questionController.text != "" &&
                _optionAController.text != "" &&
                _optionBController.text != "" &&
                _optionCController.text != "" &&
                _optionDController.text != "" &&
                _correctAnsController.text != "") {
              var _question = _questionController.text.trim();
              var _optionA = _optionAController.text.trim();
              var _optionB = _optionBController.text.trim();
              var _optionC = _optionCController.text.trim();
              var _optionD = _optionDController.text.trim();
              var _correctAns = _correctAnsController.text.trim();

              ShowDialogs(context).showProgressBar(true);
              await DatabaseProvider().sendQuestion(widget._mode, _question,
                  _optionA, _optionB, _optionC, _optionD, _correctAns);
              ShowDialogs(context).showProgressBar(false);
              _questionController.clear();
              _optionAController.clear();
              _optionBController.clear();
              _optionCController.clear();
              _optionDController.clear();
              _correctAnsController.clear();

              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("Question Added Successfully"),
              ));
            } else {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text("Please fill all the fields to continue"),
              ));
            }
          })
        ],
      ),
    );
  }

  Widget _questionField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        minLines: 1,
        maxLines: 5,
        controller: _questionController,
        decoration: InputDecoration(
            labelText: "Question", border: OutlineInputBorder()),
      ),
    );
  }

  Widget _optionAField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        controller: _optionAController,
        minLines: 1,
        maxLines: 5,
        decoration: InputDecoration(
            labelText: "Option A", border: OutlineInputBorder()),
      ),
    );
  }

  Widget _optionBField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        controller: _optionBController,
        minLines: 1,
        maxLines: 5,
        decoration: InputDecoration(
            labelText: "Option B", border: OutlineInputBorder()),
      ),
    );
  }

  Widget _optionCField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        controller: _optionCController,
        minLines: 1,
        maxLines: 5,
        decoration: InputDecoration(
            labelText: "Option C", border: OutlineInputBorder()),
      ),
    );
  }

  Widget _optionDField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        controller: _optionDController,
        minLines: 1,
        maxLines: 5,
        decoration: InputDecoration(
            labelText: "Option D", border: OutlineInputBorder()),
      ),
    );
  }

  Widget _correctAndField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        controller: _correctAnsController,
        minLines: 1,
        maxLines: 5,
        decoration: InputDecoration(
            labelText: "Correct Answer", border: OutlineInputBorder()),
      ),
    );
  }
}
