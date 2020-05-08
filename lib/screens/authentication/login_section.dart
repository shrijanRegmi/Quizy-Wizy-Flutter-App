import 'package:flutter/material.dart';
import 'package:quizy_wizy/screens/widgets/auth_field.dart';
import 'package:quizy_wizy/screens/widgets/normal_btn.dart';
import 'package:quizy_wizy/services/auth/auth_provider.dart';

class LoginSection extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final Function _changePage;
  final Function _loadAd;
  LoginSection(this._scaffoldKey, this._changePage, this._loadAd);

  @override
  _LoginSectionState createState() => _LoginSectionState();
}

class _LoginSectionState extends State<LoginSection> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _showProgressBar = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20.0),
        child: LayoutBuilder(
          builder: (_, constraints) {
            return ListView(
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      !_showProgressBar
                          ? Text("Log in",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22.0, fontWeight: FontWeight.bold))
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text("Log in",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Column(
                        children: <Widget>[
                          AuthField(_emailController, "Email"),
                          SizedBox(
                            height: 10.0,
                          ),
                          AuthField(_passController, "Password"),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      NormalBtn("LOGIN", Colors.black, () async {
                        if (!_showProgressBar) {
                          FocusScope.of(context).unfocus();
                          if (_emailController.text != "" &&
                              _passController.text != "") {
                            widget._loadAd();
                            setState(() {
                              _showProgressBar = true;
                            });
                            final _result = await AuthProvider().loginUser(
                                _emailController.text.trim(),
                                _passController.text.trim());

                            if (_result.contains("myError")) {
                              print(_result);
                              setState(() {
                                _showProgressBar = false;
                              });
                              widget._scaffoldKey.currentState
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    "Unexpected error occured! Please try again"),
                              ));
                            }
                          }
                        }
                      }),
                      SizedBox(
                        height: 30.0,
                      ),
                      GestureDetector(
                          onTap: () {
                            if (!_showProgressBar) {
                              widget._changePage();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20.0),
                            color: Colors.transparent,
                            child: Center(
                              child: Text(
                                  "Don't have an account? Create one here",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )),
                      SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ));
  }
}
