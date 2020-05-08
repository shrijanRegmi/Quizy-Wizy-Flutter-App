import 'package:flutter/material.dart';
import 'package:quizy_wizy/screens/widgets/auth_field.dart';
import 'package:quizy_wizy/screens/widgets/normal_btn.dart';
import 'package:quizy_wizy/services/auth/auth_provider.dart';

class SignUpSection extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final Function _changePage;
  final Function _loadAd;
  SignUpSection(this._scaffoldKey, this._changePage, this._loadAd);

  @override
  _SignUpSectionState createState() => _SignUpSectionState();
}

class _SignUpSectionState extends State<SignUpSection> {
  final TextEditingController _nameController = TextEditingController();
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
                width: MediaQuery.of(context).size.width,
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            if (!_showProgressBar) {
                              widget._changePage();
                            }
                          },
                        ),
                        !_showProgressBar
                            ? Text("Sign up",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold))
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
                                  Text("Sign up",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                        SizedBox(
                          width: 50.0,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Column(
                      children: <Widget>[
                        AuthField(_nameController, "Name"),
                        SizedBox(
                          height: 10.0,
                        ),
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
                    NormalBtn("CREATE ACCOUNT", Colors.black, () async {
                      if (!_showProgressBar) {
                        FocusScope.of(context).unfocus();
                        if (_emailController.text != "" &&
                            _passController.text != "" &&
                            _nameController.text != "") {
                          widget._loadAd();
                          setState(() {
                            _showProgressBar = true;
                          });
                          final _result = await AuthProvider().signUpUser(
                              _nameController.text.trim(),
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
                                  "Unexpected error occured! If this error continues, please try again with different email"),
                            ));
                          }
                        }
                      }
                    }),
                    SizedBox(
                      height: 30.0,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
