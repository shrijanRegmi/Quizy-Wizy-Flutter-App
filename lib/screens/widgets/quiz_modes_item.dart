import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class QuizModesItem extends StatelessWidget {
  final String _title;
  final String _subTitle;
  final String _img;
  final Function _function;
  QuizModesItem(this._title, this._subTitle, this._img, this._function);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _function,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  offset: Offset(3, 3),
                  blurRadius: 10.0,
                )
              ]),
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_subTitle,
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.w600,
                          fontSize: 10.0,
                        )),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(_title,
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800)),
                    Container(
                        height: 50.0,
                        width: 50.0,
                        child: Center(child: SvgPicture.asset(_img))),
                  ],
                ),
              ),
              Positioned(
                right: 0.0,
                top: 0.0,
                child: SvgPicture.asset("images/mode.svg"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
