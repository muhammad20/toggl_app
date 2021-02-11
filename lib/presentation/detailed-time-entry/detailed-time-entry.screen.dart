import 'package:flutter/material.dart';

class DetailedTimeEntryScreen extends StatelessWidget {
  final String _title;
  final String _clientName;
  final String _projetName;
  final DateTime _startDate;
  final DateTime _endDate;
  final String _duration;

  DetailedTimeEntryScreen(this._clientName, this._projetName, this._title,
      this._startDate, this._endDate, this._duration);

  final _detailTextStyle =
      TextStyle(color: Colors.black45, fontSize: 24.0, fontFamily: 'Raleway');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 20,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  Text(
                    _title,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 36.0,
                      fontFamily: 'Raleway',
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 4),
                child: Text('You started at: '),
              ),
              Text(
                this._startDate.toString().substring(0, 19),
                style: _detailTextStyle,
              ),
              Text('You finished at: '),
              Text(this._endDate.toString().substring(0, 19),
                  style: _detailTextStyle),
              Text('You are working on: '),
              Text(
                this._projetName,
                style: _detailTextStyle,
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'With client',
                ),
              ),
              Text(
                this._clientName,
                style: _detailTextStyle,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, right: 8.0),
                    child: Text(
                      'You worked for:',
                    ),
                  ),
                  Text(
                    '${this._duration}s',
                    style: _detailTextStyle,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
