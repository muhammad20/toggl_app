import 'package:toggl_app/core/entities/time-entry.dart';

abstract class ITimeEntriesRepository {
  // get all time entries for user story 2
  Stream<List<TimeEntry>> getRecentMonthTimeEntries();

  // get details of a time entry for user story 3
  Stream<TimeEntry> getTimeEntry();
}