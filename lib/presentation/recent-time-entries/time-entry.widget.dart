import 'package:flutter/material.dart';
import 'package:toggl_app/presentation/detailed-time-entry/detailed-time-entry.screen.dart';

class TimeEntryCard extends StatelessWidget {
  final String title;
  final String projectName;
  final String clientName;
  final String duration;
  final DateTime startDate;
  final DateTime endDate;

  TimeEntryCard(
      this.startDate, this.endDate, this.projectName, this.clientName, this.title, this.duration);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DetailedTimeEntryScreen(
            this.clientName,
            this.projectName,
            this.title,
            this.startDate,
            this.endDate,
            this.duration
          ),
        ));
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 10,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 2.0, spreadRadius: 1.0)
            ],
            borderRadius: BorderRadius.circular(5.0)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      this.title,
                      style: TextStyle(
                        fontSize: 26.0,
                        color: Colors.black54,
                      ),
                    ),
                    Row(
                      children: [Text('duration: '), Text('${this.duration}s')],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [Text('Project: '), Text(this.projectName)],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Row(
                  children: [Text('Client: '), Text(this.clientName)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
