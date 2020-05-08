import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quizy_wizy/screens/authentication/login_section.dart';
import 'package:quizy_wizy/screens/authentication/signUp_section.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  ScrollController _c;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _c = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.lightBlue,
      body: SafeArea(
        child: Container(
          color: Colors.lightBlue,
          child: Column(
            children: <Widget>[
              _topSection(),
              _authSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topSection() {
    return Expanded(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -40.0,
            left: -40.0,
            child: SvgPicture.asset("images/auth_page_top.svg"),
          ),
          Positioned(
            bottom: -100.0,
            right: -100.0,
            child: SvgPicture.asset("images/auth_page_bottom.svg"),
          ),
          Container(
            child: Center(
              child: Text(
                "Quizy Wizy",
                style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _authSection() {
    return Expanded(
      flex: 2,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -100.0,
            right: -100.0,
            child: SvgPicture.asset("images/auth_page_bottom.svg"),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
            ),
            child: PageView(
              controller: _c,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                LoginSection(_scaffoldKey, () {
                  _c.animateTo(MediaQuery.of(context).size.width,
                      duration: Duration(seconds: 1), curve: Curves.ease);
                }, () async {}),
                SignUpSection(_scaffoldKey, () {
                  _c.animateTo(-1,
                      duration: Duration(seconds: 1), curve: Curves.ease);
                }, () async {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
