import 'package:flutter/material.dart';
import 'package:toggl_app/bloc/recent-time-entries.bloc.dart';
import 'package:toggl_app/core/usecases/login/login.viewmodel.dart';
import 'package:toggl_app/presentation/recent-time-entries/recent-time-entries.screen.dart';
import 'package:toggl_app/presentation/settings/settings.screen.dart';

class HomeScreen extends StatefulWidget {
  final LoginViewModel _viewmodel;
  HomeScreen(this._viewmodel);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Widget> _views;

  @override
  initState() {
    super.initState();
    _views = [
      RecentTimeEntriesScreen(
          widget._viewmodel.fullname, RecentTimeEntriesBloc()),
      SettingsScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.9,
        child: this._views[this._currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        currentIndex: this._currentIndex,
        selectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Time Entries'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onTap: (index) {
          setState(() {
            this._currentIndex = index;
          });
        },
      ),
    );
  }
}
