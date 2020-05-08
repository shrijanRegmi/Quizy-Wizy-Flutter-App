import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final _controller;
  final _title;

  AuthField(this._controller, this._title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xff707070).withOpacity(0.6)),
          borderRadius: BorderRadius.circular(
            50.0,
          )),
      child: TextFormField(
        controller: _controller,
        obscureText: _title == "Password" ? true : false,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: _title,
            hintStyle: TextStyle(color: Color(0xff707070).withOpacity(0.6))),
      ),
    );
  }
}
