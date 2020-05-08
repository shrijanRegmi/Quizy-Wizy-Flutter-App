import 'package:flutter/material.dart';

class NormalBtn extends StatelessWidget {
  final Function _function;
  final String _title;
  final Color _color;
  NormalBtn(this._title, this._color, this._function);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: _color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.0),
      ),
      onPressed: _function,
      textColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
            width: MediaQuery.of(context).size.width,
            child: Center(child: Text(_title))),
      ),
    );
  }
}
