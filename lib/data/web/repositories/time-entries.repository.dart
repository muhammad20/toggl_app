import 'dart:async';

import 'package:toggl_app/core/entities/time-entry.dart';
import 'package:toggl_app/core/interfaces/repositories/time-entries.repository.dart';
import 'package:toggl_app/data/persistence/shared-prefs-user-info.persistence.dart';
import 'package:toggl_app/data/web/web-client.dart';

class TimeEntriesWebRepository implements ITimeEntriesRepository {
  @override
  Stream<List<TimeEntry>> getRecentMonthTimeEntries() {
    StreamController<List<TimeEntry>> controller =
        StreamController<List<TimeEntry>>();
    DateTime now = DateTime.now();
    DateTime aMonthEarlier = now.subtract(Duration(days: 30));
    Map<String, String> _queries = {
      'start_date': '${aMonthEarlier.toIso8601String()}Z',
      'end_date': '${now.toIso8601String()}Z'
    };
    var client =
        WebClient(tokenProvider: SharedPrefsUerInfoPersistence.getInstance());
    client
        .request('time_entries', HttpMethod.GET, queries: _queries)
        .then((response) {
      _responseToTimeEntryList(response).then((value) {
        controller.add(value);
        controller.close();
      });
    }).catchError((e) {
      controller.add([]);
      controller.close();
    });
    return controller.stream;
  }

  Future<List<TimeEntry>> _responseToTimeEntryList(
      List<dynamic> response) async {
    List<TimeEntry> timeEntries = [];
    try {
      for (var i = 0; i < response.length; i++) {
        var element = response[i];
        int projectId = element['pid'];
        Map<String, String> projectAndClientNames =
            await _getProjectAndClientNames(projectId);
        timeEntries.add(
          TimeEntry(
            element['description'],
            projectAndClientNames['project_name'],
            projectAndClientNames['client_name'],
            DateTime.parse(element['start']),
            DateTime.parse(element['stop']),
            element['id'],
            element['duration'].toString(),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
    // print(timeEntries);
    return timeEntries;
  }

  Future<Map<String, String>> _getProjectAndClientNames(int projectId) async {
    Map<String, String> projectAndClientNames = Map<String, String>();
    var client =
        WebClient(tokenProvider: SharedPrefsUerInfoPersistence.getInstance());
    try {
      var response =
          await client.request('projects/$projectId', HttpMethod.GET);
      projectAndClientNames['project_name'] = response['data']['name'];
      int clientId = response['data']['cid'];

      // to handle missing client name alone for consistency.
      try {
        response = await client.request('clients/$clientId', HttpMethod.GET);
        projectAndClientNames['client_name'] = response['data']['name'];
      } catch (e) {
        projectAndClientNames['client_name'] = '';
      }
    } catch (e) {
      // handles both missing values.
      projectAndClientNames['project_name'] = '';
      projectAndClientNames['client_name'] = '';
    }
    return projectAndClientNames;
  }

  @override
  Stream<TimeEntry> getTimeEntry() {
    // TODO: implement getTimeEntry
    throw UnimplementedError();
  }
}
