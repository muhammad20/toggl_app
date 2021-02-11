import 'package:flutter/material.dart';

class TogglButton extends StatelessWidget {
  final Widget content;
  final Function onPressed;

  TogglButton(this.content, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        onPressed: this.onPressed,
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 11.0),
              child: this.content,
            ),
          ),
        ),
      ),
    );
  }
}
