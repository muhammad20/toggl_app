import 'package:flutter/material.dart';

class TogglInputField extends StatelessWidget {
  final String title;
  final String hintText;
  final Stream stream;
  final TextEditingController controller;
  final bool obscureText;

  TogglInputField(this.title, this.hintText, this.stream, this.controller,
      {this.obscureText});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: this.stream,
      builder: (context, snapshot) {
        return TextFormField(
          controller: this.controller,
          obscureText: this.obscureText ?? false,
          style: TextStyle(
            color: Colors.white70,
          ),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            errorText: snapshot.data,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.white54,
              fontSize: 14.0,
            ),
          ),
        );
      },
    );
  }
}
