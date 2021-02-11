import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toggl_app/bloc/recent-time-entries.bloc.dart';
import 'package:toggl_app/core/usecases/view-recent-time-entries/view-recent-time-entries.viewmodel.dart';
import 'package:toggl_app/presentation/recent-time-entries/time-entry.widget.dart';
import 'package:intl/intl.dart';

class RecentTimeEntriesScreen extends StatelessWidget {
  final String _fullName;
  final RecentTimeEntriesBloc _bloc;
  RecentTimeEntriesScreen(this._fullName, this._bloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 10, bottom: 10.0),
              child: Text(
                'Hi, $_fullName',
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 24.0,
                    color: Theme.of(context).scaffoldBackgroundColor),
              ),
            ),
            Container(
              height: 1.0,
              width: MediaQuery.of(context).size.width,
              color: Colors.black45,
            ),
            Flexible(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _bloc.getRecentMonthTimeEntries();
                },
                child: StreamBuilder<RecentTimeEntriesViewModel>(
                  stream: this._bloc.recentTimeEntriesStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('An error has occured');
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        child: Platform.isIOS
                            ? CupertinoActivityIndicator()
                            : CircularProgressIndicator(),
                      );
                    }
                    var _listItems = _groupByDate(snapshot.data, context);
                    return ListView.builder(
                      itemCount: _listItems.length,
                      itemBuilder: (context, index) => _listItems[index],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _groupByDate(
      RecentTimeEntriesViewModel timeEntriesViewModel, BuildContext context) {
    var entries = timeEntriesViewModel.timeEntries;
    var currentDate = entries[0].endDate;
    List<DateTime> _dates = [];
    _dates.add(currentDate);

    Map<DateTime, List<TimeEntryItem>> _grouped = {};
    _grouped[currentDate] = List<TimeEntryItem>();
    _grouped[currentDate].add(entries[0]);

    for (int i = 1; i < entries.length; i++) {
      if (entries[i].endDate.day == currentDate.day) {
        _grouped[currentDate].add(entries[i]);
      } else {
        currentDate = entries[i].endDate;
        _dates.add(currentDate);
        _grouped[currentDate] = List<TimeEntryItem>();
        _grouped[currentDate].add(entries[i]);
      }
    }

    /// now `_grouped` contains a list of time entries for every non empty work day.
    return _constructTimeEntriesViewList(_dates, _grouped, context);
  }

  List<Widget> _constructTimeEntriesViewList(_dates,
      Map<DateTime, List<TimeEntryItem>> _grouped, BuildContext context) {
    List<Widget> _view = [];
    _dates.forEach((date) {
      int _dayTotalDuration = 0;
      _view.add(_DayName(date));
      _grouped[date].forEach((element) {
        _dayTotalDuration += int.parse(element.totalDuration);
        _view.add(
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 22,
                vertical: 10.0),
            child: TimeEntryCard(
              element.startDate,
              element.endDate,
              element.projectName,
              element.clientName,
              element.title,
              element.totalDuration,
            ),
          ),
        );
      });
      _view.add(
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 22,
              vertical: 5.0),
          child: Text(
            'On this day you worked a total of ${_dayTotalDuration.toString()}s',
            style: TextStyle(
                fontFamily: 'Raleway', fontSize: 14.0, color: Colors.black87),
          ),
        ),
      );
    });

    return _view;
  }
}

class _DayName extends StatelessWidget {
  final DateTime date;
  _DayName(this.date);

  @override
  Widget build(BuildContext context) {
    String _displayedDate;
    DateTime now = DateTime.now();
    if (now.day == date.day &&
        now.month == date.month &&
        now.year == date.year) {
      _displayedDate = 'Today';
    } else if (now.day == date.day + 1 &&
        now.month == date.month &&
        now.year == date.year) {
      _displayedDate = 'Yesterday';
    } else {
      DateFormat formatter = DateFormat('dd-mm-yyyy');
      _displayedDate = formatter.format(this.date);
    }

    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: Text(
        _displayedDate,
        style: TextStyle(fontSize: 36.0, color: Colors.black87),
      ),
    );
  }
}
