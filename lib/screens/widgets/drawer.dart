import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizy_wizy/models/firebase_model/stats.dart';
import 'package:quizy_wizy/models/firebase_model/user.dart';
import 'package:quizy_wizy/screens/home/admin_pannel.dart';
import 'package:quizy_wizy/services/auth/auth_provider.dart';
import 'package:quizy_wizy/services/database/database_provider.dart';

class MyDrawer extends StatefulWidget {
  final String _userName;
  final String _userEmail;
  final List<UserDetail> _usersList;
  MyDrawer(this._userName, this._userEmail, this._usersList);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool _btnPressed = false;
 

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserDetail>(context);
    print(_user.uid);
    return Drawer(
      child: Container(
          color: Colors.blue,
          child: LayoutBuilder(
            builder: (_, constraints) {
              if (!_btnPressed) {
                return ListView(
                  children: <Widget>[
                    Container(
                      color: Colors.blueAccent,
                      height: 180.0,
                      child: UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                          ),
                          currentAccountPicture: CircleAvatar(
                            child: Text(widget._userName.substring(0, 1),
                                style: TextStyle(
                                    fontSize: 32.0, color: Colors.white)),
                          ),
                          accountName: Text(widget._userName),
                          accountEmail: Text(widget._userEmail)),
                    ),
                    Container(
                      constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - 200),
                      color: Colors.deepPurple,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              ListTile(
                                title: Text("Leaderboard",
                                    style: TextStyle(color: Colors.white)),
                                trailing: Icon(
                                  Icons.equalizer,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  setState(() {
                                    _btnPressed = true;
                                  });
                                },
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Divider(
                                  color: Colors.white,
                                ),
                              ),
                              _user.uid == "Dpqt0IwTLvhQhKl7BKtwnTC1u8Z2"
                                  ? ListTile(
                                      title: Text("Admin Pannel",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      trailing: Icon(
                                        Icons.settings,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => AdminPannel()));
                                      },
                                    )
                                  : Container(),
                              ListTile(
                                title: Text("Log out",
                                    style: TextStyle(color: Colors.white)),
                                trailing: Icon(
                                  Icons.exit_to_app,
                                  color: Colors.white,
                                ),
                                onTap: () async {
                                  
                                  Navigator.pop(context);
                                  AuthProvider().signOut();
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: Text("Rank",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0)),
                      ),
                      title: Text("Player",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      trailing: Text("Points",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(color: Colors.white),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: widget._usersList.length,
                          itemBuilder: (_, index) {
                            return StreamBuilder<UserStat>(
                                stream: DatabaseProvider(
                                        uid: widget._usersList[index].uid)
                                    .userStat,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListTile(
                                      leading: widget._usersList[index] ==
                                              widget._usersList.first
                                          ? Icon(Icons.star,
                                              color: widget._usersList[index]
                                                          .uid ==
                                                      _user.uid
                                                  ? Colors.black45
                                                  : Colors.white)
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 3.0, left: 7.0),
                                              child: Text("${index + 1}",
                                                  style: TextStyle(
                                                      fontWeight: widget
                                                                  ._usersList[
                                                                      index]
                                                                  .uid ==
                                                              _user.uid
                                                          ? FontWeight.bold
                                                          : FontWeight.w400,
                                                      color: widget
                                                                  ._usersList[
                                                                      index]
                                                                  .uid ==
                                                              _user.uid
                                                          ? Colors.black45
                                                          : Colors.white)),
                                            ),
                                      title: Text(
                                          widget._usersList[index].userName,
                                          style: TextStyle(
                                              fontWeight: widget
                                                          ._usersList[index]
                                                          .uid ==
                                                      _user.uid
                                                  ? FontWeight.bold
                                                  : FontWeight.w400,
                                              color: widget._usersList[index]
                                                          .uid ==
                                                      _user.uid
                                                  ? Colors.black45
                                                  : Colors.white)),
                                      trailing: Text("${snapshot.data.points}",
                                          style: TextStyle(
                                              fontWeight: widget
                                                          ._usersList[index]
                                                          .uid ==
                                                      _user.uid
                                                  ? FontWeight.bold
                                                  : FontWeight.w400,
                                              color: widget._usersList[index]
                                                          .uid ==
                                                      _user.uid
                                                  ? Colors.black45
                                                  : Colors.white)),
                                    );
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                });
                          }),
                    ),
                  ],
                );
              }
            },
          )),
    );
  }
}
